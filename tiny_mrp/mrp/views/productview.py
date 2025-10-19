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
from mrp.forms import ProductForm, ProductFilterForm
from django.shortcuts import render, redirect, get_object_or_404
from django.views.generic import ListView
from django.contrib import messages
from django.views.decorators.http import require_GET
from rest_framework.decorators import api_view
from rest_framework.response import Response
from mrp.serializers import ProductSerializer
from django.db import transaction
from django.db.models import Sum, Q
class ProductListView(ListView):
    model = Product
    template_name = 'mrp/product/partialProductList.html'
    context_object_name = 'products'
    paginate_by = 10
    
    def get_queryset(self):
        queryset = super().get_queryset()
        filter_form = ProductFilterForm(self.request.GET or None)
        
        if filter_form.is_valid():
            queryset = filter_form.filter_queryset(queryset)
        
        return queryset
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['filter_form'] = ProductFilterForm(self.request.GET or None)
        return context

def product_list(request):
    return render(request,"mrp/product/partialProductList.html",{})
def save_product_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_product_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
def create_product(request):
    if (request.method == 'POST'):
        form = ProductForm(request.POST)
        return save_product_form(request, form, 'mrp/product/partialProductCreate.html')
  
    else:
        
        form = ProductForm()
        return save_product_form(request, form, 'mrp/product/partialProductCreate.html')
@api_view(('GET',))
def product_list_api(request):
    # This is your mock data converted to Python format
    # mock_products = [
    #     {
    #         "id": 1,
    #         "name": "محصول الف",
    #         "code": "FP-001",
    #         "product_type": "finished",
    #         "unit_of_measure": "units",
    #         "cost_price": "15.50",
    #         "sale_price": "29.99",
    #         "available_quantity": 25,
    #         "created_at": "2023-06-10T09:15:00Z",
    #         "updated_at": "2023-06-15T14:30:00Z"
    #     },
    #     {
    #         "id": 2,
    #         "name": "محصول ب",
    #         "code": "RM-001",
    #         "product_type": "raw",
    #         "unit_of_measure": "kg",
    #         "cost_price": "8.75",
    #         "sale_price": "12.50",
    #         "available_quantity": 150.5,
    #         "created_at": "2023-05-20T11:20:00Z",
    #         "updated_at": "2023-06-12T16:45:00Z"
    #     },
    #     {
    #         "id": 3,
    #         "name": "محصول پ",
    #         "code": "CP-001",
    #         "product_type": "component",
    #         "unit_of_measure": "units",
    #         "cost_price": "3.20",
    #         "sale_price": "5.99",
    #         "available_quantity": 0,
    #         "created_at": "2023-06-01T08:30:00Z",
    #         "updated_at": "2023-06-18T10:15:00Z"
    #     },
    #     {
    #         "id": 4,
    #         "name": "محصول ث",
    #         "code": "FP-002",
    #         "product_type": "finished",
    #         "unit_of_measure": "units",
    #         "cost_price": "22.00",
    #         "sale_price": "45.00",
    #         "available_quantity": 8,
    #         "created_at": "2023-06-05T14:00:00Z",
    #         "updated_at": "2023-06-16T09:30:00Z"
    #     }
    # ]
    
    products = Product.objects.all()
    if(request.GET.get('type',False)=='finished'):
        products=products.filter(product_type='finished')
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)
   
API_KEY = "2b96a13f35fc"

@csrf_exempt
def receive_products(request):
    if request.method != "POST":
        return JsonResponse({"error": "POST required"}, status=400)

    if request.headers.get("X-API-KEY") != API_KEY:
        return JsonResponse({"error": "Unauthorized"}, status=401)

    try:
        data = json.loads(request.body)
        created_count = 0
        updated_count = 0
        errors = []

        for idx, row in enumerate(data, start=1):
            try:
                # ساخت name از فیلدهای مختلف
                name_parts = [row.get("fdesc"), row.get("Expr1"), row.get("Expr2"), row.get("Expr3")]
                name = " - ".join([p for p in name_parts if p])

                code = f"{row.get('CodeKala')}-{row.get('keyfiat')}-{row.get('mogheiat')}-{row.get('vaziat')}"
                if(row.get('CodeAnbar')==1):
                    product, created = Product.objects.update_or_create(
                        code=code,
                        defaults={
                            "name": name or f"Unnamed {code}",
                            "available_quantity": float(row.get("MeghdarM") or 0),
                            "sale_price": 0,
                            "cost_price": 0,
                            "product_type": Product.RAW_MATERIAL,
                            "unit_of_measure": Product.KILOGRAMS,
                        }
                    )
                elif(row.get('CodeAnbar')==2):
                     product, created = Product.objects.update_or_create(
                        code=code,
                        defaults={
                            "name": name or f"Unnamed {code}",
                            "available_quantity": float(row.get("MeghdarM") or 0),
                            "sale_price": 0,
                            "cost_price": 0,
                            "product_type": Product.COMPONENT,
                            "unit_of_measure": Product.KILOGRAMS,
                        }
                    )
                else:
                     product, created = Product.objects.update_or_create(
                        code=code,
                        defaults={
                            "name": name or f"Unnamed {code}",
                            "available_quantity": float(row.get("MeghdarM") or 0),
                            "sale_price": 0,
                            "cost_price": 0,
                            "product_type": Product.FINISHED_GOOD,
                            "unit_of_measure": Product.KILOGRAMS,
                        }
                    )

                if created:
                    created_count += 1
                else:
                    updated_count += 1

            except Exception as e:
                errors.append({"index": idx, "code": row.get("CodeKala"), "error": str(e)})

        result = {
            "status": "success",
            "created": created_count,
            "updated": updated_count,
            "errors": errors
        }
        print(result)

        return JsonResponse(result)

    except Exception as e:
        return JsonResponse({"error": str(e)}, status=500)
    



