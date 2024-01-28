from django.shortcuts import render
from mrp.models import *
from django.db.models import Sum, DateField
from django.db.models.functions import Cast
from django.db.models import Q
from django.http import JsonResponse

from datetime import timedelta,datetime as dt
from django.db.models import Sum, F, ExpressionWrapper, fields
def get_daily_vazn_sums(start_date, end_date):
    daily_sums = ZayeatVaz.objects.filter(dayOfIssue__range=[start_date, end_date]) \
                                  .annotate(date=Cast('dayOfIssue', DateField())) \
                                  .values('date') \
                                  .annotate(sum_vazn=Sum('vazn')) \
                                  .order_by('date')
    dates = [entry['date'].strftime("%Y-%m-%d") for entry in daily_sums]
    sums = [entry['sum_vazn'] for entry in daily_sums]
    return dates, sums
def get_zayeat_pie_aggregate(start_date, end_date):
    data = ZayeatVaz.objects.filter(dayOfIssue__range=[start_date, end_date]).values('zayeat__name').annotate(total=Sum('vazn')).order_by('zayeat')
    labels = [entry['zayeat__name'] for entry in data]
    values = [entry['total'] for entry in data]
    return labels, values
def list_dashboard(request):
    return render(request,'mrp/dashboard/main_dashboard.html',{'title':'داشبورد مدیریتی'})
def get_line_zayeat_vazn_data(request):
    start_date = request.GET.get('start',dt.now().replace(day=1))  # Modify these dates as needed
    end_date = request.GET.get('end',dt.now())
    print(start_date,end_date)
    dates, sums = get_daily_vazn_sums(start_date, end_date)

    data = {
        'dates': dates,
        'sums': sums,
    }
    return JsonResponse(data)

def get_pie_zayeat_vazn_data(request):
    start_date = request.GET.get('start',dt.now().replace(day=1))  # Modify these dates as needed
    end_date = request.GET.get('end',dt.now())
    labels, values = get_zayeat_pie_aggregate(start_date,end_date)
    print(labels,values)
    return JsonResponse({'labels': labels, 'values': values})

def get_assetFailure__duration_aggregate(start_date,end_date):
    aggregated_data = AssetFailure.objects.filter(dayOfIssue__range=[start_date, end_date]).annotate(
        duration_minutes=ExpressionWrapper(
            F('duration__hour') * 60 + F('duration__minute'),
            output_field=fields.IntegerField())
        ).values('dayOfIssue').annotate(total_duration=Sum('duration_minutes')).order_by('dayOfIssue')
    dates = [item['dayOfIssue'].strftime("%Y-%m-%d") for item in aggregated_data]
    total_durations = [item['total_duration'] for item in aggregated_data]
    return dates, total_durations
def assetFailure_duration_data(request):
    start_date = request.GET.get('start',dt.now().replace(day=1))  # Modify these dates as needed
    end_date = request.GET.get('end',dt.now())
    dates, total_durations = get_assetFailure__duration_aggregate(start_date,end_date)
    return JsonResponse({'dates': dates, 'total_durations': total_durations})

def get_failure_pie_aggregate(start_date,end_date):
    aggregated_data = AssetFailure.objects.filter(dayOfIssue__range=[start_date, end_date]).annotate(
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
    labels, total_durations  = get_failure_pie_aggregate(start_date,end_date)
    print(labels, total_durations)
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
