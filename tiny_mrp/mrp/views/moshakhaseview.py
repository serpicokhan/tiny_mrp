# views.py - Django views for operator AJAX endpoints

from django.shortcuts import render, get_object_or_404
from django.http import JsonResponse
from django.template.loader import render_to_string
from django.db.models import Q
from django.core.paginator import Paginator
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.views import View
from django.db.models import Value
from django.db.models.functions import Concat
import json

# Import your Operator model
from mrp.models.moshakhase import *

class MoshakhaseSearchView(View):
    """
    AJAX endpoint for searching operators with pagination
    """
    def get(self, request):
        search_term = request.GET.get('q', '')
        print(search_term)
        page = int(request.GET.get('page', 1))
        per_page = 20  # Number of results per page
        
        # Build search query using your model fields
        if search_term:
            operators = EntryForm.objects.filter(
                Q(name__icontains=search_term) |
                Q(color__name__icontains=search_term) 
            )
        else:
            operators = EntryForm.objects.all().order_by('name', 'color__name')
        
        # Paginate results
        paginator = Paginator(operators, per_page)
        page_obj = paginator.get_page(page)
        
        # Format response
        results = []
        for operator in page_obj:
            results.append({
                'id': operator.id,
                'name': operator.name,
                'color_id': operator.color.id,
                'color_name': operator.color.name,
                'tool': operator.tool,
                'la': operator.la})
        return JsonResponse({
            'results': results,
            'has_more': page_obj.has_next(),
            'total_count': paginator.count
        })

def profile_list(request):
    profile = FinancialProfile.objects.order_by('-id')
    return render(request, 'mrp/financial_profile/profile_list.html', {'profiles': profile,'title':'پروفال مالی'})


def save_profile_form(request, form, template_name,is_new=None):
    data = dict()
    if request.method == 'POST':
        if form.is_valid():
            instance=form.save()
            if(is_new):
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
    return save_profile_form(request, form, 'mrp/financial_profile/partial_profile_create.html',is_new=True)


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
