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
from django.template.defaulttags import register
from decimal import Decimal
from django.db.models import Sum, Avg, Q
from django.db.models import Count, Sum, Avg
from collections import defaultdict

@register.filter
def mul(value, arg):
    """فیلتر template برای ضرب دو عدد"""
    try:
        return Decimal(value) * Decimal(arg)
    except (ValueError, TypeError):
        return 0

@register.filter
def sub(value, arg):
    """فیلتر template برای تفریق دو عدد"""
    try:
        return Decimal(value) - Decimal(arg)
    except (ValueError, TypeError):
        return 0
from django.core.cache import cache

def manufacture_order_list(request):
    return render(request,"mrp/manufactureorder/mOrderList.html",{})


@login_required
# views.py

def manufacture_order_detail(request, order_id):
    """صفحه جزئیات سفارش تولید"""
    order = get_object_or_404(ManufacturingOrder, id=order_id)
    
    # محاسبه اطلاعات اضافی
    components = BOMComponent.objects.filter(bom=order.bom)
    
    # دریافت داده‌های تولید روزانه مرتبط با این سفارش
    daily_productions = DailyProduction.objects.filter(
        dayOfIssue=order.scheduled_date,
    ).select_related('machine', 'shift', 'machine__assetCategory')
    
    # ساخت Work Orderهای مجازی از داده‌های تولید
    virtual_work_orders = []
    
    # گروه‌بندی بر اساس دسته‌بندی ماشین‌آلات
    category_groups = defaultdict(list)
    for production in daily_productions:
        if production.machine.assetCategory:
            category_groups[production.machine.assetCategory].append(production)
    
    # ایجاد Work Order برای هر دسته‌بندی
    for i, (category, productions) in enumerate(category_groups.items(), 1):
        # محاسبات aggregate برای این دسته‌بندی
        total_production = sum(p.production_value or 0 for p in productions)
        avg_speed = sum(p.speed or 0 for p in productions) / len(productions) if productions else 0
        total_duration = len(productions) * 8  # فرض: هر رکورد 8 ساعت
        
        virtual_work_orders.append({
            'id': f"WO-{order.reference}-{i:03d}",
            'work_center': category.categoryName if category else "دسته‌بندی نامشخص",
            'duration': total_duration,
            'status': 'in_progress',  # یا از status واقعی استفاده کنید
            'productions': productions,
            'total_production': total_production,
            'avg_speed': avg_speed,
            'production_count': len(productions)
        })
    
    # اگر داده‌ای گروه‌بندی نشد، از همه داده‌ها یک Work Order بساز
    if not virtual_work_orders and daily_productions:
        total_production = sum(p.production_value or 0 for p in daily_productions)
        avg_speed = sum(p.speed or 0 for p in daily_productions) / len(daily_productions)
        total_duration = len(daily_productions) * 8
        
        virtual_work_orders.append({
            'id': f"WO-{order.reference}-001",
            'work_center': "تولید کلی",
            'duration': total_duration,
            'status': 'in_progress',
            'productions': daily_productions,
            'total_production': total_production,
            'avg_speed': avg_speed,
            'production_count': len(daily_productions)
        })
    
    # محاسبات وضعیت موجودی
    sufficient_count = 0
    shortage_count = 0
    total_required_quantity = 0
    
    for component in components:
        total_required = component.quantity * order.quantity_to_produce
        total_required_quantity += total_required
        
        if component.product.available_quantity >= total_required:
            sufficient_count += 1
        else:
            shortage_count += 1
    
    sufficient_components = shortage_count == 0
    
    context = {
        'order': order,
        'components': components,
        'virtual_work_orders': virtual_work_orders,
        'sufficient_count': sufficient_count,
        'shortage_count': shortage_count,
        'total_required_quantity': total_required_quantity,
        'sufficient_components': sufficient_components,
    }
    return render(request, "mrp/manufactureorder/dgrok2.html", context)

