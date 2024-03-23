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
from mrp.business.tolid_util import *
from django.template.loader import render_to_string
from django.shortcuts import get_object_or_404


from mrp.forms import AssetRandemanInitForm

def save_assetrandemaninit_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            books = AssetRandemanInit.objects.all()
            data['html_failure_list'] = render_to_string('mrp/assetrandeman/assetrandemaninit/partialInitRandemanList.html', {
                'formulas': books,
                'perms': PermWrapper(request.user)
            })
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_failure_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)

def assetrandemaninit_update(request, id):
    company= get_object_or_404(AssetRandemanInit, id=id)
    template=""
    if (request.method == 'POST'):
        form = AssetRandemanInitForm(request.POST, instance=company)
    else:
        form = AssetRandemanInitForm(instance=company)


    return save_assetrandemaninit_form(request, form,"mrp/assetrandeman/assetrandemaninit/partialAssetRandemanInitUpdate.html")