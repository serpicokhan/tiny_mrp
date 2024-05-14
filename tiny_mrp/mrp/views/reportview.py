from django.shortcuts import render
from mrp.models import *
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
from django.db.models import Sum, F, ExpressionWrapper, fields
from datetime import timedelta,datetime as dt


@login_required
def daily_tolid_with_chart(request):
    
    return render(request,'mrp/report/daily_tolid.html',{})
def production_chart_with_table(request):
    date_str = request.GET.get('date',False) # Modify these dates as needed

    if(not date_str):
        # Assume 'date' is passed as 'YYYY-MM-DD' format from the front end
        date_str=DailyProduction.objects.order_by('-dayOfIssue').first().dayOfIssue
    else:
        date_str=DateJob.getTaskDate(date_str)

    production_data={}
    data=[]

    # date = datetime.datetime.strptime(date_str, '%Y-%m-%d').date()
    
    # Query to get sum of production_value for each machine for the given date
    shifts=Shift.objects.all()
    for i in shifts:
        production_data1 = DailyProduction.objects.filter(dayOfIssue=date_str,shift=i)\
                        .values('machine__assetName')\
                        .annotate(total_production=Sum('production_value'))\
                        .order_by('machine')
        production_data2 = DailyProduction.objects.filter(dayOfIssue=date_str,shift=i)\
                        .values('machine__assetCategory__name')\
                        .annotate(total_production=Sum('production_value'))\
                        
        data.append(
            {
        'asset_category':[item['machine__assetCategory__name'] for item in production_data2],
        'production_values2': [int(item['total_production']) for item in production_data2],

        'machines': [item['machine__assetName'] for item in production_data1],
        'production_values': [int(item['total_production']) for item in production_data1],
        'date':str(jdatetime.date.fromgregorian(date=date_str).strftime("%d-%m-%Y")),
        'lable':f'شیفت {i.name}'
        
             }
        )
   
    
    # data = {
    #     'machines': [item['machine__assetName'] for item in production_data],
    #     'production_values': [int(item['total_production']) for item in production_data],
    #     'date':str(jdatetime.date.fromgregorian(date=date_str)),
        
    # }
    
    return JsonResponse(data,safe=False)