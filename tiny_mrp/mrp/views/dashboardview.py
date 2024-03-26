from django.shortcuts import render
from mrp.models import *
from django.db.models import Sum, DateField
from django.db.models.functions import Cast
from django.db.models import Q
from django.http import JsonResponse
from mrp.business.tolid_util import * 
from django.utils import timezone
from datetime import timedelta,datetime as dt
from django.db.models import Sum, F, ExpressionWrapper, fields
def get_daily_vazn_sums(start_date, end_date):
    daily_sums = ZayeatVaz.objects.filter(dayOfIssue__range=[start_date, end_date]) \
                                  .annotate(date=Cast('dayOfIssue', DateField())) \
                                  .values('date') \
                                  .annotate(sum_vazn=Sum('vazn')) \
                                  .order_by('date')
    dates = [jdatetime.date.fromgregorian(date=entry['date']).strftime("%Y-%m-%d") for entry in daily_sums]
    sums = [entry['sum_vazn'] for entry in daily_sums]
    return dates, sums
def get_zayeat_pie_aggregate(start_date, end_date):
    data = ZayeatVaz.objects.filter(dayOfIssue__range=[start_date, end_date]).values('zayeat__name').annotate(total=Sum('vazn')).order_by('zayeat')
    labels = [entry['zayeat__name'] for entry in data]
    values = [entry['total'] for entry in data]
    return labels, values
def list_dashboard(request):
    assets=Asset.objects.filter(Q(assetTypes=2)|Q(assetCategory__id=8))
    asset_list=[]
    asset_list.append({'asset_name':'همه','asset_id':-1,'asset_type':0})
    for index,i in enumerate(assets):
        asset_types=get_asset_count(i.assetCategory)
        asset_list.append({'asset_name':i.assetName,'asset_id':i.id,'asset_type':0})
        try:
            if(assets[index].assetCategory !=assets[index+1].assetCategory and asset_types>1):
                asset_list.append({'asset_name':"جمع {} ها".format(i.assetCategory),'asset_id':i.assetCategory.id,'asset_type':1})

        except:
            if(index==len(assets)-1 and asset_types>1):
                asset_list.append({'asset_name':"جمع {} ها".format(i.assetCategory),'asset_id':i.assetCategory.id,'asset_type':1})


    return render(request,'mrp/dashboard/main_dashboard.html',{'title':'داشبورد مدیریتی','assets':asset_list})
def get_line_zayeat_vazn_data(request):
    start_date = request.GET.get('start',dt.now().replace(day=1))  # Modify these dates as needed
    end_date = request.GET.get('end',dt.now())
    dates, sums = get_daily_vazn_sums(start_date, end_date)

    data = {
        'dates': dates,
        'sums': sums,
    }
    return JsonResponse(data)

def get_pie_zayeat_vazn_data(request):
    start_date = request.GET.get('start',dt.now().replace(day=1))  # Modify these dates as needed
    end_date = request.GET.get('end',dt.now())
    start_date=DateJob.getTaskDate(start_date)
    end_date=DateJob.getTaskDate(end_date)
    
    labels, values = get_zayeat_pie_aggregate(start_date,end_date)
    # print(labels,values,'!!!!!!!!!!!!!!!!!')
    return JsonResponse({'labels': labels, 'values': values})

