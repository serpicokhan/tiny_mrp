from django.shortcuts import render, get_object_or_404
from django.http import JsonResponse
from django.template.loader import render_to_string
def list_purchase(request):
    return render(request,"mrp/purchase/purchase.html",{})
def list_purchase_req(request):
    return render(request,"mrp/purchase/purchaseList.html",{})