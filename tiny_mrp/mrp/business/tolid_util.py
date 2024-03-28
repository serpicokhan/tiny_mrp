from mrp.models import *
from django.db.models import Sum
from datetime import timedelta
from django.core.paginator import *
from mrp.business.DateJob import *
import math

def doPaging(request,books):
    page=request.GET.get('page',1)
    paginator = Paginator(books, 12)
    wos=None
    try:
        wos=paginator.page(page)
    except PageNotAnInteger:
        wos = paginator.page(1)
    except EmptyPage:
        wos = paginator.page(paginator.num_pages)
    return wos

def get_asset_count(target_category_name):
    return Asset.objects.filter(assetCategory=target_category_name).count()


def get_sum_machin_product_by_cat(machine,target_date):

    production_sum = DailyProduction.objects.filter(
    machine__assetCategory=machine.assetCategory,
    dayOfIssue=target_date
    ).aggregate(Sum('production_value'))['production_value__sum'] or 0
    # print(machine.id,target_date,production_sum)
    return production_sum
def get_sum_machine_by_date_shift(assetCatregory,shift,target_date):
        t2 = DailyProduction.objects.filter(
        machine__assetCategory=assetCatregory,
        dayOfIssue=target_date,shift=shift
        ).aggregate(Sum('production_value'))['production_value__sum'] or 0
        # print(machine.id,target_date,production_sum)
        return t2
def get_sum_machine_by_date_range_shift(assetCatregory,shift,start_date,end_date):
        t2 = DailyProduction.objects.filter(
        machine__assetCategory=assetCatregory,
        dayOfIssue__range=[start_date,end_date],shift=shift
        ).aggregate(Sum('production_value'))['production_value__sum'] or 0
        # print(machine.id,target_date,production_sum)
        return t2
def get_monthly_machine_by_date_shift(assetCatregory,shift,start,end):
        if(assetCatregory.id==10 or assetCatregory.id==9):
             return 2000
        else:
            t2 = DailyProduction.objects.filter(
            machine__assetCategory=assetCatregory,
            dayOfIssue__range=[start,end],shift=shift
            ).aggregate(Sum('production_value'))['production_value__sum'] or 0
            # print(machine.id,target_date,production_sum)
            return t2
def get_sum_machine_failure_by_date_shift(assetCatregory,shift,target_date):
        filtered_failures = AssetFailure.objects.filter(
        dayOfIssue=target_date,
        shift=shift,
        asset_name__assetCategory=assetCatregory
        )
        assets_count = assetCatregory.asset_set.all().count()


        # Retrieve durations of the filtered failures and calculate the sum
        # total_failure_duration = filtered_failures.aggregate(total_duration=Sum('duration'))['total_duration']
        total_failure_duration = sum(
            failure.duration.hour * 60 + failure.duration.minute for failure in filtered_failures
        )
        if total_failure_duration:
            
            total_failure_duration=int(total_failure_duration / assets_count)
            hours = total_failure_duration // 60
            minutes = total_failure_duration % 60
            formatted_duration = f"{hours:02d}:{minutes:02d}"
            return formatted_duration
        else:
            return 0
def get_sum_machine_failure_monthly_shift(assetCatregory,shift,start,end):
        filtered_failures = AssetFailure.objects.filter(
        dayOfIssue__range=[start,end],
        shift=shift,
        asset_name__assetCategory=assetCatregory
        )
        assets_count = assetCatregory.asset_set.all().count()

        # Retrieve durations of the filtered failures and calculate the sum
        # total_failure_duration = filtered_failures.aggregate(total_duration=Sum('duration'))['total_duration']
        total_failure_duration = sum(
            failure.duration.hour * 60 + failure.duration.minute for failure in filtered_failures
        )
        if total_failure_duration:
            total_failure_duration=int(total_failure_duration / assets_count)

            hours = total_failure_duration // 60
            minutes = total_failure_duration % 60
            formatted_duration = f"{hours:02d}:{minutes:02d}"
            return formatted_duration
        else:
            return 0
