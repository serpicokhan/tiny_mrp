from django.shortcuts import render, get_object_or_404
from mrp.models import *

import jdatetime
from django.db import IntegrityError
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import JsonResponse
from mrp.business.DateJob import *
from datetime import datetime, timedelta
from django.contrib.contenttypes.models import ContentType
from django.contrib.auth.decorators import permission_required
from django.contrib.auth.context_processors import PermWrapper
from django.contrib.auth.decorators import login_required
from django.template.loader import render_to_string
from mrp.business.tolid_util import *
import datetime
from django.core.exceptions import ValidationError
from rest_framework import generics
from mrp.models import BillOfMaterials
from mrp.serializers import BillOfMaterialsSerializer
from mrp.forms import BOMForm,BomComponentForm

def bom_list(request):
    return render(request,"mrp/bom/partialBOMList.html",{})

class BOMListView(generics.ListAPIView):
    serializer_class = BillOfMaterialsSerializer
    
    def get_queryset(self):
        return BillOfMaterials.objects.select_related('product')\
                                     .prefetch_related('bomcomponent_set__product', 
                                                     'bomcomponent_set__uom')\
                                     .order_by('reference')

class BOMDetailedListView(generics.ListAPIView):
    serializer_class = BillOfMaterialsSerializer

    def get_queryset(self):
        product_id = self.kwargs.get('product_id')
        return BillOfMaterials.objects.filter(product__id=product_id)\
                                     .select_related('product')\
                                     .prefetch_related('bomcomponent_set__product', 
                                                      'bomcomponent_set__uom')\
                                     .order_by('reference')

def save_bom_form(request, form, template_name):
    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}
    data['html_bom_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)

def save_bom_component_form(request, form, template_name, bom_id):
    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            components=BOMComponent.objects.filter(bom__id=bom_id)
            data["html_component_list"]=render_to_string('mrp/bom/component/partialComponentList.html', {
                'components': components,
                'perms': PermWrapper(request.user)
            })
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form,'bom_id':bom_id}
    data['html_bom_component_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)

def create_bom(request):
    if (request.method == 'POST'):
        form = BOMForm(request.POST)
        return save_bom_form(request, form, 'mrp/bom/partialBOMCreate.html')
    else:
        form = BOMForm()
        return save_bom_form(request, form, 'mrp/bom/partialBOMCreate.html')

def edit_bom(request, id):
    """ویرایش BOM"""
    bom = get_object_or_404(BillOfMaterials, id=id)
    
    if request.method == 'POST':
        form = BOMForm(request.POST, instance=bom)
        return save_bom_form(request, form, 'mrp/bom/partialBOMCreate.html')
    else:
        form = BOMForm(instance=bom)
        return save_bom_form(request, form, 'mrp/bom/partialBOMCreate.html')

def create_bom_component(request, id):
    if (request.method == 'POST'):
        form = BomComponentForm(request.POST)
        return save_bom_component_form(request, form, 'mrp/bom/component/partialBomComponentCreate.html', id)
    else:
        form = BomComponentForm(initial={'bom': id})
        return save_bom_component_form(request, form, 'mrp/bom/component/partialBomComponentCreate.html', id)

def delete_bom_component(request, id):
    """حذف Component"""
    data = dict()
    
    if request.method == 'POST':
        try:
            component = get_object_or_404(BOMComponent, id=id)
            bom_id = component.bom.id
            component.delete()
            
            # بارگذاری مجدد لیست components
            components = BOMComponent.objects.filter(bom__id=bom_id)
            data['form_is_valid'] = True
            data["html_component_list"] = render_to_string('mrp/bom/component/partialComponentList.html', {
                'components': components,
                'perms': PermWrapper(request.user)
            })
        except Exception as e:
            data['form_is_valid'] = False
            data['error'] = str(e)
    
    return JsonResponse(data)

def view_bom(request, id):
    data = dict()
    bom = get_object_or_404(BillOfMaterials, id=id)
    components = BOMComponent.objects.filter(bom=bom)
    
    data["html_bom_view_form"] = render_to_string('mrp/bom/partialBOMView.html', {
        'bom_id': id,
        'bom': bom,
        'components': components,
        'perms': PermWrapper(request.user)
    }, request=request)
    
    return JsonResponse(data)

def get_bom_components(request, bom_id):
    """API view to get BOM components"""
    try:
        bom = BillOfMaterials.objects.get(id=bom_id)
        components = BOMComponent.objects.filter(bom=bom).select_related('product', 'uom')
        
        components_data = []
        for component in components:
            # محاسبه موجودی (این بخش بستگی به منطق کسب‌وکار شما دارد)
            available_qty = calculate_available_quantity(component.product)
            
            components_data.append({
                'id': component.id,
                'product_id': component.product.id,
                'product_name': component.product.name,
                'quantity': float(component.quantity),
                'uom': component.uom.name,
                'uom_name': component.uom.name,
                'available': float(available_qty)  # موجودی واقعی
            })
        
        return JsonResponse({
            'bom_id': bom_id,
            'bom_reference': bom.reference,
            'components': components_data
        })
        
    except BillOfMaterials.DoesNotExist:
        return JsonResponse({
            'error': 'BOM not found'
        }, status=404)
    except Exception as e:
        return JsonResponse({
            'error': str(e)
        }, status=500)

def calculate_available_quantity(product):
    """تابع برای محاسبه موجودی محصول - این را بر اساس منطق خود پیاده‌سازی کنید"""
    # مثال ساده:
    try:
        # inventory =Product.objects.filter(product=product).first()
        return product.available_quantity if product else 0
    except:
        return 0