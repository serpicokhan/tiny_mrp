from django.shortcuts import render
from mrp.models import *
from mrp.forms import AssetRandemanForm
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


def get_randeman_per_tolid_byshift(mah,sal,asset_cat,shift):
    start_date_gregorian, end_date_gregorian = DateJob.shamsi_to_gregorian_range(sal, mah)
    filtered_production = DailyProduction.objects.filter(
    dayOfIssue__range=(start_date_gregorian, end_date_gregorian),  # Filter by date range
    shift=shift,  # Filter by shift ID equal to 1
    machine__assetCategory=asset_cat  # Filter by asset category n
    )
    # Calculate the sum of production_value
    sum_production_value = filtered_production.aggregate(
        total_production_value=models.Sum('production_value')
    )['total_production_value']

    if(not sum_production_value):
        return 0

    return sum_production_value
def get_randeman_per_tolid(mah,sal,asset_cat):

    start_date_gregorian, end_date_gregorian = DateJob.shamsi_to_gregorian_range(sal, mah)
    filtered_production = DailyProduction.objects.filter(
    dayOfIssue__range=(start_date_gregorian, end_date_gregorian),  # Filter by date range

    machine__assetCategory=asset_cat  # Filter by asset category n
    )
    # Calculate the sum of production_value
    sum_production_value = filtered_production.aggregate(
        total_production_value=models.Sum('production_value')
    )['total_production_value']

    if(not sum_production_value):
        return 0

    return sum_production_value

def calc_assetrandeman(mah,sal):
    asset_cat_list=AssetCategory.objects.all()
    shift_list=Shift.objects.all()
    AssetRandemanPerMonth.objects.filter(mah=mah,sal=sal).delete()
    for i in asset_cat_list:
        data_shift=[]
        for shift in shift_list:
            kole_randeman=AssetRandemanInit.objects.get(asset_category=i).randeman_tolid
            tolid_shift=get_randeman_per_tolid_byshift(mah,sal,i,shift)
            kole_tolid=get_randeman_per_tolid(mah,sal,i)
            result=0
            if(kole_tolid==0):
                result=0
            else:
                result=(kole_randeman*tolid_shift)/kole_tolid
            AssetRandemanPerMonth.objects.create(asset_category=i,shift=shift,tolid_value=result,mah=mah,sal=sal)
@login_required
def asset_randeman_list(request):

    books = AssetRandemanList.objects.all()
    wos=doPaging(request,books)
    return render(request,"mrp/assetrandeman/assetRandemanList.html",{'assetfailures':wos,'title':'لیست راندمانهای محاسبه شده'})


# ##########################################################
def save_assetRandeman_form(request, form, template_name,id=None):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            calc_assetrandeman(bts.mah,bts.sal)
            data['form_is_valid'] = True
            books = AssetRandemanList.objects.all()
            wos=doPaging(request,books)
            data['html_assetRandeman_list'] = render_to_string('mrp/assetrandeman/partialAssetRandemanList.html', {
                'assetfailures': wos,
                'perms': PermWrapper(request.user)
            })
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_assetRandeman_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
# ##########################################################
def assetRandeman_create(request):
    if (request.method == 'POST'):
        form = AssetRandemanForm(request.POST)
        return save_assetRandeman_form(request, form, 'mrp/assetrandeman/partialAssetRandemanCreate.html')
    else:
        mydt=request.GET.get("dt",False)
        form = AssetRandemanForm()
        return save_assetRandeman_form(request, form, 'mrp/assetrandeman/partialAssetRandemanCreate.html')

def assetRandeman_update(request, id):
    company= get_object_or_404(AssetRandemanList, id=id)
    template=""
    if (request.method == 'POST'):
        form = AssetRandemanForm(request.POST, instance=company)
    else:
        form = AssetRandemanForm(instance=company)


    return save_assetRandeman_form(request, form,"mrp/assetrandeman/partialAssetRandemanUpdate.html",id)


def assetRandeman_delete(request, id):
    comp1 = get_object_or_404(AssetRandemanList, id=id)
    data = dict()
    if (request.method == 'POST'):
        comp1.delete()
        data['form_is_valid'] = True  # This is just to play along with the existing code
        companies =  AssetRandemanList.objects.all()
        wos=doPaging(request,companies)
        #Tasks.objects.filter(maintenanceTypeId=id).update(maintenanceType=id)
        data['html_assetRandeman_list'] = render_to_string('mrp/assetrandeman/partialAssetRandemanList.html', {
            'assetfailures': wos,
            'perms': PermWrapper(request.user)
        })
    else:
        context = {'assetRandeman': comp1}
        data['html_assetRandeman_form'] = render_to_string('mrp/assetrandeman/partialAssetRandemanDelete.html',
            context,
            request=request,
        )
    return JsonResponse(data)

# def list_failures(request):
#     formulas=Failure.objects.all()
#     return render(request,"mrp/failures/failureList.html",{'failures':formulas,'title':'لیست توقفات'})
# ##########################################################
# def monthly_detaild_failured_report(request):
#     days=[]
#     shift=Shift.objects.all()
#     asset_category=asset_categories = AssetCategory.objects.annotate(
#         min_priority=models.Min('asset__assetTavali')
#         ).order_by('min_priority')
#
#     current_date_time2 = jdatetime.datetime.now()
#     current_year=current_date_time2.year
#     j_month=request.GET.get('month',current_date_time2.month)
#
#
#     current_date_time = jdatetime.date(current_year, j_month, 1)
#     current_jalali_date = current_date_time
#
#
#
#     if current_jalali_date.month == 12:
#         first_day_of_next_month = current_jalali_date.replace(day=1, month=1, year=current_jalali_date.year + 1)
#     else:
#         first_day_of_next_month = current_jalali_date.replace(day=1, month=current_jalali_date.month + 1)
#
#
#     num_days = (first_day_of_next_month - jdatetime.timedelta(days=1)).day
#     cat_list=[]
#     for cats in asset_category:
#         sh_list=[]
#
#         days=[]
#         for day in range(1,num_days+1):
#             product={}
#             j_date=jdatetime.date(current_jalali_date.year,current_jalali_date.month,day)
#             for sh in shift:
#                 product[sh.id]=get_sum_machine_failure_by_date_shift(cats,sh,j_date.togregorian())
#             days.append({'cat':cats,'date':"{0}/{1}/{2}".format(current_jalali_date.year,current_jalali_date.month,day),'day_of_week':DateJob.get_day_of_week(j_date),'product':product})
#
#         cat_list.append({'cat':cats,'shift_val':days})
#
#     return render(request,'mrp/assetfailure/monthly_failure_detailed.html',{'cats':asset_category,'title':'آمار ماهانه','cat_list':cat_list,'shift':shift})