def get_assetFailure__duration_aggregate(start_date,end_date,machine=None,asset_type=None):
    print(machine,asset_type,'!!!!!!!!!!!!!!!!!!!')
    if(asset_type=='0'):
        if(int(machine)>1):
            aggregated_data = AssetFailure.objects.filter(dayOfIssue__range=[start_date, end_date],asset_name=machine).annotate(
                duration_minutes=ExpressionWrapper(
                    F('duration__hour') * 60 + F('duration__minute'),
                    output_field=fields.IntegerField())
                ).values('dayOfIssue').annotate(total_duration=Sum('duration_minutes')).order_by('dayOfIssue')
        else:
            aggregated_data = AssetFailure.objects.filter(dayOfIssue__range=[start_date, end_date]).annotate(
                duration_minutes=ExpressionWrapper(
                    F('duration__hour') * 60 + F('duration__minute'),
                    output_field=fields.IntegerField())
                ).values('dayOfIssue').annotate(total_duration=Sum('duration_minutes')).order_by('dayOfIssue')
    else:
        aggregated_data = AssetFailure.objects.filter(dayOfIssue__range=[start_date, end_date],asset_name__assetCategory=asset_type).annotate(
                duration_minutes=ExpressionWrapper(
                    F('duration__hour') * 60 + F('duration__minute'),
                    output_field=fields.IntegerField())
                ).values('dayOfIssue').annotate(total_duration=Sum('duration_minutes')).order_by('dayOfIssue')
    dates = [jdatetime.date.fromgregorian(date=item['dayOfIssue']).strftime("%Y-%m-%d") for item in aggregated_data]
    total_durations = [item['total_duration'] for item in aggregated_data]
    return dates, total_durations
def assetFailure_duration_data(request):
    start_date = request.GET.get('start',dt.now().replace(day=1))  # Modify these dates as needed
    end_date = request.GET.get('end',dt.now())
    start_date=DateJob.getTaskDate(start_date)
    end_date=DateJob.getTaskDate(end_date)
    machine = request.GET.get('machine',False)
    asset_type = request.GET.get('asset_type',False)
    dates, total_durations = get_assetFailure__duration_aggregate(start_date,end_date,machine,asset_type)
    return JsonResponse({'dates': dates, 'total_durations': total_durations})

def get_failure_pie_aggregate(start_date,end_date,machine=None,asset_type=None):
    if(asset_type=='0'):
        if(int(machine)>1):
            aggregated_data = AssetFailure.objects.filter(dayOfIssue__range=[start_date, end_date],asset_name=machine).annotate(
                duration_minutes=ExpressionWrapper(
                    F('duration__hour') * 60 + F('duration__minute'),
                    output_field=fields.IntegerField())
                ).values('failure_name__name').annotate(total_duration=Sum('duration_minutes')).order_by('failure_name')
        else:

            aggregated_data = AssetFailure.objects.filter(dayOfIssue__range=[start_date, end_date]).annotate(
                duration_minutes=ExpressionWrapper(
                    F('duration__hour') * 60 + F('duration__minute'),
                    output_field=fields.IntegerField())
                ).values('failure_name__name').annotate(total_duration=Sum('duration_minutes')).order_by('failure_name')
    else:
        aggregated_data = AssetFailure.objects.filter(dayOfIssue__range=[start_date, end_date],asset_name__asset_category=asset_type).annotate(
                duration_minutes=ExpressionWrapper(
                    F('duration__hour') * 60 + F('duration__minute'),
                    output_field=fields.IntegerField())
                ).values('failure_name__name').annotate(total_duration=Sum('duration_minutes')).order_by('failure_name')
  

    labels = [item['failure_name__name'] for item in aggregated_data]
    total_durations = [item['total_duration'] for item in aggregated_data]

    return labels, total_durations
def failure_pie_data(request):
    start_date = request.GET.get('start',dt.now().replace(day=1))  # Modify these dates as needed
    end_date = request.GET.get('end',dt.now())
    start_date=DateJob.getTaskDate(start_date)
    end_date=DateJob.getTaskDate(end_date)
    machine = request.GET.get('machine',False)
    asset_type = request.GET.get('asset_type',False)
    labels, total_durations  = get_failure_pie_aggregate(start_date,end_date,machine,asset_type)
    return JsonResponse({'labels': labels, 'total_durations': total_durations})
