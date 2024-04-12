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
from django.views.decorators.http import require_http_methods


from mrp.forms import AssetRandemanInitForm,TolidPadashForm,NezafatPadashForm
def get_init_asset_randeman(request):
    profile_list=FinancialProfile.objects.all().order_by('-id')
    last_profile=FinancialProfile.objects.order_by('-id').first()
    profile=request.GET.get('profile',last_profile.id)
    mablagh_kol=FinancialProfile.objects.get(id=profile).mablagh_kol_randeman
    mazrzab_3=FinancialProfile.objects.get(id=profile).tolid_randeman_mazrab_3


    all_asset_randeman_init=AssetRandemanInit.objects.filter(profile__id=profile).order_by('asset_category__priority')
    return render(request,'mrp/assetrandeman/assetrandemaninit/initRandemanList.html',{'formulas':all_asset_randeman_init,'selected_profile':int(profile),'profile_list':profile_list,'mablagh':mablagh_kol,'mazrab_3':mazrzab_3})

def list_tolid_padash(request):
    profile_list=FinancialProfile.objects.all().order_by('-id')
    last_profile=FinancialProfile.objects.order_by('-id').first()
    profile=request.GET.get('profile',last_profile.id)

    formulas=TolidPadash.objects.filter(profile__id=profile)
    return render(request,"mrp/assetrandeman/tolidpadash/tolidPadashList.html",{'formulas':formulas,'title':'پاداش تولید','selected_profile':int(profile),'profile_list':profile_list})
def list_nezafat_padash(request):
    profile_list=FinancialProfile.objects.all().order_by('-id')
    last_profile=FinancialProfile.objects.order_by('-id').first()
    profile=request.GET.get('profile',last_profile.id)

    formulas=NezafatPadash.objects.filter(profile__id=profile)
    return render(request,"mrp/assetrandeman/nezafatpadash/nezafatPadashList.html",{'formulas':formulas,'title':'پاداش نظافت','selected_profile':int(profile),'profile_list':profile_list})


def save_assetrandemaninit_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            books = AssetRandemanInit.objects.filter(profile=bts.profile).order_by('asset_category__priority')
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
def save_tolidPadash_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            books = TolidPadash.objects.filter(profile=bts.profile)
            data['html_failure_list'] = render_to_string('mrp/assetrandeman/tolidpadash/partialTolidPadashList.html', {
                'formulas': books,
                'perms': PermWrapper(request.user)
            })
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_failure_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)

def save_nezafatPadash_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            books = NezafatPadash.objects.filter(profile=bts.profile)
            data['html_failure_list'] = render_to_string('mrp/assetrandeman/nezafatpadash/partialNezafatPadashList.html', {
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


@csrf_exempt  # Use this decorator to exempt the view from CSRF verification
@require_http_methods(["POST"])  # This view only accepts POST requests
def assetrandemaninit_partial_update(request,id):
    try:
        # Parse the JSON data from request body
            data = json.loads(request.body)

            # Access data attributes
            row_id = data['id']
            row_data = data['data']


            # Here you can process the data, e.g., update the database
            # For example, assuming you have a model `Randeman`:
            # Randeman.objects.filter(id=row_id).update(**row_data)
            obj=AssetRandemanInit.objects.get(id=row_id)
            obj.operator_count=row_data['operator_count']
            obj.mablaghe_kole_randeman=row_data['mablaghe_kole_randeman']
            obj.max_randeman=row_data['max_randeman']
            obj.randeman_mazrab_3=row_data['randeman_mazrab_3']
            obj.randeman_tolid=row_data['randeman_tolid']
            obj.randeman_yek_dastgah=row_data['randeman_yek_dastgah']
            obj.save()

            return JsonResponse({'status': 'success', 'message': 'Data updated successfully!'})

    except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)}, status=400)



def tolidPadash_update(request, id):
    company= get_object_or_404(TolidPadash, id=id)
    template=""
    if (request.method == 'POST'):
        form = TolidPadashForm(request.POST, instance=company)
    else:
        form = TolidPadashForm(instance=company)


    return save_tolidPadash_form(request, form,"mrp/assetrandeman/tolidpadash/partialTolidPadashUpdate.html")

def nezafatPadash_update(request, id):
    company= get_object_or_404(NezafatPadash, id=id)
    template=""
    if (request.method == 'POST'):
        form = NezafatPadashForm(request.POST, instance=company)
    else:
        form = NezafatPadashForm(instance=company)


    return save_nezafatPadash_form(request, form,"mrp/assetrandeman/nezafatpadash/partialnezafatPadashUpdate.html")