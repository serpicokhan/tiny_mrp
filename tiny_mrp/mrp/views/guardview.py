from django.shortcuts import render,redirect, get_object_or_404
from django.http import JsonResponse,HttpResponse
from django.template.loader import render_to_string
from django.views.decorators.csrf import csrf_exempt
from mrp.models import PurchaseRequest, RequestItem,SysUser,Part,Asset2,PurchaseRequestFile,Asset,Comment,PurchaseNotes,PurchaseActivityLog,Supplier,GoodsEntry
from django.template.loader import render_to_string
from mrp.business.purchaseutility import *
from mrp.business.DateJob import *
from django.db.models import Q
from django.contrib.auth.context_processors import PermWrapper
from django.core.files.storage import FileSystemStorage
from mrp.forms import PurchaseRequestFileForm
import openpyxl
from openpyxl.styles import Border, Side, PatternFill,Font,Alignment
import json
from django.contrib.auth.decorators import login_required
from django.contrib.auth.decorators import permission_required
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_POST


def list_gaurd(request):
    items=RequestItem.objects.filter(purchase_request__status__in=("Purchased","GuardApproved") )
    return render(request,'mrp/gaurd/list.html',{"items":items})

@csrf_exempt
def create_goods_entry(request):
    try:
        request_item_id = request.POST.get('request_item')
        quantity_received = int(request.POST.get('quantity_received'))
        supplier_id = request.POST.get('supplier')

        # پیدا کردن اشیاء مرتبط
        request_item = RequestItem.objects.get(id=request_item_id)
        supplier = Supplier.objects.get(id=supplier_id) if supplier_id else None

        # ایجاد GoodsEntry
        goods_entry = GoodsEntry(
            request_item=request_item,
            quantity_received=quantity_received,
            supplier=supplier,
            guard_approved=True  # پیش‌فرض تأیید نگهبانی خیر
        )
        goods_entry.save()

        # به‌روزرسانی وضعیت درخواست
        request_item.purchase_request.update_status()
        PurchaseActivityLog.objects.create(
                    user=request.user.sysuser,  # User making the change
                    purchase_request=request_item.purchase_request,
                    action=f"{request.user.sysuser} ورود {quantity_received} {request_item} را از {supplier} تایید نمود"
                )

        return JsonResponse({
            'http_status': 'success',
            'message': 'ورود کالا با موفقیت ثبت شد.'
        }, status=200)

    except RequestItem.DoesNotExist:
        return JsonResponse({
            'http_status': 'error',
            'message': 'آیتم درخواست یافت نشد.'
        }, status=404)
    except Supplier.DoesNotExist:
        return JsonResponse({
            'http_status': 'error',
            'message': 'تأمین‌کننده یافت نشد.'
        }, status=404)
    except ValueError:
        return JsonResponse({
            'http_status': 'error',
            'message': 'تعداد نامعتبر است.'
        }, status=400)
    except Exception as e:
        return JsonResponse({
            'http_status': 'error',
            'message': f'خطا: {str(e)}'
        }, status=500)