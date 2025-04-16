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
from mrp.business.tolid_util import *
import datetime
from django.shortcuts import get_object_or_404
from django.core.exceptions import ValidationError
from mrp.forms import WorkCenterForm
from mrp.models import WorkCenter
from rest_framework import generics
from mrp.serializers import WorkCenterSerializer



def workcenter_list(request):
    return render(request,"mrp/workcenter/wcList.html",{})
def save_workcenter_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_workcenter_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
def create_workcenter(request):
    if (request.method == 'POST'):
        form = WorkCenterForm(request.POST)
        return save_workcenter_form(request, form, 'mrp/workcenter/partialWcCreate.html')
  
    else:
        
        form = WorkCenterForm()
        return save_workcenter_form(request, form, 'mrp/workcenter/partialWcCreate.html')
class WorkcenterListView(generics.ListAPIView):
    serializer_class = WorkCenterSerializer
    
    def get_queryset(self):
        return WorkCenter.objects.all()