def get_current_year_zayeatvazn_sum():
    # Get the current Jalali year
    # current_jalali_year = jdatetime.date.today().year

    # # Create a dictionary to hold sums for each Jalali month in the current year
    # current_year = datetime.now().year
    # monthly_sums = ZayeatVaz.objects.filter(dayOfIssue__year=current_year) \
    #                                  .values('dayOfIssue__month') \
    #                                  .annotate(total_vazn=Sum('vazn')) \
    #                                  .order_by('dayOfIssue__month')

    # labels = [f'{month["dayOfIssue__month"]:02d}' for month in monthly_sums]
    # sums = [month['total_vazn'] for month in monthly_sums]

    # return labels, sums
    current_jalali_year = jdatetime.date.today().year

    # Create a dictionary to hold sums for each Jalali month in the current year
    monthly_sums = {}

    # Query all ZayeatVazn objects
    for zv in ZayeatVaz.objects.all():
        # Convert dayOfIssue to Jalali date
        jalali_date = jdatetime.date.fromgregorian(date=zv.dayOfIssue)

        # Check if the year matches the current Jalali year
        if jalali_date.year == current_jalali_year:
            jalali_month = f'{jalali_date.year}-{jalali_date.month:02d}'  # Format as 'Year-Month'

            # Aggregate sums by month
            monthly_sums[jalali_month] = monthly_sums.get(jalali_month, 0) + zv.vazn

    # Sort and split the dictionary into two lists for labels and values
    sorted_months = sorted(monthly_sums)
    labels = [month for month in sorted_months]
    sums = [monthly_sums[month] for month in sorted_months]

    return labels, sums

def current_year_vazn_data(request):

    labels, sums = get_current_year_zayeatvazn_sum()
    return JsonResponse({'labels': labels, 'sums': sums})
def get_monthly_vazn_sum_by_zayeat():
    current_jalali_year = jdatetime.date.today().year

    # Prepare data for each Zayeat
    series = []
    zayeats = Zayeat.objects.all()

    # Get unique Jalali months in the current year
    jalali_months = set()
    for record in ZayeatVaz.objects.all():
        jalali_date = jdatetime.date.fromgregorian(date=record.dayOfIssue)
        if jalali_date.year == current_jalali_year:
            jalali_months.add(jalali_date.strftime('%Y-%m'))

    sorted_jalali_months = sorted(jalali_months)

    for zayeat in zayeats:
        monthly_data = []
        for month in sorted_jalali_months:
            year, month_num = map(int, month.split('-'))
            jalali_start = jdatetime.date(year, month_num, 1)
            gregorian_start = jalali_start.togregorian()

            # Find the last day of the Jalali month
            if month_num < 12:
                jalali_end = jdatetime.date(year, month_num + 1, 1)
            else:
                jalali_end = jdatetime.date(year + 1, 1, 1)
            gregorian_end = jalali_end.togregorian()

            # Adjust the end date to cover the entire last day
            gregorian_end = gregorian_end - timedelta(days=1)

            sum_vazn = ZayeatVaz.objects.filter(
                zayeat=zayeat,
                dayOfIssue__range=(gregorian_start, gregorian_end)
            ).aggregate(Sum('vazn'))['vazn__sum'] or 0

            monthly_data.append(sum_vazn)

        series.append({
            'name': zayeat.name,
            'data': monthly_data
        })

    return series, sorted_jalali_months

def monthly_vazn_by_zayeat_data(request):
        series, categories = get_monthly_vazn_sum_by_zayeat()
        return JsonResponse({'series': series, 'xaxis': {'categories': categories}})
########################
def get_jalali_monthly_duration_sum():
    # Determine the current Jalali year
    # current_jalali_year = jdatetime.date.today().year-1

    # Create a dictionary to hold sums for each Jalali month
    monthly_sums = {}


    
    current_date = timezone.now()
    one_year_ago = current_date - timedelta(days=365)
    records_last_12_months = AssetFailure.objects.filter(
    dayOfIssue__gte=one_year_ago,
    dayOfIssue__lte=current_date
    )
    for record in records_last_12_months:
        jalali_date = jdatetime.date.fromgregorian(date=record.dayOfIssue)
        jalali_month = jalali_date.strftime("%Y-%m")  # Format as 'Year-Month'
        duration_minutes = record.duration.hour * 60 + record.duration.minute    
        monthly_sums[jalali_month] = monthly_sums.get(jalali_month, 0) + duration_minutes


    # Sort and split the dictionary into two lists for labels and values
    sorted_months = sorted(monthly_sums)
    labels = [month for month in sorted_months]
    sums = [f"{monthly_sums[month]/60:0.0f}" for month in sorted_months]

    return labels, sums
