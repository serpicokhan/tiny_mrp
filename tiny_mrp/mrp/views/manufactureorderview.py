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
from mrp.models import ManufacturingOrder
from mrp.forms import ManufacturingOrderForm

def manufacture_order_list(request):
    return render(request,"mrp/manufactureorder/mOrderList.html",{})
def manufacture_order_detail(request):
    return render(request,"mrp/manufactureorder/dgrok2.html",{})

def save_morder_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_morder_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)

def create_morder(request):
    if (request.method == 'POST'):
        form = ManufacturingOrderForm(request.POST)
        return save_morder_form(request, form, 'mrp/manufactureorder/partialMOrderCreate.html')
  
    else:
        print("!!!!!!!!!!!")
        form = ManufacturingOrderForm()
        return save_morder_form(request, form, 'mrp/manufactureorder/partialMOrderCreate.html')