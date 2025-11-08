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
from django.db.models import Avg
from django.db.models import Q

@login_required
def asset_randeman_list(request):

    books = AssetRandemanList.objects.order_by('-id')
    wos=doPaging(request,books)
    return render(request,"mrp/assetrandeman/assetRandemanList.html",{'assetfailures':wos,'title':'لیست راندمانهای محاسبه شده'})


# ##########################################################
def save_assetRandeman_form(request, form, template_name,id=None,is_new=None):


    data = dict()
    if (request.method == 'POST'):
        
            if form.is_valid():
                try:
                    bts=form.save()
                    if(is_new):
                        calc_assetrandeman(bts.mah,bts.sal)
                        create_first_padash(bts.id)
                        create_first_padash_v2(bts.id)
                        create_first_nezafat_padash_v2(bts.id)
                    data['form_is_valid'] = True
                    books = AssetRandemanList.objects.all()
                    wos=doPaging(request,books)
                    data['html_assetRandeman_list'] = render_to_string('mrp/assetrandeman/partialAssetRandemanList.html', {
                        'assetfailures': wos,
                        'perms': PermWrapper(request.user)
                    })
                except IntegrityError:
                    data['form_is_valid'] = False

                    data['form_error']='برای این تاریخ راندمان از قبل وجود دارد'
            else:
                data['form_is_valid'] = False
                print(form.errors)
                data['form_error']='خطایی رخ داده است'               
      

    context = {'form': form}


    data['html_assetRandeman_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
# ##########################################################
def assetRandeman_create(request):
    if (request.method == 'POST'):
        form = AssetRandemanForm(request.POST)
        return save_assetRandeman_form(request, form, 'mrp/assetrandeman/partialAssetRandemanCreate.html',is_new=True)
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
# def assetRandeman_nezafat_ranking_v2(request,id):
#     data=dict()
#     if (request.method == 'POST'):
#         pass
#     else:
#         shamsi_months = [
#                 'فروردین',
#                 'اردیبهشت',
#                 'خرداد',
#                 'تیر',
#                 'مرداد',
#                 'شهریور',
#                 'مهر',
#                 'آبان',
#                 'آذر',
#                 'دی',
#                 'بهمن',
#                 'اسفند'
#             ]
#         asset_randeman=AssetRandemanList.objects.get(id=id)
#         shift=NezafatRanking_V2.objects.filter(asset_randeman_list=asset_randeman).order_by('rank')

#         # shift2=NezafatPadash.objects.filter(asset_randeman_list=asset_randeman).order_by('rank')
#         # shift=[]
#         # for i in shift1:
#         #     shift.push({'id_rank':})
#         # print(shift)

#         data['html_assetRandeman_form'] = render_to_string('mrp/assetrandeman/partialRankingList_v2.html', {
#             'shifts':shift,'mah':shamsi_months[asset_randeman.mah-1],'sal':asset_randeman.sal,
#             'perms': PermWrapper(request.user),'title':'انتخاب رتبه نظافت'
#         },request=request)
#     return JsonResponse(data)

def assetRandeman_nezafat_ranking_v2(request, id):
    data = dict()
    if request.method == 'POST':
        pass
    else:
        shamsi_months = [
            'فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور',
            'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'
        ]
        asset_randeman = AssetRandemanList.objects.get(id=id)
        shifts = NezafatRanking_V2.objects.filter(asset_randeman_list=asset_randeman).order_by('rank')
        
        # دریافت دسته‌بندی‌های منحصربه‌فرد
        categories = MachineCategory_Nezafat.objects.all(
            
        )

        data['html_assetRandeman_form'] = render_to_string('mrp/assetrandeman/partialRankingList_v2.html', {
            'shifts': shifts,
            'categories': categories,
            'mah': shamsi_months[asset_randeman.mah - 1],
            'sal': asset_randeman.sal,
            'perms': PermWrapper(request.user),
            'title': 'انتخاب رتبه نظافت'
        }, request=request)
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
        
def calculate_sarshift_rankings(asset_randeman_list):
    """
    محاسبه و ذخیره رتبه‌بندی سرشیفت‌ها بر اساس میانگین رتبه‌های V2
    شیفت با پایین‌ترین میانگین، رتبه 1 می‌گیرد
    """
    from django.db import transaction
    
    # گرفتن لیست تمام شیفت‌هایی که در V2 دارند
    shifts_with_data = NezafatRanking_V2.objects.filter(
        asset_randeman_list=asset_randeman_list
    ).values_list('shift', flat=True).distinct()
    
    # محاسبه میانگین رتبه برای هر شیفت
    shift_averages = []
    for shift_id in shifts_with_data:
        shift = Shift.objects.get(id=shift_id)
        
        # محاسبه میانگین رتبه
        avg_rank = NezafatRanking_V2.objects.filter(
            asset_randeman_list=asset_randeman_list,
            shift=shift
        ).aggregate(Avg('rank'))['rank__avg']
        
        # # محاسبه مجموع قیمت‌ها
        # v2_records = NezafatRanking_V2.objects.filter(
        #     asset_randeman_list=asset_randeman_list,
        #     shift=shift
        # )
        
        # total_price_sarshift = sum(record.price_sarshift for record in v2_records)
        # total_price_personnel = sum(record.price_personnel for record in v2_records)
        
        shift_averages.append({
            'shift': shift,
            'avg_rank': avg_rank,
            # 'price_sarshift': total_price_sarshift,
            # 'price_personnel': total_price_personnel,
        })
    
    # مرتب‌سازی بر اساس میانگین (پایین‌ترین = رتبه 1)
    shift_averages.sort(key=lambda x: x['avg_rank'])
    
    # ذخیره رتبه‌ها
    with transaction.atomic():
        current_rank = 1
        previous_avg = None
        count_same_rank = 0
        
        for index, shift_data in enumerate(shift_averages):
            # اگر میانگین با قبلی برابر نیست، رتبه رو به‌روز کن
            if previous_avg is not None and shift_data['avg_rank'] != previous_avg:
                current_rank = index + 1
                count_same_rank = 0
            
            count_same_rank += 1
            
            # محاسبه پاداش بر اساس میانگین رتبه‌های تکراری
            if count_same_rank == 1:
                # اول چک می‌کنیم چند تا با همین میانگین داریم
                same_avg_count = sum(
                    1 for s in shift_averages 
                    if s['avg_rank'] == shift_data['avg_rank']
                )
                
                # مجموع پاداش‌های رتبه‌های متوالی
                total_padash = 0
                for i in range(same_avg_count):
                    try:
                        padash_item = NezafatPadash.objects.get(
                            rank=current_rank + i,
                            profile=asset_randeman_list.profile
                        )
                        total_padash += padash_item.price_sarshift
                    except NezafatPadash.DoesNotExist:
                        pass
                
                # میانگین پاداش‌ها
                avg_padash = total_padash / same_avg_count if same_avg_count > 0 else 0
            
            NezafatRanking.objects.update_or_create(
                asset_randeman_list=asset_randeman_list,
                shift=shift_data['shift'],
                defaults={
                    'rank': current_rank,
                    'price_sarshift': avg_padash,
                    'price_personnel': 0,
                }
            )
            
            previous_avg = shift_data['avg_rank']
    
    return shift_averages



@csrf_exempt
def assetRandeman_ranking_create_v2(request):
    if request.method == 'POST':
        try:
            # Access the 'items' key from the POST data
            received_data = json.loads(request.body)
            asset_randeman_list=None
            for item in received_data:
                # دریافت آبجکت مورد نظر
                ranking_obj = NezafatRanking_V2.objects.get(id=item["id"])
                asset_randeman_list=ranking_obj.asset_randeman_list
                
                # آپدیت فیلدها
                ranking_obj.rank = item['rank']
                ranking_obj.price_sarshift = item['price_sarshift']
                ranking_obj.price_personnel = item['price_personnel']
                ranking_obj.save()
            calculate_sarshift_rankings(asset_randeman_list)

            return JsonResponse({'status': 'success', 'message': 'داده‌ها با موفقیت ذخیره شد'})
            
        except NezafatRanking_V2.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'رکورد مورد نظر یافت نشد'})
            
        except KeyError as e:
            return JsonResponse({'status': 'error', 'message': f'فیلد اجباری یافت نشد: {str(e)}'})
            
        except json.JSONDecodeError as e:
            return JsonResponse({'status': 'error', 'message': 'فرمت JSON نامعتبر است'})
            
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': f'خطای سیستمی: {str(e)}'})
    
    else:
        return JsonResponse({'status': 'error', 'message': 'متد درخواست نامعتبر است'})
