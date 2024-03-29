from django.shortcuts import render, get_object_or_404
from django.http import JsonResponse
from django.template.loader import render_to_string

from mrp.models import FinancialProfile
from mrp.forms import FinancialProfileForm
from mrp.business.tolid_util import *


def profile_list(request):
    profile = FinancialProfile.objects.all()
    return render(request, 'mrp/financial_profile/profile_list.html', {'profiles': profile,'title':'پروفال مالی'})


def save_profile_form(request, form, template_name):
    data = dict()
    if request.method == 'POST':
        if form.is_valid():
            instance=form.save()
            create_related_tolid_padash(instance.id)
            create_related_nezafat_padash(instance.id)
            create_related_randemanInit_padash(instance.id)
            # create_related_nezafat_padash(instance.id)
            # create_related_randeman_init_padash(instance.id)

            data['form_is_valid'] = True
            profile = FinancialProfile.objects.all()
            data['html_profile_list'] = render_to_string('mrp/financial_profile/partial_profile_list.html', {
                'profiles': profile
            })
        else:
            data['form_is_valid'] = False
    context = {'form': form}
    data['html_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)


def profile_create(request):
    if request.method == 'POST':
        form = FinancialProfileForm(request.POST)
    else:
        form = FinancialProfileForm()
    return save_profile_form(request, form, 'mrp/financial_profile/partial_profile_create.html')


def profile_update(request, pk):
    profile = get_object_or_404(FinancialProfile, pk=pk)
    if request.method == 'POST':
        form = FinancialProfileForm(request.POST, instance=profile)
    else:
        form = FinancialProfileForm(instance=profile)
    return save_profile_form(request, form, 'mrp/financial_profile/partial_profile_update.html')


def profile_delete(request, pk):
    profile = get_object_or_404(FinancialProfile, pk=pk)
    data = dict()
    if request.method == 'POST':
        profile.delete()
        data['form_is_valid'] = True
        profile = FinancialProfile.objects.all()
        data['html_profile_list'] = render_to_string('mrp/financial_profile/partial_profile_list.html', {
            'profiles': profile
        })
    else:
        context = {'profile': profile}
        data['html_form'] = render_to_string('mrp/financial_profile/partial_profile_delete.html', context, request=request)
    return JsonResponse(data)
