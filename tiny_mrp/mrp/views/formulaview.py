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
from django.shortcuts import get_object_or_404
from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
from mrp.business.purchaseutility import *


from mrp.forms import FormulaForm

def save_formula_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
           
            data['html_formula_list'] = render_to_string('mrp/formula/partialFormulaList.html', {
                
                'perms': PermWrapper(request.user)
            })
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_formula_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)

def formula_update(request, id):
    company= get_object_or_404(Formula, id=id)
    template=""
    if (request.method == 'POST'):
        form = FormulaForm(request.POST, instance=company)
    else:
        form = FormulaForm(instance=company)


    return save_formula_form(request, form,"mrp/formula/partialFormulaUpdate.html")


def referesh_formula_list(request):
    # if request.user.is_superuser:
    requests = Formula.objects.all()
    ws= PurchaseUtility.doPaging(request,requests)
    data=dict()
    data["status"]="ok"
    data["formula_html"]=render_to_string('mrp/formula/partialFormulaList.html', {
                        
                        'formulas':ws,
                         'perms': PermWrapper(request.user) 

                       

                        
                    },request)
    return JsonResponse(data)