@csrf_exempt
def calc_assetRandeman_nezafat_ranking(request):
    if request.method == 'POST':
        try:
            a={}
            b=[]
            for i in range(1,4):
                a[i]=0
            
            # Access the 'items' key from the POST data
            received_data = json.loads(request.body)

            for i in received_data:
                # print(i)
                p=NezafatRanking.objects.get(id=i["id"])
                p.rank=i['position']
                p.price_sarshift=i['nezafatdash_sarshift']
                p.price_personnel=i['nezafatdash_operator']
                a[int(p.rank)]+=1
                b.append(p)
            rank_1=find_who_take_1_padash(b)
            rank_2=find_who_take_2_padash(b)
            rank_3=find_who_take_3_padash(b)
            padash_1=NezafatPadash.objects.get(rank=1,profile=b[0].asset_randeman_list.profile)
            padash_2=NezafatPadash.objects.get(rank=2,profile=b[0].asset_randeman_list.profile)
            padash_3=NezafatPadash.objects.get(rank=3,profile=b[0].asset_randeman_list.profile)
            if(len(rank_1)==1):
                n=rank_1[0]
                n.price_sarshift=padash_1.price_sarshift
                n.price_personnel=padash_1.price_personnel
                
            elif(len(rank_1)==2):
                # print(padash_2)
                
                padash_sarshift=(padash_1.price_sarshift+padash_2.price_sarshift)/2
                padash_personel=(padash_1.price_personnel+padash_2.price_personnel)/2
                
                for i in rank_1:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel
                    
            else:
                padash_sarshift=(padash_1.price_sarshift+padash_2.price_sarshift+padash_3.price_sarshift)/3
                padash_personel=(padash_1.price_personnel+padash_2.price_personnel+padash_3.price_personnel)/3
                for i in rank_1:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel


            if(len(rank_2)==1):
                n=rank_2[0]
                n.price_sarshift=padash_2.price_sarshift
                n.price_personnel=padash_2.price_personnel
                
            elif(len(rank_2)==2):
                # print(padash_2)
                
                padash_sarshift=(padash_2.price_sarshift+padash_3.price_sarshift)/2
                padash_personel=(padash_2.price_personnel+padash_3.price_personnel)/2
                
                for i in rank_2:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel
                    
            else:
                padash_sarshift=(padash_1.price_sarshift+padash_2.price_sarshift+padash_3.price_sarshift)/3
                padash_personel=(padash_1.price_personnel+padash_2.price_personnel+padash_3.price_personnel)/3
                for i in rank_2:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel


            if(len(rank_3)==1):
                n=rank_3[0]
                n.price_sarshift=padash_3.price_sarshift
                n.price_personnel=padash_3.price_personnel
                
            elif(len(rank_3)==2):
                # print(padash_2)
                
                padash_sarshift=(padash_2.price_sarshift+padash_3.price_sarshift)/2
                padash_personel=(padash_2.price_personnel+padash_3.price_personnel)/2
                
                for i in rank_3:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel
                    
            else:
                padash_sarshift=(padash_1.price_sarshift+padash_2.price_sarshift+padash_3.price_sarshift)/3
                padash_personel=(padash_1.price_personnel+padash_2.price_personnel+padash_3.price_personnel)/3
                for i in rank_2:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel
                    


            # rank_2=find_who_take_2_padash(b)
            # rank_3=find_who_take_3_padash(b)
           
            result=[]
            for i in rank_1:
                result.append({'id':i.id,'rank':i.rank,'price_sarshift':i.price_sarshift,'price_personnel':i.price_personnel})
            for i in rank_2:
                result.append({'id':i.id,'rank':i.rank,'price_sarshift':i.price_sarshift,'price_personnel':i.price_personnel})
            for i in rank_3:
                result.append({'id':i.id,'rank':i.rank,'price_sarshift':i.price_sarshift,'price_personnel':i.price_personnel})
            return JsonResponse({'status': '1','result':result})
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
def calc_assetRandeman_nezafat_ranking_v2(request):
    if request.method == 'POST':
        try:
            received_data = json.loads(request.body)
            
            if not received_data:
                return JsonResponse({'status': 'error', 'message': 'هیچ داده‌ای دریافت نشد'})

            result = []
            categories_data = {}

            # گروه‌بندی داده‌ها بر اساس assetMachineCategory
            for item in received_data:
                try:
                    ranking_obj = NezafatRanking_V2.objects.get(id=item["id"])
                    category = ranking_obj.assetMachineCategory
                    profile = ranking_obj.asset_randeman_list.profile
                    
                    if category.id not in categories_data:
                        categories_data[category.id] = {
                            'category': category,
                            'profile': profile,
                            'rank_groups': {1: [], 2: [], 3: []}
                        }
                    
                    # اضافه کردن به گروه رتبه مربوطه
                    rank = int(item.get('rank', 0))
                    if rank in [1, 2, 3]:
                        categories_data[category.id]['rank_groups'][rank].append(ranking_obj)
                        
                except NezafatRanking_V2.DoesNotExist:
                    continue

            # پردازش برای هر دسته‌بندی
            for category_id, category_data in categories_data.items():
                category = category_data['category']
                profile = category_data['profile']
                rank_groups = category_data['rank_groups']
                
                # دریافت پاداش‌های مربوط به این دسته‌بندی
                padash_data = {}
                for rank in [1, 2, 3]:
                    try:
                        # اول سعی می‌کنیم پاداش مخصوص این دسته‌بندی را پیدا کنیم
                        padash_data[rank] = NezafatPadash_V2.objects.get(
                            rank=rank, 
                            profile=profile,
                            assetMachineCategory=category
                        )
                    except NezafatPadash_V2.DoesNotExist:
                        try:
                            # اگر پیدا نشد، از پاداش عمومی استفاده می‌کنیم
                            padash_data[rank] = NezafatPadash_V2.objects.get(
                                rank=rank, 
                                profile=profile,
                                assetMachineCategory__isnull=True
                            )
                        except NezafatPadash_V2.DoesNotExist:
                            # اگر پاداش عمومی هم وجود نداشت، خطا می‌دهیم
                            return JsonResponse({
                                'status': 'error', 
                                'message': f'پاداش برای رتبه {rank} یافت نشد'
                            })

                # محاسبه پاداش برای هر رتبه
                for rank in [1, 2, 3]:
                    items = rank_groups[rank]
                    if not items:
                        continue
                        
                    if rank == 1:
                        calculate_rewards_for_rank(items, padash_data[1], padash_data[2], padash_data[3])
                    elif rank == 2:
                        calculate_rewards_for_rank(items, padash_data[2], padash_data[3], padash_data[1])
                    elif rank == 3:
                        calculate_rewards_for_rank(items, padash_data[3], padash_data[2], padash_data[1])

                # جمع‌آوری نتایج
                for rank in [1, 2, 3]:
                    for obj in rank_groups[rank]:
                        result.append({
                            'id': obj.id,
                            'rank': obj.rank,
                            # 'price_sarshift': float(obj.price_sarshift),
                            'price_personnel': float(obj.price_personnel),
                            'category_id': category_id,
                            'category_name': category.name,
                            'shift_name': obj.shift.name
                        })

            return JsonResponse({'status': 'success', 'result': result})

        except json.JSONDecodeError as e:
            return JsonResponse({'status': 'error', 'message': 'فرمت JSON نامعتبر است'})
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': f'خطای سیستمی: {str(e)}'})
    
    else:
        return JsonResponse({'status': 'error', 'message': 'متد درخواست نامعتبر است'})

