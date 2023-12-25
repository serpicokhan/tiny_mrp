from django.shortcuts import render
from mrp.models import *
from mrp.forms import AssetFailureForm
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

@login_required
def asset_failure_list(request):
    return render(request,"mrp/assetfailure/details.html",{})
##########################################################
def save_assetFailure_form(request, form, template_name,id=None):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            form.save()
            data['form_is_valid'] = True
            books = AssetFailure.objects.all()
            data['html_maintenanceType_list'] = render_to_string('mrp/assetfailure/partialAssetFailureeList.html', {
                'maintenanceType': books,
                'perms': PermWrapper(request.user)
            })
        else:
            data['form_is_valid'] = False

    context = {'form': form}


    data['html_assetFailure_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
##########################################################
def assetFailure_create(request):
    if (request.method == 'POST'):
        form = AssetFailureForm(request.POST)
        return save_assetFailure_form(request, form, 'mrp/assetfailure/partialAssetFailureCreate.html')
    else:

        form = AssetFailureForm()
        return save_assetFailure_form(request, form, 'mrp/assetfailure/partialAssetFailureCreate.html')




##########################################################