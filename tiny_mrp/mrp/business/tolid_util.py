from mrp.models import *
from django.db.models import Sum
from datetime import timedelta
from django.core.paginator import *
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
def get_monthly_machine_by_date_shift(assetCatregory,shift,start,end):
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

        # Retrieve durations of the filtered failures and calculate the sum
        # total_failure_duration = filtered_failures.aggregate(total_duration=Sum('duration'))['total_duration']
        total_failure_duration = sum(
            failure.duration.hour * 60 + failure.duration.minute for failure in filtered_failures
        )
        if total_failure_duration:
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

        # Retrieve durations of the filtered failures and calculate the sum
        # total_failure_duration = filtered_failures.aggregate(total_duration=Sum('duration'))['total_duration']
        total_failure_duration = sum(
            failure.duration.hour * 60 + failure.duration.minute for failure in filtered_failures
        )
        if total_failure_duration:
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

        # Retrieve durations of the filtered failures and calculate the sum
        # total_failure_duration = filtered_failures.aggregate(total_duration=Sum('duration'))['total_duration']
        total_failure_duration = sum(
            failure.duration.hour * 60 + failure.duration.minute for failure in filtered_failures
        )
        if total_failure_duration:
            hours = total_failure_duration // 60
            minutes = total_failure_duration % 60
            formatted_duration = f"{hours:02d}:{minutes:02d}"
            return hours/8
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
            sum+=i.production_value/i.eval_max_tolid()
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
