from django.shortcuts import render
from mrp.models import *

def list_dashboard(request):
    return render(request,'mrp/dashboard/main_dashboard.html',{'title':'داشبور مدیریتی'})