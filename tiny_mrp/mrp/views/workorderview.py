from django.shortcuts import render

def list_workorder(request):
    return render(request,"mrp/maintenance/workorder/woList.html",{})