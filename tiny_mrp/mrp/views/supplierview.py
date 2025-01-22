from django.shortcuts import render
from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from django.template.loader import render_to_string
from mrp.models import Supplier
from mrp.business.supplierutility import *
def wo_getSuppliers(request):
    # print(request.GET['q'])
    searchStr= request.GET['qry'] if request.GET['qry'] else ''
    x=list(PartUtility.getSupplier(searchStr))
    return JsonResponse(x, safe=False)