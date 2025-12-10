from django.shortcuts import render


def threedview(request):
    return render(request,'mrp/3dmap/index.html',{})