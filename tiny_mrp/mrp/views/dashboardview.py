from django.shortcuts import render
from mrp.models import *
from django.db.models import Sum, DateField
from django.db.models.functions import Cast
from django.db.models import Q
from django.http import JsonResponse

from datetime import datetime as dt
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
    return render(request,'mrp/dashboard/main_dashboard.html',{'title':'داشبور مدیریتی'})
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