@csrf_exempt
@login_required
def update_order_status_api(request, order_id):
    """API برای تغییر وضعیت سفارش"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            new_status = data.get('status')
            
            order = get_object_or_404(ManufacturingOrder, id=order_id)
            
            # اعتبارسنجی تغییر وضعیت
            valid_transitions = {
                'draft': ['confirmed', 'canceled'],
                'confirmed': ['progress', 'canceled'],
                'progress': ['done', 'canceled'],
                'done': [],
                'canceled': ['draft']
            }
            
            if new_status not in valid_transitions.get(order.status, []):
                return JsonResponse({
                    'success': False,
                    'error': f'تغییر وضعیت از {order.status} به {new_status} مجاز نیست'
                })
            
            # تغییر وضعیت
            order.status = new_status
            order.save()
            
            # اگر وضعیت به "in_progress" تغییر کرد، work orderها را شروع کن
            if new_status == 'progress':
                work_orders = WorkOrder.objects.filter(manufacturing_order=order)
                for wo in work_orders:
                    if wo.status == 'planned':
                        wo.status = 'in_progress'
                        wo.save()
            
            return JsonResponse({
                'success': True,
                'message': f'وضعیت سفارش به {order.get_status_display()} تغییر یافت',
                'new_status': order.status,
                'new_status_display': order.get_status_display()
            })
            
        except Exception as e:
            return JsonResponse({
                'success': False,
                'error': str(e)
            })
    
    return JsonResponse({
        'success': False,
        'error': 'متد غیرمجاز'
    })

@csrf_exempt
@login_required
def update_work_order_status_api(request, work_order_id):
    """API برای تغییر وضعیت Work Order"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            action = data.get('action')  # start, pause, stop
            
            work_order = get_object_or_404(WorkOrder, id=work_order_id)
            
            if action == 'start':
                if work_order.status in ['planned', 'paused']:
                    work_order.status = 'in_progress'
                    work_order.save()
            elif action == 'pause':
                if work_order.status == 'in_progress':
                    work_order.status = 'paused'
                    work_order.save()
            elif action == 'stop':
                if work_order.status in ['in_progress', 'paused']:
                    work_order.status = 'done'
                    work_order.save()
            
            return JsonResponse({
                'success': True,
                'new_status': work_order.status,
                'new_status_display': work_order.get_status_display()
            })
            
        except Exception as e:
            return JsonResponse({
                'success': False,
                'error': str(e)
            })
    
    return JsonResponse({
        'success': False,
        'error': 'متد غیرمجاز'
    })

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
                'scheduledDate': order.get_dateCreated_jalali().strftime('%Y-%m-%d'),
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
    

@require_GET
def get_order_details(request, order_id):
    """دریافت جزئیات یک سفارش برای نمایش در sidebar"""
    from django.db.models import Sum
    
    try:
        order = ManufacturingOrder.objects.select_related(
            'product_to_manufacture', 'line'
        ).get(id=order_id)
        
        # محاسبه مقدار استفاده شده
        total_used = CalendarEvent.objects.filter(
            order=order
        ).aggregate(total=Sum('quantity'))['total'] or 0
        
        remaining = order.quantity_to_produce - total_used
        
        return JsonResponse({
            'success': True,
            'order': {
                'id': order.id,
                'title': order.reference,
                'product_name': order.product_to_manufacture.name,
                'total_quantity': float(order.quantity_to_produce),
                'used_quantity': float(total_used),
                'remaining_quantity': float(remaining),
                'line_id': order.line.id if order.line else None,
                'line_name': order.line.name if order.line else None,
                'has_assigned_line': order.line is not None
            }
        })
    except ManufacturingOrder.DoesNotExist:
        return JsonResponse({
            'success': False,
            'error': 'سفارش یافت نشد.'
        }, status=404)


