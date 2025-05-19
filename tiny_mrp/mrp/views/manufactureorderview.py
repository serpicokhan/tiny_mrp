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
from mrp.models import ManufacturingOrder
from mrp.forms import ManufacturingOrderForm
from django.views.decorators.http import require_GET
from django.contrib.auth import get_user_model
from django.contrib.auth.models import Group
from rest_framework.response import Response
from mrp.serializers import CustomerSerializer
from rest_framework.decorators import api_view

def manufacture_order_list(request):
    return render(request,"mrp/manufactureorder/mOrderList.html",{})

def manufacture_order_calendar(request):
    # morder=ManufacturingOrder.objects.all()
    # print(morder)
    morders = [
        {"id": 1, "title": "Order 1", "quantity": 2000},
        {"id": 2, "title": "Order 2", "quantity": 1000},
    ]
    context = {
        "morder": morders,
        "daily_limit": 500  # kg per day, pass to template for JS access
    }
    
    return render(request,"mrp/manufactureorder/calendar.html",context)
def manufacture_order_detail(request):
    return render(request,"mrp/manufactureorder/dgrok2.html",{})

def save_morder_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_morder_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)

def create_morder(request):
    if (request.method == 'POST'):
        form = ManufacturingOrderForm(request.POST)
        return save_morder_form(request, form, 'mrp/manufactureorder/partialMOrderCreate.html')
  
    else:
        print("!!!!!!!!!!!")
        form = ManufacturingOrderForm()
        return save_morder_form(request, form, 'mrp/manufactureorder/partialMOrderCreate.html')
@require_GET
def manufacturing_orders_api(request):
    try:
        # Fetch all manufacturing orders with related data
        manufacturing_orders = ManufacturingOrder.objects.select_related(
            'product_to_manufacture', 'bom', 'customer', 'responsible', 'work_order_template'
        ).prefetch_related('work_orders').all()

        # Serialize the data
        orders_data = []
        for order in manufacturing_orders:
            order_data = {
                'id': order.id,
                'reference': order.reference,
                'product': {
                    'id': order.product_to_manufacture.id,
                    'name': order.product_to_manufacture.name,
                    'code': order.product_to_manufacture.code,
                    'image': None,  # Product model has no image field
                } if order.product_to_manufacture else None,
                'quantity': float(order.quantity_to_produce),
                'bom': order.bom.reference if order.bom else None,
                'workOrders': [
                    {
                        'id': wo.id,
                        'workCenter': wo.work_center.name if wo.work_center else None,
                        'duration': float(wo.duration) if wo.duration else None,
                        'description': wo.operation.instructions if wo.operation and wo.operation.instructions else None
                    } for wo in order.work_orders.all()
                ],
                'status': order.status,
                'scheduledDate': order.scheduled_date.strftime('%Y-%m-%d'),
                'customer': {
                    'id': order.customer.id,
                    'name': order.customer.name
                } if order.customer else None,
                'responsible': {
                    'id': order.responsible.id,
                    'name': order.responsible.fullName  # Adjust if SysUser has a different field (e.g., full_name)
                } if order.responsible else None,
                'notes': order.notes
            }
            orders_data.append(order_data)

        return JsonResponse({'manufacturingOrders': orders_data})

    except Exception as e:
        return JsonResponse({'error': str(e)}, status=500)
@require_GET
def get_responsible_persons(request):
    try:
        group = Group.objects.get(name='managers')
        print(group,'!!!!!!!!!!!')
        # Get users in the specified group
        user_ids = get_user_model().objects.filter(groups=group).values_list('id', flat=True)
        persons = SysUser.objects.filter(userId__in=user_ids).values('id', 'fullName')
        print(persons)

        return JsonResponse({
            'responsible_persons': list(persons)
        })
    except Exception as e:
        return JsonResponse({
            'error': str(e)
        }, status=500)
    
@api_view(('GET',))
def get_customers(request):
    try:
        customers = Customer.objects.all()
        serializer = CustomerSerializer(customers, many=True)
        return Response(serializer.data)
    except Exception as e:
        return JsonResponse({
            'error': str(e)
        }, status=500)