@login_required
def low_stock_products(request):
    """نمایش کالاهای با موجودی ناکافی"""
    
    # محاسبه مجموع مقادیر مورد نیاز از سفارشات فعال
    active_orders = ManufacturingOrder.objects.filter(
        status__in=['draft', 'confirmed', 'in_progress']
    )
    
    low_stock_data = []
    
    for product in Product.objects.filter(
        product_type__in=['raw', 'component']
    ):
        # محاسبه مجموع مقدار مورد نیاز از BOMهای سفارشات فعال
        total_required = 0
        
        # پیدا کردن تمام BOMهایی که از این محصول استفاده می‌کنند
        bom_components = BOMComponent.objects.filter(product=product)
        
        for bom_component in bom_components:
            # سفارشاتی که از این BOM استفاده می‌کنند و فعال هستند
            orders_using_bom = active_orders.filter(bom=bom_component.bom)
            
            for order in orders_using_bom:
                required_qty = bom_component.quantity * order.quantity_to_produce
                total_required += required_qty
        
        # اگر موجودی کمتر از نیاز باشد
        if total_required > 0 and product.available_quantity < total_required:
            shortage = total_required - product.available_quantity
            shortage_percentage = (shortage / total_required) * 100
            
            low_stock_data.append({
                'product': product,
                'available_quantity': product.available_quantity,
                'required_quantity': total_required,
                'shortage': shortage,
                'shortage_percentage': shortage_percentage,
                'critical_level': 'high' if shortage_percentage > 50 else 'medium'
            })
    
    # مرتب‌سازی بر اساس درصد کمبود (بیشترین اول)
    low_stock_data.sort(key=lambda x: x['shortage_percentage'], reverse=True)
    
    context = {
        'low_stock_products': low_stock_data,
        'total_critical': len([x for x in low_stock_data if x['critical_level'] == 'high']),
        'total_medium': len([x for x in low_stock_data if x['critical_level'] == 'medium']),
    }
    
    return render(request, 'mrp/product/low_stock_products.html', context)

@csrf_exempt
def product_detail_api(request, product_id):
    """API برای دریافت جزئیات کامل کالا"""
    try:
        product = Product.objects.get(id=product_id)
        
        # محاسبه اطلاعات مربوط به سفارشات
        active_orders = ManufacturingOrder.objects.filter(
            status__in=['draft', 'confirmed', 'in_progress']
        )
        
        # پیدا کردن BOMهایی که از این محصول استفاده می‌کنند
        bom_components = BOMComponent.objects.filter(product=product)
        
        total_required = 0
        related_orders = []
        
        for bom_component in bom_components:
            orders_using_bom = active_orders.filter(bom=bom_component.bom)
            
            for order in orders_using_bom:
                required_qty = bom_component.quantity * order.quantity_to_produce
                total_required += required_qty
                
                related_orders.append({
                    'order_reference': order.reference,
                    'bom_reference': bom_component.bom.reference,
                    'required_quantity': required_qty,
                    'order_status': order.get_status_display(),
                    'scheduled_date': order.scheduled_date.strftime('%Y-%m-%d')
                })
        
        # اطلاعات موجودی
        stock_status = product.get_stock_status()
        stock_status_display = {
            'out_of_stock': 'ناموجود',
            'low_stock': 'موجودی کم',
            'in_stock': 'موجود'
        }.get(stock_status, 'نامشخص')
        
        return JsonResponse({
            'success': True,
            'product': {
                'id': product.id,
                'name': product.name,
                'code': product.code,
                'product_type': product.product_type,
                'product_type_display': product.get_product_type_display(),
                'unit_of_measure': product.unit_of_measure,
                'unit_of_measure_display': product.get_unit_of_measure_display(),
                'cost_price': float(product.cost_price),
                'sale_price': float(product.sale_price),
                'available_quantity': float(product.available_quantity),
                'stock_status': stock_status,
                'stock_status_display': stock_status_display,
                'created_at': product.created_at.strftime('%Y-%m-%d %H:%M'),
                'updated_at': product.updated_at.strftime('%Y-%m-%d %H:%M'),
            },
            'inventory_info': {
                'total_required': total_required,
                'shortage': max(0, total_required - product.available_quantity),
                'is_sufficient': product.available_quantity >= total_required,
                'coverage_ratio': (product.available_quantity / total_required * 100) if total_required > 0 else 100
            },
            'related_orders': related_orders,
            'total_related_orders': len(related_orders)
        })
        
    except Product.DoesNotExist:
        return JsonResponse({
            'success': False,
            'error': 'محصول یافت نشد'
        }, status=404)
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        }, status=500)