def manufacture_order_calendar(request):
    """صفحه اصلی تقویم تولید - اصلاح شده"""
    from django.db.models import Sum, Q
    
    lines = Line.objects.all()
    selected_line_id = request.GET.get('line_id')
    
    # دریافت تمام سفارشات فعال
    orders = ManufacturingOrder.objects.filter(
        Q(status__in=['confirmed', 'in_progress', 'draft']) | Q(status__isnull=True)
    ).select_related('product_to_manufacture', 'line')
    
    morders = []
    
    for order in orders:
        # محاسبه مجموع مقدار استفاده شده در تمام خطوط
        total_used_quantity = CalendarEvent.objects.filter(
            order=order
        ).aggregate(total=Sum('quantity'))['total'] or 0
        
        remaining_quantity = order.quantity_to_produce - total_used_quantity
        
        # فقط سفارشاتی که مقدار باقیمانده دارند
        if remaining_quantity > 0:
            morders.append({
                "id": order.id,
                "title": order.reference,
                "product_name": order.product_to_manufacture.name,
                "quantity": remaining_quantity,
                "total_quantity": float(order.quantity_to_produce),
                "used_quantity": float(total_used_quantity),
                "line_id": order.line.id if order.line else None,
                "line_name": order.line.name if order.line else "بدون خط",
                "has_assigned_line": order.line is not None,  # این خط اصلاح شده
                "type": "order"
            })
    
    # Vacations
    vacations = [
        {"id": "v1", "title": "تعطیل سالن", "type": "vacation"},
        {"id": "v2", "title": "قطعی برق", "type": "vacation"},
    ]
    
    # Off days
    offdays = [
        {"id": "o1", "title": "تعطیل رسمی", "type": "offday"},
        {"id": "o2", "title": "آورهال", "type": "offday"},
    ]
    
    # Combine all draggable items
    draggable_items = morders + vacations + offdays
    
    context = {
        "draggable_items": draggable_items,
        "morders": morders,
        "vacations": vacations,
        "offdays": offdays,
        "lines": lines,
        "selected_line_id": selected_line_id,
        "daily_limit": 5000
    }
    return render(request, "mrp/manufactureorder/calendar.html", context)


def get_order_calendar_info(request):
    """دریافت رویدادهای تقویم با فیلتر خط تولید - اصلاح شده"""
    line_id = request.GET.get('line_id')
    
    if not line_id:
        return JsonResponse({
            'success': False,
            'error': 'خط تولید مشخص نشده است.'
        }, status=400)
    
    try:
        line = Line.objects.get(id=line_id)
    except Line.DoesNotExist:
        return JsonResponse({
            'success': False,
            'error': 'خط تولید یافت نشد.'
        }, status=404)
    
    data = []
    user_info = CalendarEvent.objects.filter(line=line).select_related('order', 'line')

    def get_random_color():
        return "#{:06x}".format(random.randint(0, 0xFFFFFF))

    non_order_color = '#cccccc'
    order_ids = set(event.order.id for event in user_info if event.order)
    order_colors = cache.get(f'order_colors_line_{line_id}', {})
    
    if not order_colors:
        order_colors = {order_id: get_random_color() for order_id in order_ids}
        cache.set(f'order_colors_line_{line_id}', order_colors, timeout=3600)
    
    # اضافه کردن رنگ برای order های جدید
    for order_id in order_ids:
        if order_id not in order_colors:
            order_colors[order_id] = get_random_color()
    
    # به‌روزرسانی cache
    cache.set(f'order_colors_line_{line_id}', order_colors, timeout=3600)

    for i in user_info:
        background_color = order_colors.get(i.order.id) if i.order else non_order_color

        event_data = {
            'id': f"event-{i.id}",
            'title': i.title,
            'start': i.event_date.isoformat(),
            'backgroundColor': background_color,
            'borderColor': background_color,
            'textColor': '#ffffff',
            'extendedProps': {
                'quantity': i.quantity,
                'orderId': i.order.id if i.order else None,
                'lineId': i.line.id,
                'lineName': i.line.name,
                'originalTitle': i.title.split(" - ")[0] if " - " in i.title else i.title,
                'originalQuantity': i.order.quantity_to_produce if i.order else i.quantity,
                'type': i.type,
                'description': i.description,
                'is_new': False
            }
        }
        data.append(event_data)

    return JsonResponse(data, safe=False)


