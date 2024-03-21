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
from django.views.decorators.csrf import csrf_exempt


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
            create_first_padash(bts.id)
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
def assetRandeman_nezafat_ranking(request,id):
    data=dict()
    if (request.method == 'POST'):
        pass
    else:
        shamsi_months = [
                'فروردین',
                'اردیبهشت',
                'خرداد',
                'تیر',
                'مرداد',
                'شهریور',
                'مهر',
                'آبان',
                'آذر',
                'دی',
                'بهمن',
                'اسفند'
            ]
        asset_randeman=AssetRandemanList.objects.get(id=id)
        shift=NezafatRanking.objects.filter(asset_randeman_list=asset_randeman).order_by('rank')
        # shift2=NezafatPadash.objects.filter(asset_randeman_list=asset_randeman).order_by('rank')
        # shift=[]
        # for i in shift1:
        #     shift.push({'id_rank':})
        # print(shift)

        data['html_assetRandeman_form'] = render_to_string('mrp/assetrandeman/partialRankingList.html', {
            'shifts':shift,'mah':shamsi_months[asset_randeman.mah-1],'sal':asset_randeman.sal,
            'perms': PermWrapper(request.user),'title':'انتخاب رتبه نظافت'
        },request=request)
    return JsonResponse(data)

def assetRandeman_padash_ranking(request,id):
    data=dict()
    if (request.method == 'POST'):
        pass
    else:
        shamsi_months = [
                'فروردین',
                'اردیبهشت',
                'خرداد',
                'تیر',
                'مرداد',
                'شهریور',
                'مهر',
                'آبان',
                'آذر',
                'دی',
                'بهمن',
                'اسفند'
            ]
        asset_randeman=AssetRandemanList.objects.get(id=id)
        shift=TolidRanking.objects.filter(asset_randeman_list=asset_randeman).order_by('rank')
        data['html_assetRandeman_form'] = render_to_string('mrp/assetrandeman/partialTolidRankingList.html', {
            'shifts':shift,'mah':shamsi_months[asset_randeman.mah-1],'sal':asset_randeman.sal,
            'perms': PermWrapper(request.user),'title':'انتخاب رتبه تولید'
        })
    return JsonResponse(data)
@csrf_exempt
def assetRandeman_ranking_create(request):
    if request.method == 'POST':
        try:
            # Access the 'items' key from the POST data
            received_data = json.loads(request.body)

            for i in received_data:
                # print(i)
                p=NezafatRanking.objects.get(id=i["id"])
                # q=NezafatPadash.objects.get(id=i["id"])
                p.rank=i['position']
                # q.rank=i['position']
                p.price_sarshift=i['nezafatdash_sarshift']
                p.price_personnel=i['nezafatdash_operator']
                p.save()
                # q.save()

            # Now 'received_data' is a list of dictionaries containing 'id' and 'position'

            # Process the data as needed, for example, save it to the database
            # YourModel.objects.bulk_create([YourModel(id=item['id'], position=item['position']) for item in received_data])

            return JsonResponse({'status': 'success'})
        except NezafatRanking.DoesNotExist:
            # NezafatRanking.objects.create()
            print("123!!!!!!!")
        except NezafatPadash.DoesNotExist:
            # NezafatRanking.objects.create()
            print("$$$$$$$$$$")

        except json.JSONDecodeError as e:
            return JsonResponse({'status': 'error', 'message': 'Invalid JSON format'})
        return JsonResponse({'status': 'error'})
    else:
            return JsonResponse({'status': 'error', 'message': 'Invalid request method'})

@csrf_exempt
def assetRandeman_tolid_ranking_create(request):
    if request.method == 'POST':
        try:
            # Access the 'items' key from the POST data
            received_data = json.loads(request.body)

            for i in received_data:
                # print(i)
                p=TolidRanking.objects.get(id=i["id"])
                p.rank=i['position']
                p.save()

            # Now 'received_data' is a list of dictionaries containing 'id' and 'position'

            # Process the data as needed, for example, save it to the database
            # YourModel.objects.bulk_create([YourModel(id=item['id'], position=item['position']) for item in received_data])

            return JsonResponse({'status': 'success'})
        except json.JSONDecodeError as e:
            return JsonResponse({'status': 'error', 'message': 'Invalid JSON format'})
    else:
            return JsonResponse({'status': 'error', 'message': 'Invalid request method'})




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