@csrf_exempt
def purchase_suggestion_api(request, product_id):
    """API برای محاسبه پیشنهاد خرید هوشمند"""
    try:
        product = Product.objects.get(id=product_id)
        
        # محاسبه کمبود بر اساس سفارشات فعال
        active_orders = ManufacturingOrder.objects.filter(
            status__in=['draft', 'confirmed', 'in_progress']
        )
        
        total_required = 0
        bom_components = BOMComponent.objects.filter(product=product)
        
        for bom_component in bom_components:
            orders_using_bom = active_orders.filter(bom=bom_component.bom)
            for order in orders_using_bom:
                total_required += bom_component.quantity * order.quantity_to_produce
        
        # محاسبه پیشنهاد خرید هوشمند
        current_stock = product.available_quantity
        shortage = max(0, total_required - current_stock)
        
        # فاکتورهای محاسبه پیشنهاد خرید
        safety_stock = max(total_required * 0.2, 10)  # 20% موجودی ایمنی یا حداقل 10 واحد
        lead_time_demand = total_required * 0.1  # تقاضای دوره تحویل (فرضی)
        
        suggested_quantity = max(
            shortage + safety_stock + lead_time_demand,
            50  # حداقل سفارش
        )
        
        # گرد کردن به مضرب 10
        suggested_quantity = round(suggested_quantity / 10) * 10
        
        # محاسبه هزینه
        estimated_cost = suggested_quantity * float(product.cost_price)
        
        # تعیین سطح فوریت
        urgency_level = 'high' if shortage > current_stock else 'medium' if shortage > 0 else 'low'
        urgency_display = {
            'high': 'فوری',
            'medium': 'مهم',
            'low': 'عادی'
        }.get(urgency_level, 'عادی')
        
        return JsonResponse({
            'success': True,
            'product': {
                'id': product.id,
                'name': product.name,
                'code': product.code
            },
            'calculation': {
                'current_stock': current_stock,
                'total_required': total_required,
                'shortage': shortage,
                'safety_stock': safety_stock,
                'lead_time_demand': lead_time_demand
            },
            'suggestion': {
                'suggested_quantity': suggested_quantity,
                'estimated_cost': estimated_cost,
                'urgency_level': urgency_level,
                'urgency_display': urgency_display,
                'min_order_quantity': 50,
                'estimated_delivery_time': '3-5 روز کاری',
                'supplier_notes': 'پیشنهاد می‌شود از تامین‌کنندگان معتبر خریداری شود'
            },
            'recommendation': f"پیشنهاد خرید {suggested_quantity} واحد برای پوشش کمبود و موجودی ایمنی"
        })
        
    except Product.DoesNotExist:
        return JsonResponse({
            'success': False,
            'error': 'محصول یافت نشد'
        }, status=404)
    except Exception as e:
        return JsonResponse({
            'success': False,
            'error': str(e)
        }, status=500)

@csrf_exempt
def create_purchase_order_api(request):
    """API برای ایجاد سفارش خرید"""
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            product_id = data.get('product_id')
            quantity = data.get('quantity')
            
            product = Product.objects.get(id=product_id)
            
            # در اینجا می‌توانید منطق ایجاد سفارش خرید را پیاده‌سازی کنید
            # برای نمونه، یک پیام موفقیت برمی‌گردانیم
            
            return JsonResponse({
                'success': True,
                'message': f'سفارش خرید برای {product.name} به مقدار {quantity} واحد با موفقیت ثبت شد',
                'purchase_data': {
                    'product': product.name,
                    'quantity': quantity,
                    'total_cost': quantity * float(product.cost_price),
                    'reference': f'PO-{product.code}-{datetime.now().strftime("%Y%m%d%H%M")}'
                }
            })
            
        except Product.DoesNotExist:
            return JsonResponse({
                'success': False,
                'error': 'محصول یافت نشد'
            }, status=404)
        except Exception as e:
            return JsonResponse({
                'success': False,
                'error': str(e)
            }, status=500)
    
    return JsonResponse({
        'success': False,
        'error': 'متد غیرمجاز'
    }, status=405)
    """API برای پیشنهاد خرید"""
    try:
        product = Product.objects.get(id=product_id)
        
        # محاسبه پیشنهاد خرید (می‌توانید منطق پیچیده‌تری اضافه کنید)
        suggested_quantity = max(100, product.available_quantity * 2)  # مثال ساده
        estimated_cost = suggested_quantity * float(product.cost_price)
        
        return JsonResponse({
            'product_id': product.id,
            'product_name': product.name,
            'shortage': max(0, 100 - product.available_quantity),  # مثال
            'suggested_quantity': suggested_quantity,
            'estimated_cost': estimated_cost,
            'min_order_quantity': 50,  # می‌توانید از مدل تنظیمات بخوانید
            'delivery_time': '3 روز کاری'
        })
    except Product.DoesNotExist:
        return JsonResponse({'error': 'Product not found'}, status=404)