def get_line_capacity_info(request, line_id, date):
    """دریافت اطلاعات ظرفیت خط در یک تاریخ خاص"""
    try:
        line = Line.objects.get(id=line_id)
        event_date = datetime.datetime.strptime(date, '%Y-%m-%d').date()
        
        # فقط رویدادهای نوع order را حساب کنیم
        used_capacity = CalendarEvent.objects.filter(
            
            line=line,
            type='order'
        ).aggregate(total=models.Sum('quantity'))['total'] or 0
        
        available_capacity = line.capacity_per_day - used_capacity
        
        return JsonResponse({
            'success': True,
            'line_name': line.name,
            'date': date,
            'total_capacity': float(line.capacity_per_day),
            'used_capacity': float(used_capacity),
            'available_capacity': float(available_capacity),
            'usage_percentage': (used_capacity / line.capacity_per_day * 100) if line.capacity_per_day > 0 else 0
        })
    except Line.DoesNotExist:
        return JsonResponse({
            'success': False,
            'error': 'خط تولید یافت نشد.'
        }, status=404)
    except ValueError:
        return JsonResponse({
            'success': False,
            'error': 'فرمت تاریخ نامعتبر است.'
        }, status=400)
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        }, status=500)


@csrf_exempt
def bulk_create_events(request):
    """ذخیره دسته‌ای رویدادها - اصلاح شده"""
    if request.method == 'POST':
        try:
            from django.db.models import Sum
            
            data = json.loads(request.body)
            events = data.get('events', [])
            line_id = data.get('line_id')
            
            if not line_id:
                return JsonResponse({
                    'success': False,
                    'error': 'لطفا خط تولید را انتخاب کنید.'
                }, status=400)
            
            try:
                line = Line.objects.get(id=line_id)
            except Line.DoesNotExist:
                return JsonResponse({
                    'success': False,
                    'error': 'خط تولید یافت نشد.'
                }, status=404)
            
            saved_events = []
            errors = []

            for event_data in events:
                try:
                    title = event_data.get('title')
                    event_date = event_data.get('start')
                    quantity = float(event_data.get('quantity', 0))
                    order_id = event_data.get('orderId')
                    event_type = event_data.get('type', 'order')
                    description = event_data.get('description', '')
                    temp_id = event_data.get('tempId', 'unknown')

                    if not title or not event_date:
                        errors.append({
                            'tempId': temp_id,
                            'error': 'عنوان و تاریخ رویداد الزامی هستند.'
                        })
                        continue

                    # بررسی ظرفیت خط تولید برای رویدادهای نوع order
                    if event_type == 'order' and quantity > 0:
                        event_date_obj = datetime.datetime.strptime(event_date, '%Y-%m-%d').date()
                        
                        # محاسبه ظرفیت استفاده شده (فقط رویدادهای order)
                        used_capacity = CalendarEvent.objects.filter(
                            event_date=event_date_obj,
                            line=line,
                            type='order'
                        ).aggregate(total=models.Sum('quantity'))['total'] or 0
                        
                        available_capacity = line.capacity_per_day - used_capacity
                        
                        if quantity > available_capacity:
                            errors.append({
                                'tempId': temp_id,
                                'error': f'ظرفیت کافی در تاریخ {event_date} وجود ندارد. '
                                        f'ظرفیت باقیمانده: {available_capacity}kg، مورد نیاز: {quantity}kg'
                            })
                            continue

                    event_dict = {
                        'title': title,
                        'quantity': quantity,
                        'event_date': datetime.datetime.strptime(event_date, '%Y-%m-%d').date(),
                        'type': event_type,
                        'description': description,
                        'line': line
                    }

                    if order_id:
                        try:
                            order = ManufacturingOrder.objects.get(id=order_id)
                            event_dict['order'] = order
                        except ManufacturingOrder.DoesNotExist:
                            errors.append({
                                'tempId': temp_id,
                                'error': f'سفارش با شناسه {order_id} یافت نشد.'
                            })
                            continue

                    event = CalendarEvent.objects.create(**event_dict)
                    
                    # دریافت یا ایجاد رنگ برای سفارش
                    event_color = '#e7f1ff'
                    if event.order:
                        order_colors = cache.get(f'order_colors_line_{line_id}', {})
                        if event.order.id in order_colors:
                            event_color = order_colors[event.order.id]
                        else:
                            event_color = "#{:06x}".format(random.randint(0, 0xFFFFFF))
                            order_colors[event.order.id] = event_color
                            cache.set(f'order_colors_line_{line_id}', order_colors, timeout=3600)
                    
                    saved_events.append({
                        'id': f"event-{event.id}",
                        'tempId': temp_id,
                        'title': event.title,
                        'start': event.event_date.isoformat(),
                        'backgroundColor': event_color,
                        'borderColor': event_color,
                        'textColor': '#ffffff',
                        'extendedProps': {
                            'quantity': event.quantity,
                            'orderId': event.order.id if event.order else None,
                            'lineId': event.line.id,
                            'lineName': event.line.name,
                            'originalTitle': event.title.split(" - ")[0] if " - " in event.title else event.title,
                            'originalQuantity': event.order.quantity_to_produce if event.order else event.quantity,
                            'type': event_type,
                            'is_new': False
                        }
                    })
                    
                except Exception as e:
                    errors.append({
                        'tempId': temp_id,
                        'error': f'خطا در ذخیره: {str(e)}'
                    })

            response = {
                'success': len(saved_events) > 0,
                'events': saved_events
            }
            
            if errors:
                response['errors'] = errors
                response['message'] = f'{len(saved_events)} رویداد ذخیره شد، {len(errors)} رویداد با خطا مواجه شد.'
            else:
                response['message'] = f'{len(saved_events)} رویداد با موفقیت ذخیره شد.'

            return JsonResponse(response)

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

