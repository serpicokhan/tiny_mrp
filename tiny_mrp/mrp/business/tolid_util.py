from mrp.models import *
from django.db.models import Sum
from datetime import timedelta
from django.core.paginator import *
from mrp.business.DateJob import *
from collections import defaultdict
import json
import math
from decimal import Decimal

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
def get_sum_machine_by_date_shift_makan(assetCatregory,makan_id,shift,target_date):
        print(makan_id,"%%%%%%%")
        t2 = DailyProduction.objects.filter(
        machine__assetCategory=assetCatregory,machine__assetIsLocatedAt__id=makan_id,
        dayOfIssue=target_date,shift=shift
        ).aggregate(Sum('production_value'))['production_value__sum'] or 0
        # print(machine.id,target_date,production_sum)
        return t2
def get_sum_zayeat_by_date_shift_makan(makan_id,shift,target_date):
    result = ZayeatVaz.objects.filter(
    dayOfIssue=target_date,
    makan__id=makan_id,
    shift=shift
    ).aggregate(total_vazn=Sum('vazn'))
    return result
    
def get_sum_machine_by_date_range_shift(assetCatregory,shift,start_date,end_date):
        t2 = DailyProduction.objects.filter(
        machine__assetCategory=assetCatregory,
        dayOfIssue__range=[start_date,end_date],shift=shift
        ).aggregate(Sum('production_value'))['production_value__sum'] or 0
        # print(machine.id,target_date,production_sum)
        return t2
def get_sum_machine_by_date_range_shift_makan(assetCatregory,makan,shift,start_date,end_date):
        t2 = DailyProduction.objects.filter(
        machine__assetCategory=assetCatregory,machine__assetIsLocatedAt__id=makan,
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
# def get_monthly_operator(,start,end):
    

        
           
def get_monthly_machine_by_date_shift_makan(assetCatregory,makan_id,shift,start,end):
            t2 = DailyProduction.objects.filter(
            machine__assetCategory=assetCatregory,
            dayOfIssue__range=[start,end],shift=shift,machine__assetIsLocatedAt__id=makan_id
            ).aggregate(Sum('production_value'))['production_value__sum'] or 0
            # print(machine.id,target_date,production_sum)
            return t2
def get_sum_machine_failure_by_date_shift(assetCatregory,shift,target_date):
        filtered_failures = AssetFailure.objects.filter(
        dayOfIssue=target_date,
        shift=shift,
        asset_name__assetCategory=assetCatregory,failure_name__is_it_count=True
        )
        assets_count = assetCatregory.assetcategory_main.all().count()


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
        asset_name__assetCategory=assetCatregory,failure_name__is_it_count=True
        )
        assets_count = assetCatregory.assetcategory_main.all().count()

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
        asset_name__assetCategory=assetCatregory,failure_name__is_it_count=True
        )
        assets_count = assetCatregory.assetcategory_main.all().count()


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
def get_day_machine_failure_monthly_shift_makan(assetCatregory,makan_id,shift,start,end):
        filtered_failures = AssetFailure.objects.filter(
        dayOfIssue__range=[start,end],
        shift=shift,
        asset_name__assetCategory=assetCatregory,failure_name__is_it_count=True,asset_name__assetIsLocatedAt__id=makan_id
        )
        assets_count = assetCatregory.assetcategory_main.all().count()


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
        shift=Shift.objects.all().count()
        t2 = DailyProduction.objects.filter(
        machine__assetCategory=assetCatregory,
        dayOfIssue=target_date
        )
        print(t2.count(),assetCatregory)

        for i in t2:
            if(i.eval_max_tolid()>0):
                sum+=(i.production_value / i.eval_max_tolid())
            else:
                sum+=0
        # print(machine.id,target_date,production_sum)
        i=t2.count()
        print(sum)
        if(i>0):
            m_count=Asset.objects.filter(assetCategory=assetCatregory).count()
            return sum/(shift*m_count)
        return 0
def get_sum_vaz_zayeat_by_date(specific_date):
    sum_vazn = ZayeatVaz.objects.filter(dayOfIssue=specific_date).aggregate(total_vazn=Sum('vazn'))

    # Access the sum value
    total_vazn_for_specific_date = sum_vazn['total_vazn'] or 0  # Default to 0 if there's no sum
    print(total_vazn_for_specific_date)
    return total_vazn_for_specific_date
def get_sum_vaz_zayeat_by_date_per_line(specific_date,makan):
    sum_vazn = ZayeatVaz.objects.filter(dayOfIssue=specific_date,makan__id=makan).aggregate(total_vazn=Sum('vazn'))

    # Access the sum value
    total_vazn_for_specific_date = sum_vazn['total_vazn'] or 0  # Default to 0 if there's no sum
    
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



    return mean_day_per_shift
