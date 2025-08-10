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
from mrp.models import Operator

class OperatorSearchView(View):
    """
    AJAX endpoint for searching operators with pagination
    """
    def get(self, request):
        search_term = request.GET.get('q', '')
        page = int(request.GET.get('page', 1))
        per_page = 20  # Number of results per page
        
        # Build search query using your model fields
        if search_term:
            operators = Operator.objects.filter(
                Q(FName__icontains=search_term) |
                Q(LName__icontains=search_term) |
                Q(PNumber__icontains=search_term) |
                Q(Pid__icontains=search_term) |
                Q(CpCode__icontains=search_term)
            ).annotate(
                full_name=Concat('FName', Value(' '), 'LName')
            ).order_by('FName', 'LName')
        else:
            operators = Operator.objects.all().annotate(
                full_name=Concat('FName', Value(' '), 'LName')
            ).order_by('FName', 'LName')
        
        # Paginate results
        paginator = Paginator(operators, per_page)
        page_obj = paginator.get_page(page)
        
        # Format response
        results = []
        for operator in page_obj:
            results.append({
                'id': operator.id,
                'name': f"{operator.FName} {operator.LName}",
                'personnel_number': operator.PNumber,
                'pid': operator.Pid,
                'cp_code': operator.CpCode,
                'card_no': operator.CardNo,
                'first_name': operator.FName,
                'last_name': operator.LName,
            })
        
        return JsonResponse({
            'results': results,
            'has_more': page_obj.has_next(),
            'total_count': paginator.count
        })

class OperatorDetailView(View):
    """
    AJAX endpoint for getting specific operator details
    """
    def get(self, request, operator_id):
        try:
            operator = Operator.objects.get(id=operator_id)
            return JsonResponse({
                'id': operator.id,
                'name': f"{operator.FName} {operator.LName}",
                'personnel_number': operator.PNumber,
                'pid': operator.Pid,
                'cp_code': operator.CpCode,
                'card_no': operator.CardNo,
                'first_name': operator.FName,
                'last_name': operator.LName,
            })
        except Operator.DoesNotExist:
            return JsonResponse({'error': 'Operator not found'}, status=404)

# Alternative function-based views if you prefer
def operator_search(request):
    """
    Function-based view for operator search
    """
    search_term = request.GET.get('q', '')
    page = int(request.GET.get('page', 1))
    per_page = 20
    
    if search_term:
        operators = Operator.objects.filter(
            Q(FName__icontains=search_term) |
            Q(LName__icontains=search_term) |
            Q(PNumber__icontains=search_term) |
            Q(Pid__icontains=search_term)
        ).order_by('FName', 'LName')
    else:
        operators = Operator.objects.all().order_by('FName', 'LName')
    
    paginator = Paginator(operators, per_page)
    page_obj = paginator.get_page(page)
    
    results = []
    for operator in page_obj:
        results.append({
            'id': operator.id,
            'name': f"{operator.FName} {operator.LName}",
            'personnel_number': operator.PNumber,
            'pid': operator.Pid,
        })
    
    return JsonResponse({
        'results': results,
        'has_more': page_obj.has_next()
    })

def operator_detail(request, operator_id):
    """
    Function-based view for operator detail
    """
    try:
        operator = Operator.objects.get(id=operator_id)
        return JsonResponse({
            'id': operator.id,
            'name': f"{operator.FName} {operator.LName}",
            'personnel_number': operator.PNumber,
            'pid': operator.Pid,
            'cp_code': operator.CpCode,
            'card_no': operator.CardNo,
            'first_name': operator.FName,
            'last_name': operator.LName,
        })
    except Operator.DoesNotExist:
        return JsonResponse({'error': 'Operator not found'}, status=404)