@require_GET
def get_order_usage_summary(request, order_id):
    """دریافت خلاصه استفاده از سفارش در خطوط مختلف"""
    from django.db.models import Sum
    
    try:
        order = ManufacturingOrder.objects.get(id=order_id)
        
        # دریافت استفاده در هر خط
        usage_per_line = CalendarEvent.objects.filter(
            order=order
        ).values('line__id', 'line__name').annotate(
            total_used=Sum('quantity')
        ).order_by('line__name')
        
        total_used = CalendarEvent.objects.filter(
            order=order
        ).aggregate(total=Sum('quantity'))['total'] or 0
        
        remaining = order.quantity_to_produce - total_used
        
        return JsonResponse({
            'success': True,
            'order_reference': order.reference,
            'product_name': order.product_to_manufacture.name,
            'total_quantity': float(order.quantity_to_produce),
            'total_used': float(total_used),
            'remaining': float(remaining),
            'usage_per_line': [
                {
                    'line_id': item['line__id'],
                    'line_name': item['line__name'],
                    'quantity': float(item['total_used'])
                }
                for item in usage_per_line
            ],
            'assigned_line': {
                'id': order.line.id if order.line else None,
                'name': order.line.name if order.line else None
            }
        })
        
    except ManufacturingOrder.DoesNotExist:
        return JsonResponse({
            'success': False,
            'error': 'سفارش یافت نشد.'
        }, status=404)
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        }, status=500)
    