# تابع کمکی برای محاسبه پاداش‌ها
def calculate_rewards_for_rank(items, primary_padash, secondary_padash, tertiary_padash):
    count = len(items)
    
    if count == 1:
        # items[0].price_sarshift = primary_padash.price_sarshift
        items[0].price_personnel = primary_padash.price_personnel
    elif count == 2:
        # avg_sarshift = (primary_padash.price_sarshift + secondary_padash.price_sarshift) / 2
        avg_personnel = (primary_padash.price_personnel + secondary_padash.price_personnel) / 2
        for item in items:
            # item.price_sarshift = avg_sarshift
            item.price_personnel = avg_personnel
    elif count >= 3:
        # avg_sarshift = (primary_padash.price_sarshift + secondary_padash.price_sarshift + tertiary_padash.price_sarshift) / 3
        avg_personnel = (primary_padash.price_personnel + secondary_padash.price_personnel + tertiary_padash.price_personnel) / 3
        for item in items:
            # item.price_sarshift = avg_sarshift
            item.price_personnel = avg_personnel
@csrf_exempt
def calc_assetRandeman_tolid_ranking(request):
    if request.method == 'POST':
        try:
            a={}
            b=[]
            for i in range(1,4):
                a[i]=0
            
            # Access the 'items' key from the POST data
            received_data = json.loads(request.body)

            for i in received_data:
                # print(i)
                p=TolidRanking.objects.get(id=i["id"])
                p.rank=i['position']
                p.price_sarshift=i['nezafatdash_sarshift']
                p.price_personnel=i['nezafatdash_operator']
                a[int(p.rank)]+=1
                b.append(p)
            rank_1=find_who_take_1_padash(b)
            rank_2=find_who_take_2_padash(b)
            rank_3=find_who_take_3_padash(b)
            padash_1=TolidPadash.objects.get(rank=1,profile=b[0].asset_randeman_list.profile)
            padash_2=TolidPadash.objects.get(rank=2,profile=b[0].asset_randeman_list.profile)
            padash_3=TolidPadash.objects.get(rank=3,profile=b[0].asset_randeman_list.profile)
            if(len(rank_1)==1):
                n=rank_1[0]
                n.price_sarshift=padash_1.price_sarshift
                n.price_personnel=padash_1.price_personnel
                
            elif(len(rank_1)==2):
                # print(padash_2)
                
                padash_sarshift=(padash_1.price_sarshift+padash_2.price_sarshift)/2
                padash_personel=(padash_1.price_personnel+padash_2.price_personnel)/2
                
                for i in rank_1:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel
                    
            else:
                padash_sarshift=(padash_1.price_sarshift+padash_2.price_sarshift+padash_3.price_sarshift)/3
                padash_personel=(padash_1.price_personnel+padash_2.price_personnel+padash_3.price_personnel)/3
                for i in rank_1:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel


            if(len(rank_2)==1):
                n=rank_2[0]
                n.price_sarshift=padash_2.price_sarshift
                n.price_personnel=padash_2.price_personnel
                
            elif(len(rank_2)==2):
                # print(padash_2)
                
                padash_sarshift=(padash_2.price_sarshift+padash_3.price_sarshift)/2
                padash_personel=(padash_2.price_personnel+padash_3.price_personnel)/2
                
                for i in rank_2:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel
                    
            else:
                padash_sarshift=(padash_1.price_sarshift+padash_2.price_sarshift+padash_3.price_sarshift)/3
                padash_personel=(padash_1.price_personnel+padash_2.price_personnel+padash_3.price_personnel)/3
                for i in rank_2:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel


            if(len(rank_3)==1):
                n=rank_3[0]
                n.price_sarshift=padash_3.price_sarshift
                n.price_personnel=padash_3.price_personnel
                
            elif(len(rank_3)==2):
                # print(padash_2)
                
                padash_sarshift=(padash_2.price_sarshift+padash_3.price_sarshift)/2
                padash_personel=(padash_2.price_personnel+padash_3.price_personnel)/2
                
                for i in rank_3:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel
                    
            else:
                padash_sarshift=(padash_1.price_sarshift+padash_2.price_sarshift+padash_3.price_sarshift)/3
                padash_personel=(padash_1.price_personnel+padash_2.price_personnel+padash_3.price_personnel)/3
                for i in rank_2:
                    i.price_sarshift=padash_sarshift
                    i.price_personnel=padash_personel
                    


            # rank_2=find_who_take_2_padash(b)
            # rank_3=find_who_take_3_padash(b)
           
            result=[]
            for i in rank_1:
                result.append({'id':i.id,'rank':i.rank,'price_sarshift':i.price_sarshift,'price_personnel':i.price_personnel})
            for i in rank_2:
                result.append({'id':i.id,'rank':i.rank,'price_sarshift':i.price_sarshift,'price_personnel':i.price_personnel})
            for i in rank_3:
                result.append({'id':i.id,'rank':i.rank,'price_sarshift':i.price_sarshift,'price_personnel':i.price_personnel})
            return JsonResponse({'status': '1','result':result})
        except TolidRanking.DoesNotExist:
            # NezafatRanking.objects.create()
            print("123!!!!!!!")
        except TolidPadash.DoesNotExist:
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
            print("!!!!!!!!!!!!!!!")

            for i in received_data:
                # print(i)
                p=TolidRanking.objects.get(id=i["id"])
                p.rank=i['position']
                # q.rank=i['position']
                p.price_sarshift=i['nezafatdash_sarshift']
                p.price_personnel=i['nezafatdash_operator']
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
