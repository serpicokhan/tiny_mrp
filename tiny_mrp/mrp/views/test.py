from django.shortcuts import render
def index(request):
    return render(request,"mrp/blank-page.html",{})