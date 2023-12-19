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



@login_required
@csrf_exempt
def zayeatVazn_create(request):

    if (request.method == 'POST'):
        try:
            # Assuming the data is sent as JSON
            received_data = json.loads(request.body)  # If data was sent as form-encoded, use request.POST
            # Process the received_data (In this case, it's assumed to be a list of dictionaries)
           
            for i in received_data:
                z=ZayeatVaz()
                z.vazn=float(i['vazn'])
                z.zayeat=Zayeat.objects.get(id=i['id'])
                z.dayOfIssue=i['date']
                z.save()
            
            # For demonstration purposes, just returning the received data as JSON response
            return JsonResponse({'success': True, 'data_received': received_data})
        except Exception as e:
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
        shift=Shift.objects.all()
        data['data']=render_to_string('mrp/zayeat_vazn/partialZayeatVaznCreate.html',
            {   'shifts':shift,
                'zayeat':za,
                'date':date_of_issue.strftime('%Y-%m-%d')
            },request
        )
        return JsonResponse(data)
