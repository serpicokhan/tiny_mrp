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