def get_day_machine_failure_monthly_shift(assetCatregory,shift,start,end):
        filtered_failures = AssetFailure.objects.filter(
        dayOfIssue__range=[start,end],
        shift=shift,
        asset_name__assetCategory=assetCatregory
        )
        assets_count = assetCatregory.asset_set.all().count()


        # Retrieve durations of the filtered failures and calculate the sum
        # total_failure_duration = filtered_failures.aggregate(total_duration=Sum('duration'))['total_duration']
        total_failure_duration = sum(
            failure.duration.hour * 60 + failure.duration.minute for failure in filtered_failures
        )
        if total_failure_duration:
            total_failure_duration=int(total_failure_duration / assets_count)

            hours = total_failure_duration // 60
            minutes = total_failure_duration % 60
            formatted_duration = f"{hours:02d}:{minutes:02d}"


            return (hours/8)+(minutes/800)
        else:
            return 0
def get_good_standard_machine_by_date_category(assetCatregory):
        t2 = ProductionStandard.objects.filter(
        machine_name__assetCategory=assetCatregory,

        ).aggregate(Sum('good_production_rate'))['good_production_rate__sum'] or 0

        # print(machine.id,target_date,production_sum)
        return t2
def get_mean_standard_machine_by_date_category(assetCatregory):
        t2 = ProductionStandard.objects.filter(
        machine_name__assetCategory=assetCatregory,

        ).aggregate(Sum('mean_production_rate'))['mean_production_rate__sum'] or 0

        # print(machine.id,target_date,production_sum)
        return t2
def get_bad_standard_machine_by_date_category(assetCatregory):
        t2 = ProductionStandard.objects.filter(
        machine_name__assetCategory=assetCatregory,

        ).aggregate(Sum('bad_production_rate'))['bad_production_rate__sum'] or 0

        # print(machine.id,target_date,production_sum)
        return t2
def get_sum__speed_machine_by_category(assetCatregory,target_date):
        sum=0
        shift=Shift.objects.all()
        t2 = DailyProduction.objects.filter(
        machine__assetCategory=assetCatregory,
        dayOfIssue=target_date
        )

        for i in t2:
            if(i.eval_max_tolid()>0):
                sum+=i.production_value/i.eval_max_tolid()
            else:
                sum+=0
        # print(machine.id,target_date,production_sum)
        i=t2.count()
        if(i>0):
            return sum*shift.count()/t2.count()
        return 0
def get_sum_vaz_zayeat_by_date(specific_date):
    sum_vazn = ZayeatVaz.objects.filter(dayOfIssue=specific_date).aggregate(total_vazn=Sum('vazn'))

    # Access the sum value
    total_vazn_for_specific_date = sum_vazn['total_vazn'] or 0  # Default to 0 if there's no sum
    print(total_vazn_for_specific_date)
    return total_vazn_for_specific_date

def get_randeman_per_tolid_byshift(mah,sal,asset_cat,shift):
    start_date_gregorian, end_date_gregorian = DateJob.shamsi_to_gregorian_range(sal, mah)

    num_days=(end_date_gregorian-start_date_gregorian).days+1

    sum_production_value=get_monthly_machine_by_date_shift(asset_cat,shift,start_date_gregorian,end_date_gregorian)

    if(not sum_production_value):
        return 0
    # print(start_date_gregorian,end_date_gregorian)
    day_machine_failure_monthly_shift = get_day_machine_failure_monthly_shift(asset_cat,shift,start_date_gregorian,end_date_gregorian)
    total_day_per_shift= num_days - day_machine_failure_monthly_shift
    mean_day_per_shift=sum_production_value/total_day_per_shift

    # print("day_machine_failure_monthly_shift",day_machine_failure_monthly_shift)
    # print("total_day_per_shift",total_day_per_shift)
    # print("mean_day_per_shift",mean_day_per_shift)

    return mean_day_per_shift
def get_randeman_per_tolid(mah,sal,asset_cat):
    start_date_gregorian, end_date_gregorian = DateJob.shamsi_to_gregorian_range(sal, mah)
    

    sum=0
    shifts=Shift.objects.all()
    for i in shifts:
        sum+=get_randeman_per_tolid_byshift(mah,sal,asset_cat,i)

    
    return sum




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
                if(i.id==10):
                    result=math.ceil((float(kole_randeman)*2000)/float(6000))
                    AssetRandemanPerMonth.objects.create(asset_category=i,shift=shift,tolid_value=result,mah=mah,sal=sal)
            else:
                # print(f"kole randeman {kole_randeman},tolid shift {tolid_shift} and  kole tolid={kole_tolid}")
                result=math.ceil((float(kole_randeman)*tolid_shift)/float(kole_tolid))
                if(i.id==10):
                     print("!!!!!!!!!!")
                AssetRandemanPerMonth.objects.create(asset_category=i,shift=shift,tolid_value=result,mah=mah,sal=sal)
