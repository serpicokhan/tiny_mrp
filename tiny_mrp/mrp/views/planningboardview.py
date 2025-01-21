from django.shortcuts import render,redirect, get_object_or_404
from django.http import JsonResponse,HttpResponse
from django.template.loader import render_to_string
from django.views.decorators.csrf import csrf_exempt
from mrp.models import PurchaseRequest, RequestItem,SysUser,Part,Asset2,PurchaseRequestFile,Asset,Comment,PurchaseNotes,PurchaseActivityLog
from django.template.loader import render_to_string
from mrp.business.purchaseutility import *
from mrp.business.DateJob import *
from django.db.models import Q
from django.contrib.auth.context_processors import PermWrapper
from django.core.files.storage import FileSystemStorage
from mrp.forms import PurchaseRequestFileForm
import openpyxl
from openpyxl.styles import Border, Side, PatternFill,Font,Alignment
import json
from django.contrib.auth.decorators import login_required
from django.contrib.auth.decorators import permission_required


def list_pboard(request):
    items=RequestItem.objects.filter(purchase_request__status="Approve2")
    return render(request,'mrp/purchase_planningboard/list.html',{"items":items})