def get_jalali_monthly_production_sum(machine,asset_type):
    # Determine the current Jalali year
    # current_jalali_year = jdatetime.date.today().year-1

    # Create a dictionary to hold sums for each Jalali month
    monthly_sums = {}


    
    current_date = timezone.now()
    one_year_ago = current_date - timedelta(days=365)
    if(asset_type=="0"):
        if(int(machine)>1):
            records_last_12_months = DailyProduction.objects.filter(
                dayOfIssue__gte=one_year_ago,
                dayOfIssue__lte=current_date,machine=machine
                )
        else:

            records_last_12_months = DailyProduction.objects.filter(
            dayOfIssue__gte=one_year_ago,
            dayOfIssue__lte=current_date
            )
    else:
        records_last_12_months = DailyProduction.objects.filter(
        dayOfIssue__gte=one_year_ago,
        dayOfIssue__lte=current_date,machine__asset_category=asset_type
        )
    for record in records_last_12_months:
        jalali_date = jdatetime.date.fromgregorian(date=record.dayOfIssue)
        jalali_month = jalali_date.strftime("%Y-%m")  # Format as 'Year-Month'
        # duration_minutes = record.duration.hour * 60 + record.duration.minute 
        production_val=record.production_value   
        monthly_sums[jalali_month] = monthly_sums.get(jalali_month, 0) + production_val


    # Sort and split the dictionary into two lists for labels and values
    sorted_months = sorted(monthly_sums)
    labels = [month for month in sorted_months]
    sums = [f"{monthly_sums[month]:0.0f}" for month in sorted_months]

    return labels, sums
def jalali_monthly_duration_data(request):
    labels, sums = get_jalali_monthly_duration_sum()
    return JsonResponse({'labels': labels, 'sums': sums})
def jalali_monthly_production_data(request):
    machine = request.GET.get('machine',False)
    asset_type = request.GET.get('asset_type',False)
    labels, sums = get_jalali_monthly_production_sum(machine,asset_type)
    return JsonResponse({'labels': labels, 'sums': sums})
##############################
def get_jalali_monthly_duration_sum_by_failure():
    # Determine the current Jalali year
    # current_jalali_year = jdatetime.date.today().year-1

    # Prepare data for each failure
    series = []
    failures = Failure.objects.all()

    # Find unique Jalali months in the current year
    jalali_months = set()
    current_date = timezone.now()
    one_year_ago = current_date - timedelta(days=365)
    records_last_12_months = AssetFailure.objects.filter(
    dayOfIssue__gte=one_year_ago,
    dayOfIssue__lte=current_date
    )
    for record in records_last_12_months:
        jalali_date = jdatetime.date.fromgregorian(date=record.dayOfIssue)
        # jalali_month = jalali_date.strftime("%Y-%m")  # Format as 'Year-Month'
        jalali_months.add(jalali_date.strftime('%Y-%m'))



    sorted_jalali_months = sorted(jalali_months)

    for failure in failures:
        monthly_data = []
        for month in sorted_jalali_months:
            year, month_num = map(int, month.split('-'))
            jalali_start = jdatetime.date(year, month_num, 1)
            gregorian_start = jalali_start.togregorian()

            # Find the last day of the Jalali month
            if month_num < 12:
                jalali_end = jdatetime.date(year, month_num + 1, 1)
            else:
                jalali_end = jdatetime.date(year + 1, 1, 1)
            gregorian_end = jalali_end.togregorian()

            # Adjust the end date to cover the entire last day
            gregorian_end = gregorian_end - timedelta(days=1)

            sum_duration = AssetFailure.objects.filter(
                failure_name=failure,
                dayOfIssue__range=(gregorian_start, gregorian_end)
            ).annotate(
                duration_minutes=ExpressionWrapper(
                    F('duration__hour') * 60 + F('duration__minute'),
                    output_field=fields.IntegerField())
            ).aggregate(Sum('duration_minutes'))['duration_minutes__sum'] or 0

            monthly_data.append(sum_duration)

        series.append({
            'name': failure.name,
            'data': monthly_data
        })

    return series, sorted_jalali_months
