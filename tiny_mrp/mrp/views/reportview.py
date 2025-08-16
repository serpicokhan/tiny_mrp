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
from django.db.models import Sum, F, ExpressionWrapper, fields
from datetime import timedelta,datetime as dt
from mrp.business.ReportUtility import *
from django.template.loader import render_to_string
from django.shortcuts import get_object_or_404
from django.views.decorators import csrf
from mrp.forms import ReportForm


@login_required
def daily_tolid_with_chart(request):
    
    return render(request,'mrp/report/daily_tolid.html',{})
def production_chart_with_table(request):
    date_str = request.GET.get('date',False) # Modify these dates as needed

    if(not date_str):
        # Assume 'date' is passed as 'YYYY-MM-DD' format from the front end
        date_str=DailyProduction.objects.order_by('-dayOfIssue').first().dayOfIssue
    else:
        date_str=DateJob.getTaskDate(date_str)

    production_data={}
    data=[]

    # date = datetime.datetime.strptime(date_str, '%Y-%m-%d').date()
    
    # Query to get sum of production_value for each machine for the given date
    shifts=Shift.objects.all()
    for i in shifts:
        production_data1 = DailyProduction.objects.filter(dayOfIssue=date_str,shift=i)\
                        .values('machine__assetName')\
                        .annotate(total_production=Sum('production_value'))\
                        .order_by('machine')
        production_data2 = DailyProduction.objects.filter(dayOfIssue=date_str,shift=i)\
                        .values('machine__assetCategory__name')\
                        .annotate(total_production=Sum('production_value'))\
                        
        data.append(
            {
        'asset_category':[item['machine__assetCategory__name'] for item in production_data2],
        'production_values2': [int(item['total_production']) for item in production_data2],

        'machines': [item['machine__assetName'] for item in production_data1],
        'production_values': [int(item['total_production']) for item in production_data1],
        'date':str(jdatetime.date.fromgregorian(date=date_str).strftime("%d-%m-%Y")),
        'lable':f'شیفت {i.name}'
        
             }
        )
   
    
    # data = {
    #     'machines': [item['machine__assetName'] for item in production_data],
    #     'production_values': [int(item['total_production']) for item in production_data],
    #     'date':str(jdatetime.date.fromgregorian(date=date_str)),
        
    # }
    
    return JsonResponse(data,safe=False)


@permission_required('cmms.view_report',login_url='/not_found')
def list_report(request,id=None):
    #
    books = Report.objects.all()
    Cat=Report.Category
    wos=ReportUtility.doPaging(request,books)
    return render(request, 'cmms/reports/main.html', {'reports': wos,'cat':Cat,'section':'list_report'})
##########################################################
def save_report_form(request, form, template_name,id=None):
    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            form.save()
            data['form_is_valid'] = True
            books = Report.objects.all()
            wos=ReportUtility.doPaging(request,books)
            data['html_report_list'] = render_to_string('cmms/reports/partialReportList.html', {
                'reports': wos
            })
            data['form_is_valid'] = True
        else:
            data['form_is_valid'] = False

    context = {'form': form}


    data['html_report_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
##########################################################


def report_delete(request, id):
    comp1 = get_object_or_404(Report, id=id)
    data = dict()
    if (request.method == 'POST'):
        comp1.delete()
        data['form_is_valid'] = True  # This is just to play along with the existing code
        companies =  Report.objects.all()
        #Tasks.objects.filter(reportId=id).update(report=id)
        data['html_report_list'] = render_to_string('cmms/report/partialReportList.html', {
            'report': companies
        })
    else:
        context = {'report': comp1}
        data['html_report_form'] = render_to_string('cmms/report/partialReportDelete.html',
            context,
            request=request,
        )
    return JsonResponse(data)

##########################################################

##########################################################
def report_create(request):
    if (request.method == 'POST'):
        form = ReportForm(request.POST)
        return save_report_form(request, form, 'cmms/reports/partialReportCreate.html')
    else:

        form = ReportForm()
        return save_report_form(request, form, 'cmms/reports/partialReportCreate.html')




##########################################################
def report_update(request, id):
    company= get_object_or_404(Report, id=id)

    if (request.method == 'POST'):
        form = ReportForm(request.POST, instance=company)
    else:
        form = ReportForm(instance=company)


    return save_report_form(request, form,"cmms/reports/partialReportUpdate.html",id)
##########################################################

##########################################################
def reportSearch(request,str):
    data=dict()
    str=str.replace('empty_','')
    str=str.replace('_',' ')
    books=[]
    # print(str,len(str),'&&&&&&&&&&&')
    if(not str):
        books=Report.objects.all()
        str='empty_'
    else:
        books = Report.objects.filter(Q(reportName__contains=str)|Q(reportDetails__contains=str))
    wos=ReportUtility.doPaging(request,books)
    data['html_report_list'] = render_to_string('cmms/reports/partialReportList.html', {
         'reports': wos,
         'perms': PermWrapper(request.user),
     })
    data['html_report_paginator'] = render_to_string('cmms/reports/partialReportPagination.html', {'reports': wos,'pageType':'reportSearch' ,'pageArg':str })
    return JsonResponse(data)
def FilterReportCategory(request,id):
    data=dict()

    books=[]

    if(id=='-1'):
        books = Report.objects.all()
    else:
         books = Report.objects.filter(reportCategory=id)
    wos=ReportUtility.doPaging(request,books)
    data['html_report_list'] = render_to_string('cmms/reports/partialReportList.html', {
         'reports': wos,'perms': PermWrapper(request.user)
     })
    # print(wos)
    data['html_report_paginator'] = render_to_string('cmms/reports/partialReportPagination.html', {'reports': wos,'pageType':'FilterReportCategory','pageArg':id})
    return JsonResponse(data)
def make_favorits_report(request,id):
    rep=Report.objects.get(id=id)
    rep.reportFav=not rep.reportFav
    rep.save()
    data=dict()
    data["form_is_valid"]=True
    return JsonResponse(data)
def show_fav_reports(request,id):
    data=dict()

    books=[]

    if(id=='1'):
        books = Report.objects.filter(reportFav=True)
    else:
         books = Report.objects.all()
    wos=ReportUtility.doPaging(request,books)
    data['html_report_list'] = render_to_string('cmms/reports/partialReportList.html', {
         'reports': wos
         ,'perms': PermWrapper(request.user)
     })
    # print(wos)
    data['html_report_paginator'] = render_to_string('cmms/reports/rep_pagination2.html', {'reports': wos})
    return JsonResponse(data)
