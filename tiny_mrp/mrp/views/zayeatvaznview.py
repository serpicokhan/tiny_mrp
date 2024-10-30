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
from django.template.loader import render_to_string
from django.views.decorators import csrf

from collections import defaultdict

@login_required
@csrf_exempt
def zayeatVazn_create(request):

    if (request.method == 'POST'):
        try:
            # Assuming the data is sent as JSON
            received_data = json.loads(request.body)  # If data was sent as form-encoded, use request.POST
            # Process the received_data (In this case, it's assumed to be a list of dictionaries)
            print(received_data)
            for table in received_data:


                    for row in table:
                        
                        ff=ZayeatVaz.objects.filter(zayeat=Zayeat.objects.get(id=row['id']),shift=Shift.objects.get(id=row['shift']),dayOfIssue=row['date'])
                        if(ff.count()>0):
                            z=ff[0]
                            z.vazn=float(row['vazn'])
                            z.zayeat=Zayeat.objects.get(id=row['id'])
                            z.dayOfIssue=row['date']
                            z.shift=Shift.objects.get(id=row['shift'])
                            z.save()

                        else:
                            z=ZayeatVaz()
                            z.vazn=float(row['vazn'])
                            z.zayeat=Zayeat.objects.get(id=row['id'])
                            z.dayOfIssue=row['date']
                            z.shift=Shift.objects.get(id=row['shift'])
                            z.save()

            # For demonstration purposes, just returning the received data as JSON response
            return JsonResponse({'success': True, 'data_received': received_data})
        except Exception as e:
            print(e)
            return JsonResponse({'success': False, 'error': str(e)})
    else:
        data=dict()
        date_of_issue=None

        current_date=request.GET.get("data",False)
        if(current_date):
            date_of_issue=DateJob.getTaskDate(current_date)
        else:
            date_of_issue=datetime.now().date()
        za=Zayeat.objects.all()
        date_zayeat=ZayeatVaz.objects.filter(dayOfIssue=date_of_issue)
        shift=Shift.objects.all()
        zayeat_vazn_dict = defaultdict(list)
        for zv in date_zayeat:
            zayeat_vazn_dict[zv.zayeat.id].append({'vazn':zv.vazn,'shift':zv.shift.id})
        data['data']=render_to_string('mrp/zayeat_vazn/partialZayeatVaznCreate.html',
            {   'shifts':shift,
                'zayeat':za,
                'zayeat_vazn':zayeat_vazn_dict,
                'date':date_of_issue.strftime('%Y-%m-%d')
            },request
        )
        return JsonResponse(data)
def get_daily_zaye(request):
    dayOfIssue=request.GET.get('event_id',datetime.now())
    date_object = datetime.strptime(dayOfIssue, '%Y-%m-%d')
    za=Zayeat.objects.all()
    date_zayeat=ZayeatVaz.objects.filter(dayOfIssue=date_object)
    shift=Shift.objects.all()
    zayeat_vazn_dict = defaultdict(list)
    for zv in date_zayeat:
        zayeat_vazn_dict[zv.zayeat.id].append({'vazn':round(zv.vazn, 2),'shift':zv.shift.id})
    return render(request,'mrp/zayeat_vazn/zayeatVaznList.html',
        {   'shifts':shift,
            'zayeat':za,
            'zayeat_vazn':zayeat_vazn_dict,
            'date':date_object,'jalali':jdatetime.date.fromgregorian(date=date_object).strftime('%d-%m-%Y')
        }
    )