def jalali_monthly_duration_by_failure_data(request):
    series, labels = get_jalali_monthly_duration_sum_by_failure()
    return JsonResponse({'series': series, 'xaxis': {'categories': labels}})
def get_daily_tolid_sums(start_date, end_date,machine=None):
    
    if(int(machine)>1):
        daily_sums = DailyProduction.objects.filter(dayOfIssue__range=[start_date, end_date],machine=machine) \
                                    .annotate(date=Cast('dayOfIssue', DateField())) \
                                    .values('date') \
                                    .annotate(sum_vazn=Sum('production_value')) \
                                    .order_by('date')
    else:
        daily_sums = DailyProduction.objects.filter(dayOfIssue__range=[start_date, end_date]) \
                                    .annotate(date=Cast('dayOfIssue', DateField())) \
                                    .values('date') \
                                    .annotate(sum_vazn=Sum('production_value')) \
                                    .order_by('date')
    dates = [jdatetime.date.fromgregorian(date=entry['date']).strftime("%Y-%m-%d") for entry in daily_sums]
    sums = [int(entry['sum_vazn']) for entry in daily_sums]
    return dates, sums
def get_daily_tolid_sums_by_cat(start_date, end_date,category):
    
    
    daily_sums = DailyProduction.objects.filter(dayOfIssue__range=[start_date, end_date],machine__assetCategory=category) \
                                    .annotate(date=Cast('dayOfIssue', DateField())) \
                                    .values('date') \
                                    .annotate(sum_vazn=Sum('production_value')) \
                                    .order_by('date')
    
    dates = [jdatetime.date.fromgregorian(date=entry['date']).strftime("%Y-%m-%d") for entry in daily_sums]
    sums = [int(entry['sum_vazn']) for entry in daily_sums]
    return dates, sums
def get_line_tolid_vazn_data(request):
    start_date = request.GET.get('start',dt.now().replace(day=1))  # Modify these dates as needed
    end_date = request.GET.get('end',dt.now())
    machine = request.GET.get('machine',False)
    asset_type = request.GET.get('asset_type',False)
    start_date=DateJob.getTaskDate(start_date)
    end_date=DateJob.getTaskDate(end_date)
    if(asset_type=='0'):
    
        dates, sums = get_daily_tolid_sums(start_date, end_date,machine)
    else:
        dates, sums = get_daily_tolid_sums_by_cat(start_date, end_date,asset_type)


    data = {
        'dates': dates,
        'sums': sums,
    }
    # print(data,'!!!!!!!!!!!!!!!!!!!!')
    return JsonResponse(data)
def production_chart(request):
    # Assume 'date' is passed as 'YYYY-MM-DD' format from the front end
    date_str=DailyProduction.objects.order_by('-dayOfIssue').first().dayOfIssue

    # date = datetime.datetime.strptime(date_str, '%Y-%m-%d').date()
    
    # Query to get sum of production_value for each machine for the given date
    production_data = DailyProduction.objects.filter(dayOfIssue=date_str)\
                      .values('machine__assetName')\
                      .annotate(total_production=Sum('production_value'))\
                      .order_by('machine')
    kambood=[]
    for i in production_data:
        tolid_standard=ProductionStandard.objects.get(machine_name__assetName=i['machine__assetName'])
        kambood.append(int(i['total_production']-tolid_standard.good_production_rate))

    
    data = {
        'machines': [item['machine__assetName'] for item in production_data],
        'production_values': [int(item['total_production']) for item in production_data],
        'date':str(jdatetime.date.fromgregorian(date=date_str)),
        'production_kambood':kambood
    }
    
    return JsonResponse(data)