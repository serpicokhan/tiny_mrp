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
from django.shortcuts import get_object_or_404
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from mrp.business.purchaseutility import *


from mrp.forms import ManufacturingOrderForm2

def list_minimorder(request):
    # makan=request.GET.get("makan",False)
   

    object_list=ManufacturingOrder.objects.filter(status='draft')    
    # Number of items per page
    objects=PurchaseUtility.doPaging(request,object_list)
    

    return render(request,"mrp/minimorder/minimorderList.html",{'morders':objects,'title':'لیست سفارشات تولید'})

def save_minimorder_form(request, form, template_name):

    import uuid
    data = dict()
    print("firsl line")
    if (request.method == 'POST'):
        if form.is_valid():
            form.save(commit=False)
            form.instance.reference = str(uuid.uuid4())[:8]  # 8 کاراکتر اول
            form.instance.status='Draft'
            form.save()
            data['form_is_valid'] = True
           
            data['html_formula_list'] = render_to_string('mrp/minimorder/partialMinimorderList.html', {
                
                'perms': PermWrapper(request.user)
            })
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_formula_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)

def minimorder_update(request, id):
    company= get_object_or_404(ManufacturingOrder, id=id)
    template=""
    if (request.method == 'POST'):
        post_data = request.POST.copy()
        
        # تبدیل تاریخ شمسی به میلادی
        jalali_date = post_data.get('scheduled_date')
        post_data['scheduled_date']=DateJob.getTaskDate(jalali_date)
        form = ManufacturingOrderForm2(post_data, instance=company)
    else:
        form = ManufacturingOrderForm2(instance=company)


    return save_minimorder_form(request, form,"mrp/minimorder/partialMinimorderUpdate.html")
def minimorder_create(request):
    template=""
    if (request.method == 'POST'):
        post_data = request.POST.copy()
        
        # تبدیل تاریخ شمسی به میلادی
        jalali_date = post_data.get('scheduled_date')
        post_data['scheduled_date']=DateJob.getTaskDate(jalali_date)
        form = ManufacturingOrderForm2(post_data)
    else:
        form = ManufacturingOrderForm2()


    return save_minimorder_form(request, form,"mrp/minimorder/partialMinimorderCreate.html")

def referesh_minimorder_list(request):
    makan = request.GET.get('makan', False)
    if(makan): 
        requests=ManufacturingOrder.objects.filter(status='draft').order_by("-id")
    else:
        # if request.user.is_superuser:
        requests = ManufacturingOrder.objects.filter(status='draft').order_by("-id")
    ws= PurchaseUtility.doPaging(request,requests)
    data=dict()
    data["status"]="ok"
    data["formula_html"]=render_to_string('mrp/minimorder/partialMinimorderList.html', {
                        
                        'morders':ws,
                         'perms': PermWrapper(request.user) 

                       

                        
                    },request)
    return JsonResponse(data)
