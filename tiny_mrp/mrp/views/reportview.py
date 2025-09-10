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
from django.utils import timezone
from django.db.models import Sum, F, ExpressionWrapper, FloatField
from datetime import datetime
from django.core.paginator import Paginator

@login_required
def daily_tolid_with_chart(request):
    
    return render(request,'mrp/report/daily_tolid.html',{})





@login_required
def daily_tolid_main(request):
    # Fetch all locations (assets with no parent location) and categories
    locations = Asset.objects.filter(assetIsLocatedAt__isnull=True)
    categories = AssetCategory.objects.all().order_by('priority')
    shifts=Shift.objects.all()

    # Initialize query for DailyProduction
    productions = DailyProduction.objects.filter(production_value__gt=0).order_by('-dayOfIssue')

    # Handle filters from GET request
    start_date = request.GET.get('start_date')
    end_date = request.GET.get('end_date')
    if(start_date):
        start_date=DateJob.getTaskDate(start_date)
    if(end_date):
        end_date=DateJob.getTaskDate(end_date)
    print(start_date,end_date,'$$$$$$$$$$$$$$$$$$')
    operator_id = request.GET.get('operator_data')
    print(operator_id)
    machine_id = request.GET.get('machine_id')
    category_id = request.GET.get('category_id')
    shift_id = request.GET.get('shift_id')

    # Apply date filters
    if start_date:
        # start_date = datetime.strptime(start_date, '%Y-%m-%d').date()
        productions = productions.filter(dayOfIssue__gte=start_date)
    if end_date:
        # end_date = datetime.strptime(end_date, '%Y-%m-%d').date()
        productions = productions.filter(dayOfIssue__lte=end_date)

    # Apply operator filter (check JSON field for operator ID)
    if operator_id:
        productions = productions.filter(operators_data__contains=operator_id)

    # Apply machine filter
    if machine_id and machine_id !='-1':

        productions = productions.filter(machine_id=machine_id)

    # Apply category filter
    if category_id and category_id !='-1':
        productions = productions.filter(machine__assetCategory_id=category_id)

    # Calculate summary metrics (using total values, not divided)
    total_production = productions.aggregate(
        total=Sum(F('production_value'), output_field=FloatField(), default=0.0)
    )['total'] or 0.0
    total_wastage = productions.aggregate(
        total=Sum(F('wastage_value'), output_field=FloatField(), default=0.0)
    )['total'] or 0.0
    wastage_rate = (total_wastage / total_production * 100) if total_production > 0 else 0.0

    # Prepare report data (one row per operator)
    report_data = []
    for prod in productions:
        # Parse operators_data JSON to get operator names
        operator_names = []
        operator_count = 1  # Default to 1 to avoid division by zero
        if prod.operators_data:
            try:
                operators = prod.operators_data if isinstance(prod.operators_data, list) else json.loads(prod.operators_data)
                operator_names = [op['name'] for op in operators if 'name' in op]
                operator_count = len(operator_names) if operator_names else 1
            except (json.JSONDecodeError, TypeError):
                operator_names = ['Unknown']
                operator_count = 1

        # Handle None values for production and wastage
        production = float(prod.production_value) if prod.production_value is not None else 0.0
        wastage = float(prod.wastage_value) if prod.wastage_value is not None else 0.0
        # Divide production and wastage by operator_count
        production_per_operator = production / operator_count if operator_count > 0 else 0.0
        wastage_per_operator = wastage / operator_count if operator_count > 0 else 0.0
        wastage_rate_row = (wastage_per_operator / production_per_operator * 100) if production_per_operator > 0 else 0.0

        # Create one row per operator
        for operator_name in operator_names:
            report_data.append({
                'date': jdatetime.date.fromgregorian(date=prod.dayOfIssue).strftime('%Y/%m/%d'),
                'operator': operator_name,
                'machine': prod.machine.assetName if prod.machine else 'Unknown',
                'production': production_per_operator,
                'wastage': wastage_per_operator,
                'wastage_rate': wastage_rate_row,
            })

    # Pagination
    paginator = Paginator(report_data, 10)  # Show 10 records per page
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)

    # Prepare chart data (based on total values, not divided)
    chart_data={}
    # chart_data = {
    #     'daily_production': {
    #         'labels': [prod.dayOfIssue.strftime('%Y/%m/%d') for prod in productions],
    #         'data': [float(prod.production_value) if prod.production_value is not None else 0.0 for prod in productions]
    #     },
    #     'wastage_by_machine': {
    #         'labels': list(productions.values('machine__assetName').distinct().values_list('machine__assetName', flat=True)),
    #         'data': [
    #             productions.filter(machine__assetName=machine).aggregate(total=Sum(F('wastage_value'), default=0.0))['total'] or 0.0
    #             for machine in productions.values('machine__assetName').distinct().values_list('machine__assetName', flat=True)
    #         ]
    #     }
    # }

    # # Prepare all operators for dropdown
    all_operators = set()
    # for prod in DailyProduction.objects.all():
    #     if prod.operators_data:
    #         try:
    #             operators = prod.operators_data if isinstance(prod.operators_data, list) else json.loads(prod.operators_data)
    #             for op in operators:
    #                 if 'name' in op and 'id' in op:
    #                     all_operators.add((op['id'], op['name']))
    #         except (json.JSONDecodeError, TypeError):
    #             pass

    context = {
        'makan': locations,
        'category': categories,
        'shifts':shifts,
        'report_data': page_obj,  # Use paginated report_data
        'total_production': round(total_production, 2),
        'total_wastage': round(total_wastage, 2),
        'wastage_rate': round(wastage_rate, 2),
        'chart_data': chart_data,
        'page_obj': page_obj,
        'operators': [{'id': oid, 'name': name} for oid, name in all_operators],
    }

    return render(request, 'mrp/report/daily_tolid_main.html', context)

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


