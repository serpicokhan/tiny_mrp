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
import random
from django.core.cache import cache

def manufacture_order_list(request):
    return render(request,"mrp/manufactureorder/mOrderList.html",{})

def manufacture_order_calendar(request):
    lines=Line.objects.all()
    orders = ManufacturingOrder.objects.all()
    event_quantities = CalendarEvent.objects.values('order_id').annotate(
        total_quantity=Sum('quantity')
    ).filter(order_id__in=[order.id for order in orders])
    
    # Create a dictionary for quick lookup
    quantity_map = {item['order_id']: item['total_quantity'] for item in event_quantities}

    # Create list of dictionaries for draggable items
    morders = [
        {
            "id": order.id,
            "title": order.reference,
            "quantity": max(0, order.quantity_to_produce - quantity_map.get(order.id, 0)),
            "type": "order"
        }
        for order in orders
    ]

    # morders = [
    #     {"id": 1, "title": "Order 1", "quantity": 2000, "type": "order"},
    #     {"id": 2, "title": "Order 2", "quantity": 1000, "type": "order"},
    # ]
    # Vacations
    vacations = [
        {"id": "v1", "title": "Team Vacation", "type": "vacation"},
        {"id": "v2", "title": "Manager Vacation", "type": "vacation"},
    ]
    # Off days
    offdays = [
        {"id": "o1", "title": "National Holiday", "type": "offday"},
        {"id": "o2", "title": "Maintenance Day", "type": "offday"},
    ]
    
    # Combine all draggable items
    draggable_items = morders + vacations + offdays
    
    context = {
        "draggable_items": draggable_items,
        "lines":lines,
        "daily_limit": 5000  # kg/day for orders
    }
    return render(request, "mrp/manufactureorder/calendar.html", context)
def manufacture_order_detail(request):
    return render(request,"mrp/manufactureorder/dgrok2.html",{})

def save_morder_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        

        if form.is_valid():
            print(form.cleaned_data)
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
@csrf_exempt  
def update_morder(request, id):
    company= get_object_or_404(ManufacturingOrder, id=id)
    template=""
    if (request.method == 'POST'):
        print(request.body)
        # body =json.loads(request.body)
        # print(body)
        

        # data = request.POST.dict()
        # data['reference']=body['reference']
        # data['line']=body['line']
        # data['product_to_manufacture']=body['product_to_manufacture']
        # data['quantity_to_produce']=body['quantity_to_produce']
        # data['bom']=body['bom']
        # data['status']=body['status']
        # data['responsible']=body['responsible']
        # data['customer']=body['customer']
        # data['scheduled_date']=DateJob.getTaskDate(body['scheduled_date'])
        # data['first_date']=DateJob.getTaskDate(body['first_date'])
        # data['second_date']=DateJob.getTaskDate(body['second_date'])
        form = ManufacturingOrderForm(request.POST, instance=company)
    else:
        form = ManufacturingOrderForm(instance=company)


    return save_morder_form(request, form,"mrp/manufactureorder/partialMOrderUpdate.html")
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
    
@csrf_exempt
def bulk_create_events(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            events = data.get('events', [])
            saved_events = []

            for event_data in events:
                title = event_data.get('title')
                event_date = event_data.get('start')
                quantity = event_data.get('quantity', 0)
                order_id = event_data.get('orderId')
                event_type = event_data.get('type', 'order')
                description = event_data.get('description', '')
                temp_id = event_data.get('tempId')
                print(title,event_data,'$$$$$$$$$$$$$$$$$$')
                if not title or not event_date:
                    return JsonResponse({
                        'success': False,
                        'error': 'عنوان و تاریخ رویداد الزامی هستند.'
                    }, status=400)

                event_dict = {
                    'title': title,
                    'quantity': float(quantity),
                    'event_date': datetime.datetime.strptime(event_date, '%Y-%m-%d').date(),
                    'type': event_type,
                    'description': description
                }

                if order_id:
                    try:
                        order = ManufacturingOrder.objects.get(id=order_id)
                        event_dict['order'] = order
                    except ManufacturingOrder.DoesNotExist:
                        return JsonResponse({
                            'success': False,
                            'error': f'سفارش با شناسه {order_id} یافت نشد.'
                        }, status=404)

                event = CalendarEvent.objects.create(**event_dict)
                saved_events.append({
                    'id': f"event-{event.id}",
                    'tempId': temp_id,
                    'title': event.title,
                    'start': event.event_date.isoformat(),
                    'backgroundColor': 'red' if event.order else '#e7f1ff',
                    'extendedProps': {
                        'quantity': event.quantity,
                        'orderId': event.order.id if event.order else None,
                        'originalTitle': event.title.split(" - ")[0] if " - " in event.title else event.title,
                        'originalQuantity': event.order.quantity_to_produce if event.order else event.quantity,
                        'type': event_type,
                        'is_new': False
                    }
                })

            return JsonResponse({
                'success': True,
                'events': saved_events
            })

        except ValueError as e:
            return JsonResponse({
                'success': False,
                'error': f'داده نامعتبر: {str(e)}'
            }, status=400)
        except Exception as e:
            return JsonResponse({
                'success': False,
                'error': f'خطای سرور: {str(e)}'
            }, status=500)

    return JsonResponse({
        'success': False,
        'error': 'درخواست نامعتبر'
    }, status=400)
def get_order_calendar_info(request):
    data = []
    user_info = CalendarEvent.objects.all()

    # Function to generate a random hex color
    def get_random_color():
        return "#{:06x}".format(random.randint(0, 0xFFFFFF))

    # Map order IDs to colors
    
    non_order_color = get_random_color()  # Single color for non-order events

    # Pre-fetch unique order IDs to assign colors
    order_ids = set(event.order.id for event in user_info if event.order)
    order_colors = cache.get('order_colors', {})
    if not order_colors:
        order_colors = {order_id: get_random_color() for order_id in order_ids}
        cache.set('order_colors', order_colors, timeout=3600)  # Cache for 1 hour
    for order_id in order_ids:
        order_colors[order_id] = get_random_color()

    for i in user_info:
        # Assign background color based on order
        background_color = order_colors.get(i.order.id) if i.order else non_order_color

        event_data = {
            'id': f"event-{i.id}",
            'title': i.title,
            'start': i.event_date.isoformat(),
            'backgroundColor': background_color,
            'extendedProps': {
                'quantity': i.quantity,
                'orderId': i.order.id if i.order else None,
                'originalTitle': i.title.split(" - ")[0] if " - " in i.title else i.title,
                'originalQuantity': i.order.quantity_to_produce if i.order else i.quantity,
                'type': i.type,
                'description': i.description,
                'is_new': False  # Assume all database events are saved
            }
        }
        data.append(event_data)

    return JsonResponse(data, safe=False)