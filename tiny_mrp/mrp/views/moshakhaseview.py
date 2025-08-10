# views.py - Django views for operator AJAX endpoints

from django.http import JsonResponse
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
                'la': operator.la
                
            })
        
        return JsonResponse({
            'results': results,
            'has_more': page_obj.has_next(),
            'total_count': paginator.count
        })

