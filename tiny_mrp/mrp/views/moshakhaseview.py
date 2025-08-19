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
from mrp.forms import MoshakhaseForm
from mrp.business.tolid_util import doPaging
# Import your Operator model
from mrp.models.moshakhase import *
from django.contrib.auth.context_processors import PermWrapper


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

def moshakhase_list(request):
    moshakhase = EntryForm.objects.order_by('-id')
    ws=doPaging(request,moshakhase)
    return render(request, 'mrp/moshakhase/moshakhase_list.html', {'wo': ws,'title':'لیست محصولات'})


def save_moshakhase_form(request, form, template_name,is_new=None):
    data = dict()
    if request.method == 'POST':
        if form.is_valid():
            instance=form.save()
            # if(is_new):
            #     create_related_tolid_padash(instance.id)
            #     create_related_nezafat_padash(instance.id)
            #     create_related_randemanInit_padash(instance.id)
            # # create_related_nezafat_padash(instance.id)
            # create_related_randeman_init_padash(instance.id)

            data['form_is_valid'] = True

            # moshakhase = EntryForm.objects.all()
            # wo=doPaging(request,moshakhase)
            # data['html_moshakhase_list'] = render_to_string('mrp/moshakhase/partial_moshakhase_list.html', {
            #     'wo': wo
            # })
        else:
            data['form_is_valid'] = False
    context = {'form': form}
    data['html_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)


def moshakhase_create(request):
    if request.method == 'POST':
        form = MoshakhaseForm(request.POST)
    else:
        form = MoshakhaseForm()
    return save_moshakhase_form(request, form, 'mrp/moshakhase/partial_moshakhase_create.html',is_new=True)


def moshakhase_update(request, pk):
    moshakhase = get_object_or_404(EntryForm, pk=pk)
    if request.method == 'POST':
        form = MoshakhaseForm(request.POST, instance=moshakhase)
    else:
        form = MoshakhaseForm(instance=moshakhase)
    return save_moshakhase_form(request, form, 'mrp/moshakhase/partial_moshakhase_update.html')


def moshakhase_delete(request, pk):
    moshakhase = get_object_or_404(EntryForm, pk=pk)
    data = dict()
    if request.method == 'POST':
        moshakhase.delete()
        data['form_is_valid'] = True
        # moshakhase = MoshakhaseForm.objects.all()
        # data['html_moshakhase_list'] = render_to_string('mrp/moshakhase/partial_moshakhase_list.html', {
        #     'moshakhases': moshakhase
        # })
    else:
        context = {'moshakhase': moshakhase}
        data['html_form'] = render_to_string('mrp/moshakhase/partial_moshakhase_delete.html', context, request=request)
    return JsonResponse(data)
def search_moshakhase(request):
    query = request.GET.get('q', '')
    results = EntryForm.objects.all()
    
    if query:
        # Create a Q object to search across multiple fields
        search_filter = Q()
        
        # Search in name field
        search_filter |= Q(name__icontains=query)
        
        # Search in color name (through ForeignKey)
        search_filter |= Q(color__name__icontains=query)
        
        # Search in tool field (if it's a number)
        if query.isdigit():
            search_filter |= Q(tool=int(query))
            
        # Search in la field (if it's a number)
        if query.isdigit():
            search_filter |= Q(la=int(query))
            
        results = results.filter(search_filter)
    
    # Add pagination if needed (using the same pattern as your original view)
    # paginator = Paginator(results, 20)
    # page = request.GET.get('page')
    # results = paginator.get_page(page)
    results=doPaging(request,results)

    context = {
        'wo': results,
        'q': query,
        'title': 'نتایج جستجو'
    }
    
    return render(request, 'mrp/moshakhase/moshakhase_list.html', context)

def referesh_moshakhase_list(request):
    search_query = request.GET.get('q', '').strip() 
    page=request.GET.get('page', False)
    # print(page,request.GET,'@@@@@@@@@@')
    

    # if(request.user.is_superuser):
    
    requests = EntryForm.objects.all()
    

    # else:
    #     requests=PurchaseRequest.objects.filter(user__userId=request.user).order_by('-created_at')

    if search_query:
        filters = Q(color__name__icontains=search_query) | \
                Q(la__icontains=search_query) | \
                Q(name__icontains=search_query)| \
                Q(tool__icontains=search_query)
        
        # Only add the id filter if the search query is a digit
        if search_query.isdigit():
            filters |= Q(id=search_query)
        
        requests = requests.filter(filters).distinct()

    
    
    ws= doPaging(request,requests)
    data=dict()
    data["status"]="ok"
    data["html_moshakhase_list"]=render_to_string('mrp/moshakhase/partial_moshakhase_list.html', {
                        
                        'wo':ws,
                         'perms': PermWrapper(request.user) 

                       

                        
                    },request)
    return JsonResponse(data)