def list_report(request,id=None):
    #
    books = Report.objects.all()
    Cat=Report.Category
    wos=ReportUtility.doPaging(request,books)
    return render(request, 'mrp/reports/main.html', {'reports': wos,'cat':Cat,'section':'list_report'})
##########################################################
def save_report_form(request, form, template_name,id=None):
    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():
            form.save()
            data['form_is_valid'] = True
            books = Report.objects.all()
            wos=ReportUtility.doPaging(request,books)
            data['html_report_list'] = render_to_string('mrp/reports/partialReportList.html', {
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
        data['html_report_list'] = render_to_string('mrp/report/partialReportList.html', {
            'report': companies
        })
    else:
        context = {'report': comp1}
        data['html_report_form'] = render_to_string('mrp/report/partialReportDelete.html',
            context,
            request=request,
        )
    return JsonResponse(data)

##########################################################

##########################################################
def report_create(request):
    if (request.method == 'POST'):
        form = ReportForm(request.POST)
        return save_report_form(request, form, 'mrp/reports/partialReportCreate.html')
    else:

        form = ReportForm()
        return save_report_form(request, form, 'mrp/reports/partialReportCreate.html')




##########################################################
def report_update(request, id):
    company= get_object_or_404(Report, id=id)

    if (request.method == 'POST'):
        form = ReportForm(request.POST, instance=company)
    else:
        form = ReportForm(instance=company)


    return save_report_form(request, form,"mrp/reports/partialReportUpdate.html",id)
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
    data['html_report_list'] = render_to_string('mrp/reports/partialReportList.html', {
         'reports': wos,
         'perms': PermWrapper(request.user),
     })
    data['html_report_paginator'] = render_to_string('mrp/reports/partialReportPagination.html', {'reports': wos,'pageType':'reportSearch' ,'pageArg':str })
    return JsonResponse(data)
def FilterReportCategory(request,id):
    data=dict()

    books=[]

    if(id=='-1'):
        books = Report.objects.all()
    else:
         books = Report.objects.filter(reportCategory=id)
    wos=ReportUtility.doPaging(request,books)
    data['html_report_list'] = render_to_string('mrp/reports/partialReportList.html', {
         'reports': wos,'perms': PermWrapper(request.user)
     })
    # print(wos)
    data['html_report_paginator'] = render_to_string('mrp/reports/partialReportPagination.html', {'reports': wos,'pageType':'FilterReportCategory','pageArg':id})
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
    data['html_report_list'] = render_to_string('mrp/reports/partialReportList.html', {
         'reports': wos
         ,'perms': PermWrapper(request.user)
     })
    # print(wos)
    data['html_report_paginator'] = render_to_string('mrp/reports/rep_pagination2.html', {'reports': wos})
    return JsonResponse(data)
