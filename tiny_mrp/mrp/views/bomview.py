from django.shortcuts import render
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
from django.shortcuts import get_object_or_404
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
        # Get product_id from URL kwargs
        product_id = self.kwargs.get('product_id')
        
        # Filter BOMs by product_id and optimize queries
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
def save_bom_component_form(request, form, template_name,bom_id):


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
def create_bom_component(request,id):
    if (request.method == 'POST'):
        form = BomComponentForm(request.POST)
        return save_bom_component_form(request, form, 'mrp/bom/component/partialBomComponentCreate.html',id)
  
    else:
        
        form = BomComponentForm(initial={'bom': id})
        return save_bom_component_form(request,form, 'mrp/bom/component/partialBomComponentCreate.html',id)
def view_bom(request,id):
    data=dict()
    bom=BillOfMaterials.objects.get(id=id)
    components=BOMComponent.objects.filter(bom=bom)
    print(components)
    # print(bom.reference,"!!!!!!!!!!!")
    data["html_bom_view_form"]=render_to_string('mrp/bom/partialBOMView.html',{'bom_id':id,'bom':bom,'components':components}, request=request)
    return JsonResponse(data)