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
from mrp.business.tolid_util import *
import datetime
from django.shortcuts import get_object_or_404
from django.core.exceptions import ValidationError
from mrp.forms import ProductForm, ProductFilterForm
from django.shortcuts import render, redirect, get_object_or_404
from django.views.generic import ListView
from django.contrib import messages
from django.views.decorators.http import require_GET
from rest_framework.decorators import api_view
from rest_framework.response import Response
from mrp.serializers import ProductSerializer

class ProductListView(ListView):
    model = Product
    template_name = 'mrp/product/partialProductList.html'
    context_object_name = 'products'
    paginate_by = 10
    
    def get_queryset(self):
        queryset = super().get_queryset()
        filter_form = ProductFilterForm(self.request.GET or None)
        
        if filter_form.is_valid():
            queryset = filter_form.filter_queryset(queryset)
        
        return queryset
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['filter_form'] = ProductFilterForm(self.request.GET or None)
        return context

def product_list(request):
    return render(request,"mrp/product/partialProductList.html",{})
def save_product_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            bts=form.save()
            data['form_is_valid'] = True
            
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_product_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
def create_product(request):
    if (request.method == 'POST'):
        form = ProductForm(request.POST)
        return save_product_form(request, form, 'mrp/product/partialProductCreate.html')
  
    else:
        
        form = ProductForm()
        return save_product_form(request, form, 'mrp/product/partialProductCreate.html')
@api_view(('GET',))
def product_list_api(request):
    # This is your mock data converted to Python format
    # mock_products = [
    #     {
    #         "id": 1,
    #         "name": "محصول الف",
    #         "code": "FP-001",
    #         "product_type": "finished",
    #         "unit_of_measure": "units",
    #         "cost_price": "15.50",
    #         "sale_price": "29.99",
    #         "available_quantity": 25,
    #         "created_at": "2023-06-10T09:15:00Z",
    #         "updated_at": "2023-06-15T14:30:00Z"
    #     },
    #     {
    #         "id": 2,
    #         "name": "محصول ب",
    #         "code": "RM-001",
    #         "product_type": "raw",
    #         "unit_of_measure": "kg",
    #         "cost_price": "8.75",
    #         "sale_price": "12.50",
    #         "available_quantity": 150.5,
    #         "created_at": "2023-05-20T11:20:00Z",
    #         "updated_at": "2023-06-12T16:45:00Z"
    #     },
    #     {
    #         "id": 3,
    #         "name": "محصول پ",
    #         "code": "CP-001",
    #         "product_type": "component",
    #         "unit_of_measure": "units",
    #         "cost_price": "3.20",
    #         "sale_price": "5.99",
    #         "available_quantity": 0,
    #         "created_at": "2023-06-01T08:30:00Z",
    #         "updated_at": "2023-06-18T10:15:00Z"
    #     },
    #     {
    #         "id": 4,
    #         "name": "محصول ث",
    #         "code": "FP-002",
    #         "product_type": "finished",
    #         "unit_of_measure": "units",
    #         "cost_price": "22.00",
    #         "sale_price": "45.00",
    #         "available_quantity": 8,
    #         "created_at": "2023-06-05T14:00:00Z",
    #         "updated_at": "2023-06-16T09:30:00Z"
    #     }
    # ]
    
    products = Product.objects.all()
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)
   