from django.shortcuts import render
from mrp.models import *
from mrp.forms import AssetFailureForm,FailureForm
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

@login_required
def asset_failure_list(request):
    dt=request.GET.get("date",datetime.datetime.now().date())
    date_object = datetime.datetime.strptime(str(dt),'%Y-%m-%d').date()
    print(date_object)
    next_day = date_object + timedelta(days=1)

    previous_day = date_object - timedelta(days=1)
    books = AssetFailure.objects.filter(dayOfIssue=dt)
    return render(request,"mrp/assetfailure/details.html",{'assetfailures':books,'title':'توقفات روزانه','next_date':next_day.strftime('%Y-%m-%d'),'prev_date':previous_day.strftime('%Y-%m-%d'),'today':jdatetime.date.fromgregorian(date=date_object),'greg_today':date_object})

@login_required
def calendar_asset_failure(request):
    return render(request,'mrp/assetfailure/calendar_asset_falure.html',{'title':'توقفات روزانه'})

def get_assetfailure_calendar_info(request):
    data=[]
    user_info=AssetFailure.objects.values_list('dayOfIssue').distinct()

    for i in user_info:

        data.append({'title': "توقفات ",\
                'start': i[0],\
                 'color': 'bg-dark',\
                'id':i[0]})

    return JsonResponse(data,safe=False)
##########################################################
def save_assetFailure_form(request, form, template_name,id=None):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            books = AssetFailure.objects.filter(dayOfIssue=bts.dayOfIssue)
            data['html_assetFailure_list'] = render_to_string('mrp/assetfailure/partialAssetFailure.html', {
                'assetfailures': books,
                'perms': PermWrapper(request.user)
            })
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_assetFailure_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
def save_Failure_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            books = Failure.objects.all()
            data['html_failure_list'] = render_to_string('mrp/failures/partialFailureList.html', {
                'failures': books,
                'perms': PermWrapper(request.user)
            })
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_failure_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
##########################################################
def assetFailure_create(request):
    if (request.method == 'POST'):
        form = AssetFailureForm(request.POST)
        return save_assetFailure_form(request, form, 'mrp/assetfailure/partialAssetFailureCreate.html')
    else:
        mydt=request.GET.get("dt",False)
        form = AssetFailureForm(initial={'dayOfIssue': DateJob.getTaskDate(mydt)})
        return save_assetFailure_form(request, form, 'mrp/assetfailure/partialAssetFailureCreate.html')
def failure_create(request):
    if (request.method == 'POST'):
        form = FailureForm(request.POST)
        return save_Failure_form(request, form, 'mrp/failures/partialFailureCreate.html')
    else:
        print("!!!!!!!!!!!!!!")
        form = FailureForm()
        return save_Failure_form(request, form, 'mrp/failures/partialFailureCreate.html')

def assetFailure_update(request, id):
    company= get_object_or_404(AssetFailure, id=id)
    template=""
    if (request.method == 'POST'):
        form = AssetFailureForm(request.POST, instance=company)
    else:
        form = AssetFailureForm(instance=company)


    return save_assetFailure_form(request, form,"mrp/assetfailure/partialAssetFailureUpdate.html",id)

def failure_update(request, id):
    company= get_object_or_404(Failure, id=id)
    template=""
    if (request.method == 'POST'):
        form = FailureForm(request.POST, instance=company)
    else:
        form = FailureForm(instance=company)


    return save_Failure_form(request, form,"mrp/failures/partialFailureUpdate.html")


def failure_delete(request, id):
    comp1 = get_object_or_404(Failure, id=id)
    data = dict()
    if (request.method == 'POST'):
        comp1.delete()
        data['form_is_valid'] = True  # This is just to play along with the existing code
        companies =  Failure.objects.all()
        wos=doPaging(request,companies)
        #Tasks.objects.filter(maintenanceTypeId=id).update(maintenanceType=id)
        data['html_failure_list'] = render_to_string('mrp/failures/partialFailureList.html', {
            'failures': wos,
            'perms': PermWrapper(request.user)
        })
    else:
        context = {'failures': comp1}
        data['html_failure_form'] = render_to_string('mrp/failures/partialFailuresDelete.html',
            context,
            request=request,
        )
    return JsonResponse(data)

def list_failures(request):
    formulas=Failure.objects.all()
    return render(request,"mrp/failures/failureList.html",{'failures':formulas,'title':'لیست توقفات'})
##########################################################
def monthly_detaild_failured_report(request):
    days=[]
    shift=Shift.objects.all()
    asset_category=asset_categories = AssetCategory.objects.annotate(
        min_priority=models.Min('asset__assetTavali')
        ).order_by('min_priority')

    current_date_time2 = jdatetime.datetime.now()
    current_year=current_date_time2.year
    j_month=request.GET.get('month',current_date_time2.month)


    current_date_time = jdatetime.date(current_year, int(j_month), 1)
    current_jalali_date = current_date_time



    if current_jalali_date.month == 12:
        first_day_of_next_month = current_jalali_date.replace(day=1, month=1, year=current_jalali_date.year + 1)
    else:
        first_day_of_next_month = current_jalali_date.replace(day=1, month=current_jalali_date.month + 1)


    num_days = (first_day_of_next_month - jdatetime.timedelta(days=1)).day
    cat_list=[]
    for cats in asset_category:
        sh_list=[]

        days=[]
        for day in range(1,num_days+1):
            product={}
            j_date=jdatetime.date(current_jalali_date.year,current_jalali_date.month,day)
            for sh in shift:
                product[sh.id]=get_sum_machine_failure_by_date_shift(cats,sh,j_date.togregorian())
            days.append({'cat':cats,'date':"{0}/{1}/{2}".format(current_jalali_date.year,current_jalali_date.month,day),'day_of_week':DateJob.get_day_of_week(j_date),'product':product})
        ###sum all
        product={}
        start=jdatetime.date(current_jalali_date.year,current_jalali_date.month,1)
        end=jdatetime.date(current_jalali_date.year,current_jalali_date.month,num_days)
        for sh in shift:
            product[sh.id]=get_sum_machine_failure_monthly_shift(cats,sh,start.togregorian(),end.togregorian())
        days.append({'cat':cats,'date':"",'day_of_week':'جمع','product':product})
        product={}
        for sh in shift:
            product[sh.id]=get_day_machine_failure_monthly_shift(cats,sh,start.togregorian(),end.togregorian())
        days.append({'cat':cats,'date':"",'day_of_week':'مجموع روز متوقف','product':product})
        total_day_per_shift={}
        for sh in shift:
            total_day_per_shift[sh.id]=num_days-product[sh.id]
        days.append({'cat':cats,'date':"",'day_of_week':'روز کاری','product':total_day_per_shift})


        cat_list.append({'cat':cats,'shift_val':days})

    return render(request,'mrp/assetfailure/monthly_failure_detailed.html',{'cats':asset_category,'title':'آمار ماهانه','cat_list':cat_list,'shift':shift,'month':j_month})