@require_GET
def get_line_orders(request):
    """دریافت سفارشات مربوط به یک خط تولید با مقدار باقیمانده"""
    from django.db.models import Sum
    
    line_id = request.GET.get('line_id')
    
    if not line_id:
        return JsonResponse({
            'success': False,
            'error': 'خط تولید مشخص نشده است.'
        }, status=400)
    
    try:
        line = Line.objects.get(id=line_id)
        
        # دریافت تمام سفارشات فعال
        orders = ManufacturingOrder.objects.filter(
            status__in=['confirmed', 'in_progress', 'draft']
        ).select_related('product_to_manufacture', 'line')
        
        orders_data = []
        
        for order in orders:
            # محاسبه مجموع مقدار استفاده شده در تمام خطوط
            total_used_quantity = CalendarEvent.objects.filter(
                order=order
            ).aggregate(total=Sum('quantity'))['total'] or 0
            
            # محاسبه مقدار استفاده شده در این خط خاص
            used_in_this_line = CalendarEvent.objects.filter(
                order=order,
                line=line
            ).aggregate(total=Sum('quantity'))['total'] or 0
            
            # محاسبه مقدار استفاده شده در سایر خطوط
            used_in_other_lines = total_used_quantity - used_in_this_line
            
            remaining_quantity = order.quantity_to_produce - total_used_quantity
            
            # نمایش سفارشات بدون خط یا سفارشات این خط یا سفارشاتی که مقدار باقیمانده دارند
            if remaining_quantity > 0:
                orders_data.append({
                    'id': order.id,
                    'title': order.reference,
                    'product_name': order.product_to_manufacture.name,
                    'total_quantity': float(order.quantity_to_produce),
                    'used_quantity': float(total_used_quantity),
                    'used_in_this_line': float(used_in_this_line),
                    'used_in_other_lines': float(used_in_other_lines),
                    'remaining_quantity': float(remaining_quantity),
                    'assigned_line_id': order.line.id if order.line else None,
                    'assigned_line_name': order.line.name if order.line else None,
                    'is_assigned_to_selected_line': order.line.id == line.id if order.line else False,
                    'has_assigned_line': order.line is not None
                })
        
        return JsonResponse({
            'success': True,
            'orders': orders_data,
            'line_name': line.name
        })
        
    except Line.DoesNotExist:
        return JsonResponse({
            'success': False,
            'error': 'خط تولید یافت نشد.'
        }, status=404)
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        }, status=500)
@require_GET
def get_production_forecast_api(request):
    """API برای پیش‌بینی تولید"""
    try:
        bom_id = request.GET.get('bom_id')
        quantity = float(request.GET.get('quantity', 1))
        
        if not bom_id:
            return JsonResponse({
                'success': False,
                'error': 'BOM ID الزامی است'
            }, status=400)
        
        bom = BillOfMaterials.objects.get(id=bom_id)
        components = BOMComponent.objects.filter(bom=bom).select_related('product')
        
        # محاسبات پیش‌بینی
        forecast_data = {
            'bom_info': {
                'reference': bom.reference,
                'product_name': bom.product.name,
                'operation_time': bom.operation_time,
                'total_components': components.count()
            },
            'production_quantity': quantity,
            'components_analysis': [],
            'summary': {
                'total_required_cost': 0,
                'sufficient_components': 0,
                'insufficient_components': 0,
                'production_time_hours': 0
            }
        }
        
        # تحلیل کامپوننت‌ها
        for component in components:
            required_quantity = component.quantity * quantity
            available_quantity = component.product.available_quantity
            is_sufficient = available_quantity >= required_quantity
            cost = required_quantity * float(component.product.cost_price)
            
            component_data = {
                'name': component.product.name,
                'required_quantity': required_quantity,
                'available_quantity': available_quantity,
                'uom': component.product.unit_of_measure,
                'is_sufficient': is_sufficient,
                'shortage': max(0, required_quantity - available_quantity),
                'cost': cost,
                'unit_cost': float(component.product.cost_price)
            }
            
            forecast_data['components_analysis'].append(component_data)
            forecast_data['summary']['total_required_cost'] += cost
            
            if is_sufficient:
                forecast_data['summary']['sufficient_components'] += 1
            else:
                forecast_data['summary']['insufficient_components'] += 1
        
        # محاسبه زمان تولید
        forecast_data['summary']['production_time_hours'] = (bom.operation_time * quantity) / 60
        
        return JsonResponse({
            'success': True,
            'forecast': forecast_data
        })
        
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        }, status=500)

@require_GET
def get_workorder_timeline_api(request, bom_id):
    """API برای دریافت timeline دستور کارها"""
    try:
        bom = BillOfMaterials.objects.get(id=bom_id)
        workorder_templates = WorkOrderTemplate.objects.filter(bom=bom, active=True)
        
        timeline_data = []
        total_duration = 0
        
        for template in workorder_templates:
            operations = Operation.objects.filter(
                work_order_template=template
            ).order_by('sequence').select_related('work_center')
            
            for operation in operations:
                timeline_data.append({
                    'template_name': template.name,
                    'operation_name': operation.name,
                    'work_center': operation.work_center.name,
                    'sequence': operation.sequence,
                    'duration_hours': operation.duration,
                    'instructions': operation.instructions
                })
                total_duration += operation.duration
        
        return JsonResponse({
            'success': True,
            'timeline': timeline_data,
            'total_duration_hours': total_duration,
            'estimated_days': total_duration / 8  # فرض 8 ساعت کار در روز
        })
        
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        }, status=500)