def get_randeman_per_tolid_operator(asset_randeman_list,operator):
    start_date_gregorian, end_date_gregorian = DateJob.shamsi_to_gregorian_range(asset_randeman_list.sal, asset_randeman_list.mah)

    num_days=(end_date_gregorian-start_date_gregorian).days+1

    sum_production_value=get_monthly_machine_by_date_shift(asset_cat,shift,start_date_gregorian,end_date_gregorian)

    if(not sum_production_value):
        return 0
    # print(start_date_gregorian,end_date_gregorian)
    day_machine_failure_monthly_shift = get_day_machine_failure_monthly_shift(asset_cat,shift,start_date_gregorian,end_date_gregorian)
    total_day_per_shift= num_days - day_machine_failure_monthly_shift
    mean_day_per_shift=sum_production_value/total_day_per_shift



    return mean_day_per_shift
def get_randeman_per_tolid(mah,sal,asset_cat):
    start_date_gregorian, end_date_gregorian = DateJob.shamsi_to_gregorian_range(sal, mah)
    

    sum=0
    shifts=Shift.objects.all()
    for i in shifts:
        sum+=get_randeman_per_tolid_byshift(mah,sal,asset_cat,i)

    
    return sum




def calc_assetrandeman(profile):
    # asset_cat_list=AssetCategory.objects.all()
    # shift_list=Shift.objects.all()
    Operators=Operator.objects.all()
    asset_randeman_list=profile

    OperatorProduction.objects.filter(assetrandeman=asset_randeman_list).delete()
    production_by_operator_machine = defaultdict(lambda: defaultdict(float))
    # Query DailyProduction for the date range
    start_date_gregorian, end_date_gregorian = DateJob.shamsi_to_gregorian_range(asset_randeman_list.sal, asset_randeman_list.mah)
    print(start_date_gregorian, end_date_gregorian)
    daily_productions = DailyProduction.objects.filter(
        dayOfIssue__range=[start_date_gregorian, end_date_gregorian], operators_data__isnull=False
    ).exclude(operators_data__in=["", "None", "null", "none"])
    # Process each DailyProduction record
    for dp in daily_productions:
        try:
            if(dp.operators_data):
                operators_list = json.loads(dp.operators_data) or []

                if not isinstance(operators_list, list):
                    continue
                operator_ids = [op.get('id') for op in operators_list if isinstance(op, dict) and 'id' in op]
                num_operators = len(operator_ids)
                if num_operators == 0:
                    continue
                operator_share = dp.production_value / num_operators
                # Distribute share to each operator for this machine
                for op_id in operator_ids:
                    production_by_operator_machine[op_id][dp.machine_id] += operator_share
                    
                

                # print(operator_ids,"ids")
        except:
             print("error",dp.operators_data)
    # Store results in OperatorProduction
    results = []
    for operator_id, machines in production_by_operator_machine.items():
        try:
            operator = Operator.objects.get(id=int(operator_id))
            for machine_id, total_production in machines.items():
                try:
                    machine = Asset.objects.get(id=machine_id)
                    # Get rate from AssetRandemanInit
                    assetrandeman_init = AssetRandemanInit.objects.filter(
                        production_line=machine.assetIsLocatedAt, profile=profile.profile
                    ).first()
                    rate = 1000#getattr(assetrandeman_init, rate_field, Decimal('0')) if assetrandeman_init else Decimal('0')
                    price = Decimal(total_production) * rate
                    
                    # Create or update OperatorProduction
                    op, created = OperatorProduction.objects.update_or_create(
                        assetrandeman=profile,
                        operator=operator,
                        machine=machine,
                        defaults={'tolid': total_production, 'price': price}
                    )
                    
                    results.append({
                        'operator_id': operator_id,
                        'operator_name': str(operator),
                        'machine_id': machine_id,
                        'machine_name': str(machine),
                        'total_production': round(total_production, 2),
                        'price': price,
                        'operator_production_id': op.id
                    })
                except Asset.DoesNotExist:
                    results.append({
                        'operator_id': operator_id,
                        'operator_name': f'Unknown Operator (ID: {operator_id})',
                        'machine_id': machine_id,
                        'machine_name': f'Unknown Machine (ID: {machine_id})',
                        'total_production': round(total_production, 2),
                        'price': Decimal('0'),
                        'operator_production_id': None
                    })
        except Operator.DoesNotExist:
            # Skip or log if operator not found
            continue
         
    #     num_operators = len(operator_ids)
    #     if num_operators == 0:
    #         continue
    #     operator_share = dp.production_value / num_operators
    #     # Distribute share to each operator for this machine
    #     for op_id in operator_ids:
    #         production_by_operator_machine[op_id][dp.machine_id] += operator_share
    # # Store results in OperatorProduction
    # results = []
    # print(production_by_operator_machine.items())
    # for operator_id, machines in production_by_operator_machine.items():
    #     print(operator_id)
    #     try:
    #         operator = Operator.objects.get(id=int(operator_id))
    #         print(operator)
    #         for machine_id, total_production in machines.items():
    #             try:
    #                 machine = Asset.objects.get(id=machine_id)
    #                 # Get rate from AssetRandemanInit
    #                 assetrandeman_init = AssetRandemanInit.objects.filter(
    #                     production_line=machine, profile=asset_randeman_list.profile
    #                 ).first()
    #                 rate = 1000#getattr(assetrandeman_init, rate_field, Decimal('0')) if assetrandeman_init else Decimal('0')
    #                 price = Decimal(total_production) * rate
    #                 print("!")
                    
    #                 # Create or update OperatorProduction
    #                 op, created = OperatorProduction.objects.update_or_create(
    #                     assetrandeman=asset_randeman_list,
    #                     operator=operator,
    #                     machine=machine,
    #                     defaults={'tolid': total_production, 'price': price}
    #                 )
                    
    #                 # results.append({
    #                 #     'operator_id': operator_id,
    #                 #     'operator_name': str(operator),
    #                 #     'machine_id': machine_id,
    #                 #     'machine_name': str(machine),
    #                 #     'total_production': round(total_production, 2),
    #                 #     'price': price,
    #                 #     'operator_production_id': op.id
    #                 # })
    #             except Asset.DoesNotExist:
    #                  print("asset not exist")
    #                 # results.append({
    #                 #     'operator_id': operator_id,
    #                 #     'operator_name': f'Unknown Operator (ID: {operator_id})',
    #                 #     'machine_id': machine_id,
    #                 #     'machine_name': f'Unknown Machine (ID: {machine_id})',
    #                 #     'total_production': round(total_production, 2),
    #                 #     'price': Decimal('0'),
    #                 #     'operator_production_id': None
    #                 # })
    #     except Operator.DoesNotExist:
    #         # Skip or log if operator not found
    #         print("operaort not exist")
    

    
            
