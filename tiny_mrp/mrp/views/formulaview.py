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

def list_formula(request):
    makan=request.GET.get("makan",False)
    if(makan):
        print("makan:",makan)
        object_list=Formula.objects.filter(machine__assetIsLocatedAt__id=makan).order_by("machine__assetCategory__priority","machine__tavali")
    else:   

        object_list=Formula.objects.all().order_by("machine__assetisLocatedAt","machine__tavali")    
    # Number of items per page
    objects=PurchaseUtility.doPaging2(request,object_list)
    makan_list=Asset.objects.filter(assetIsLocatedAt__isnull=True)
    if(makan):
        return render(request,"mrp/formula/formulaList.html",{'formulas':objects,'makan_list':makan_list,'makan':int(makan),'title':'لیست فرمولهای تولید'})
    else:

        return render(request,"mrp/formula/formulaList.html",{'formulas':objects,'makan_list':makan_list,'title':'لیست فرمولهای تولید'})

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
    makan = request.GET.get('makan', False)
    if(makan): 
        requests=Formula.objects.filter(machine__assetIsLocatedAt__id=makan).order_by("machine__assetCategory__priority","machine__tavali")
    else:
        # if request.user.is_superuser:
        requests = Formula.objects.all().order_by("machine__assetCategory__priority")
    ws= PurchaseUtility.doPaging2(request,requests)
    data=dict()
    data["status"]="ok"
    data["formula_html"]=render_to_string('mrp/formula/partialFormulaList.html', {
                        
                        'formulas':ws,
                         'perms': PermWrapper(request.user) 

                       

                        
                    },request)
    return JsonResponse(data)