def create_first_padash(AssetRandemanListId):
    asset_randeman=AssetRandemanList.objects.get(id=AssetRandemanListId)
    shifts=Shift.objects.all()
    tolid_rank=get_tolid_rank(asset_randeman.sal,asset_randeman.mah)
    sorted_footballers_by_goals = sorted(tolid_rank, key=tolid_rank.get,reverse=True)

    print(sorted_footballers_by_goals)
    for i in shifts:
        # TolidPadash.objects.create(asset_randeman_list=asset_randeman,rank=i.id,price_sarshift=0,price_personnel=0)
        # print(tolid_rank.index(i.id),'!!!!!!!!!')
        print(i.id,'$$$$$$$$$$$$')
        print(sorted_footballers_by_goals.index(1),'!!!!!!!!!!!!!')
        padash_tolid=TolidPadash.objects.get(rank=sorted_footballers_by_goals.index(i.id)+1) #tolid_rank.index(i.id)
        rank=sorted_footballers_by_goals.index(i.id)+1
        TolidRanking.objects.create(asset_randeman_list=asset_randeman,shift=i,rank=rank,price_sarshift=padash_tolid.price_sarshift,price_personnel=padash_tolid.price_personnel)
        NezafatRanking.objects.create(asset_randeman_list=asset_randeman,shift=i,rank=i.id,price_sarshift=0,price_personnel=0)
        # NezafatPadash.objects.create(asset_randeman_list=asset_randeman,rank=i.id,price_sarshift=0,price_personnel=0)
        # TolidPadash.objects.create(asset_randeman_list=asset_randeman,rank=i.id,price_sarshift=0,price_personnel=0)
def get_tolid_rank(sal,mah):
    shifts=Shift.objects.all()
    asset_cats=AssetCategory.objects.all().order_by('priority')
    current_date_time2 = jdatetime.datetime.now()

    current_year=current_date_time2.year
    # j_month=request.GET.get('month',current_date_time2.month)
    j_month=mah

    # j_year=int(request.GET.get('year',current_year))
    j_year=sal
    current_date_time = jdatetime.date(j_year, int(j_month), 1)
    current_jalali_date = current_date_time
    if current_jalali_date.month == 12:
        first_day_of_next_month = current_jalali_date.replace(day=1, month=1, year=j_year + 1)
    else:
        first_day_of_next_month = current_jalali_date.replace(day=1, month=current_jalali_date.month + 1)


    num_days = (first_day_of_next_month - jdatetime.timedelta(days=1)).day
    
    totals=[]
    sum={}
    for sh in shifts:
        sum[sh.id]=0
    
    for cats in asset_cats:
            product={}
            start=jdatetime.date(j_year,current_jalali_date.month,1)
            end=jdatetime.date(j_year,current_jalali_date.month,num_days)
            for sh in shifts:
                product[sh.id]=get_monthly_machine_by_date_shift(cats,sh,start.togregorian(),end.togregorian())
                
            # days.append({'cat':cats,'date':"",'day_of_week':'جمع','product':product})
            failure_days={}
            for sh in shifts:
                failure_days[sh.id]=get_day_machine_failure_monthly_shift(cats,sh,start.togregorian(),end.togregorian())

            total_day_per_shift={}
            for sh in shifts:
                
                total_day_per_shift[sh.id]=num_days-failure_days[sh.id]
            # days.append({'cat':cats,'date':"",'day_of_week':'روز کاری','product':total_day_per_shift})
            mean_day_per_shift={}
            for sh in shifts:
                if(cats.id==9 or cats.id==10):
                    mean_day_per_shift[sh.id]=2000
                    sum[sh.id]+=2000
                else:


                    mean_day_per_shift[sh.id]=product[sh.id]/total_day_per_shift[sh.id]
                    sum[sh.id]+=mean_day_per_shift[sh.id]
    sorted_keys = sorted(sum, key=sum.get, reverse=True)
    # Find the rank of the current item based on its position in sorted keys
   
    return sum  # Adding 1 to start rank at 1 instead of 0