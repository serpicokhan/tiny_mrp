from mrp.models import *
from django.db.models import Sum

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