def create_first_padash(AssetRandemanListId):
    asset_randeman=AssetRandemanList.objects.get(id=AssetRandemanListId)
    shifts=Shift.objects.all()
    tolid_rank=get_tolid_rank(asset_randeman.sal,asset_randeman.mah)
    sorted_footballers_by_goals = sorted(tolid_rank, key=tolid_rank.get,reverse=True)

    print(sorted_footballers_by_goals)
    for i in shifts:
        # padash_tolid=TolidPadash.objects.create(profile=asset_randeman.profile,rank=i.id,price_sarshift=0,price_personnel=0)
        # print(tolid_rank.index(i.id),'!!!!!!!!!')
        try:
      
            padash_tolid=TolidPadash.objects.get(rank=sorted_footballers_by_goals.index(i.id)+1,profile=asset_randeman.profile) #tolid_rank.index(i.id)
        except TolidPadash.DoesNotExist:
            #  a=[9500000,7500000,5500000]
            #  b=[95000000,75000000,55000000]
            pass

        #      padash_tolid=TolidPadash.objects.create(rank=i.id+1,profile=asset_randeman.profile,price_sarshift=a[i.id],price_personnel=b[i.id],description=str(i.id))

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
def create_related_tolid_padash(id):
     tolid_padash=TolidPadash.objects.order_by('-id')[:3]
     if(tolid_padash.count()<3):
        profile=FinancialProfile.objects.get(id=id)
        TolidPadash.objects.create(profile=profile,rank=1,price_sarshift=9500000,price_personnel=95000000)
        TolidPadash.objects.create(profile=profile,rank=2,price_sarshift=7500000,price_personnel=75000000)
        TolidPadash.objects.create(profile=profile,rank=3,price_sarshift=5500000,price_personnel=55000000)
        
     else:         

        for i in tolid_padash:
            new_padash=i
            new_padash.pk=None
            new_padash.profile=FinancialProfile.objects.get(id=id)
            new_padash.save()
def create_related_nezafat_padash(id):
     nezafat_padash=NezafatPadash.objects.order_by('-id')[:3]
     if(nezafat_padash.count()<3):
        profile=FinancialProfile.objects.get(id=id)
        NezafatPadash.objects.create(profile=profile,rank=1,price_sarshift=8000000,price_personnel=50000000)
        NezafatPadash.objects.create(profile=profile,rank=2,price_sarshift=6000000,price_personnel=35000000)
        NezafatPadash.objects.create(profile=profile,rank=3,price_sarshift=4000000,price_personnel=20000000)
        
     else:          
        for i in nezafat_padash:
            new_padash=i
            new_padash.pk=None
            new_padash.profile=FinancialProfile.objects.get(id=id)
            new_padash.save()
def create_related_randemanInit_padash(id):
    makan=Asset.objects.filter(assetIsLocatedAt__isnull=True)
    for i in makan:
        asset_category = AssetCategory.objects.filter(assetcategory_main__assetIsLocatedAt=i).order_by('priority').distinct()
        for cat in asset_category:
            r_init=AssetRandemanInit()
            r_init.asset_category=cat
            r_init.profile=FinancialProfile.objects.get(id=id)
            r_init.production_line=i
            r_init.save()


         
         
         
   
def find_who_take_1_padash(my_list):
     obj_with_ranking_1 = [obj for obj in my_list if int(obj.rank) == 1]
    #  print(obj_with_ranking_3)
     return obj_with_ranking_1
def find_who_take_2_padash(my_list):
     obj_with_ranking_2 = [obj for obj in my_list if int(obj.rank) ==2]
     return obj_with_ranking_2

def find_who_take_3_padash(my_list):
    obj_with_ranking_3 = [obj for obj in my_list if int(obj.rank) ==3]
    return obj_with_ranking_3
