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
def zayeatVazn_create(request):
    print("it 's comming'")

    if (request.method == 'POST'):
        pass
    else:
        data=dict()
        date_of_issue=None

        current_date=request.GET.get("data",False)
        if(current_date):
            date_of_issue=DateJob.getTaskDate(current_date)
        else:
            date_of_issue=datetime.now().date()
        za=Zayeat.objects.all()
        data['data']=render_to_string('mrp/zayeat_vazn/partialZayeatVaznCreate.html',request,
            {
                'zayeat':za,
                'date':date_of_issue.strftime('%Y-%m-%d')
            }
        )
        return JsonResponse(data)
