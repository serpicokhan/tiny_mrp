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
from mrp.business.tolid_util import *
from django.template.loader import render_to_string


@login_required
def get_daily_amar(request):
    dayOfIssue=request.GET.get('event_id',datetime.now())
    date_object = datetime.strptime(dayOfIssue, '%Y-%m-%d')

    next_day = date_object + timedelta(days=1)

# Calculate previous day
    previous_day = date_object - timedelta(days=1)
    machines=Asset.objects.filter(assetTypes=2)
    shift=Shift.objects.all()
    machines_with_formulas = []
    for s in shift:
        for machine in machines:
            try:
                formula = Formula.objects.get(machine=machine)
                speedformula = SpeedFormula.objects.get(machine=machine)
                amar=DailyProduction.objects.get(machine=machine,dayOfIssue=dayOfIssue,shift=s)
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speedformula':speedformula.formula,'amar':amar,'shift':s})
                # else:
                #     machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})


            except Formula.DoesNotExist:
                machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0})
            except SpeedFormula.DoesNotExist:
                machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0,'speedformula':0})
            except DailyProduction.DoesNotExist:
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})

    return render(request,"mrp/tolid/daily_details.html",{'machines':machines_with_formulas,'shifts':shift,'next_date':next_day.strftime('%Y-%m-%d'),'prev_date':previous_day.strftime('%Y-%m-%d'),'today':jdatetime.date.fromgregorian(date=date_object),'title':'آمار روزانه'})

@login_required
def index(request):
    machines=Asset.objects.filter(assetTypes=2)
    shift=Shift.objects.all()
    machines_with_formulas = []
    for machine in machines:
        try:
            speed=DailyProduction.objects.filter(machine=machine).last()
            nomre=DailyProduction.objects.filter(machine=machine).last()
            formula = Formula.objects.get(machine=machine)
            speedformula = SpeedFormula.objects.get(machine=machine)
            mydict={}
            mydict["machin"]=machine
            mydict["formula"]=formula.formula
            if(speed):
                mydict["speed"]=speed.speed
            else:
                mydict["speed"]=0
            if(nomre):
                mydict["nomre"]=nomre.nomre
            else:
                mydict["nomre"]=0

            if(speed):
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':speed.speed,'nomre':speed.nomre,'speedformula':speedformula.formula,'max':"{:.0f}".format(speed.eval_max_tolid())})
            else:
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})


        except Formula.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0})
        except SpeedFormula.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0,'speedformula':0})
        except DailyProduction.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})

    return render(request,"mrp/tolid/details.html",{'machines':machines_with_formulas,'shifts':shift,'title':'ورود داده های روزانه'})
@login_required
def tolid_heatset(request):
    machines=Asset.objects.filter(assetCategory__id=8)
    shift=Shift.objects.all()
    machines_with_formulas = []
    for machine in machines:
        try:
            speed=DailyProduction.objects.filter(machine=machine).last()
            nomre=DailyProduction.objects.filter(machine=machine).last()
            formula = Formula.objects.get(machine=machine)
            speedformula = SpeedFormula.objects.get(machine=machine)
            mydict={}
            mydict["machin"]=machine
            mydict["formula"]=formula.formula
            if(speed):
                mydict["speed"]=speed.speed
            else:
                mydict["speed"]=0
            if(nomre):
                mydict["nomre"]=nomre.nomre
            else:
                mydict["nomre"]=0

            if(speed):
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':speed.speed,'nomre':speed.nomre,'speedformula':speedformula.formula,'max':"{:.0f}".format(speed.eval_max_tolid())})
            else:
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})


        except Formula.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0})
        except SpeedFormula.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0,'speedformula':0})
        except DailyProduction.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})

    return render(request,"mrp/tolid/heatset_details.html",{'machines':machines_with_formulas,'shifts':shift,'title':'ورود داده های روزانه'})

@csrf_exempt
def saveAmarTableInfo(request):
    # print(request.body)
    # print(request.POST)
    data = json.loads(request.body)
    # print("********")
    for table_name, table_data in data.items():
        for i in table_data:
            m=Asset.objects.get(id=int(i["machine"]))
            s=Shift.objects.get(id=int(i["shift"]))
            d=DailyProduction.objects.filter(machine=m,shift=s,dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-')))
            if(d.count()>0):
                d[0].machine=m
                d[0].shift=s
                d[0].dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-'))
                d[0].speed=i["speed"]
                d[0].nomre=i["nomre"]
                d[0].counter=float(i["counter"])
                d[0].production_value=float(i["production_value"])
                d[0].save()

            # print(i)
            # print(i)
            # print("********")
            else:
                amar=DailyProduction()
                # amar.shift=i["shift"]
                amar.machine=m
                amar.shift=s
                amar.dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-'))
                amar.speed=i["speed"]
                amar.nomre=i["nomre"]
                amar.counter=float(i["counter"])
                amar.production_value=float(i["production_value"])
                amar.save()
            # print("done",amar.id)
    data=dict()
    return JsonResponse(data)

@csrf_exempt
def saveAmarHTableInfo(request):
    # print(request.body)
    # print(request.POST)
    data = json.loads(request.body)
    # print("********")
    for table_name, table_data in data.items():
        for i in table_data:
            m=Asset.objects.get(id=int(i["machine"]))
            s=Shift.objects.get(id=int(i["shift"]))
            d=DailyProduction.objects.filter(machine=m,shift=s,dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-')))
            if(d.count()>0):
                d[0].machine=m
                d[0].shift=s
                d[0].dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-'))
                d[0].speed=i["speed"]
                d[0].nomre=i["nomre"]
                d[0].counter=float(i["counter"])
                d[0].production_value=float(i["production_value"])
                d[0].daf_num=float(i["daf_num"])
                d[0].dook_weight=float(i["dook_weight"])
                d[0].weight1=float(i["weight1"])
                d[0].weight2=float(i["weight2"])
                d[0].weight3=float(i["weight3"])
                d[0].weight4=float(i["weight4"])
                d[0].weight5=float(i["weight5"])
                d[0].net_weight=float(i["vazne_baghi"])

                d[0].save()

            # print(i)
            # print(i)
            # print("********")
            else:
                amar=DailyProduction()
                # amar.shift=i["shift"]
                amar.machine=m
                amar.shift=s
                amar.dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-'))
                amar.speed=i["speed"]
                amar.nomre=i["nomre"]
                amar.counter=float(i["counter"])
                amar.production_value=float(i["production_value"])
                amar.daf_num=float(i["daf_num"])
                amar.dook_weight=float(i["dook_weight"])
                amar.weight1=float(i["weight1"])
                amar.weight2=float(i["weight2"])
                amar.weight3=float(i["weight3"])
                amar.weight4=float(i["weight4"])
                amar.weight5=float(i["weight5"])
                amar.net_weight=float(i["vazne_baghi"])
                amar.save()
                print("done!!!")
            # print("done",amar.id)
    data=dict()
    return JsonResponse(data)


def show_daily_amar_tolid(request):
    q=request.GET.get('date',datetime.now().date())
    date_object = datetime.strptime(q, '%Y-%m-%d')

    next_day = date_object + timedelta(days=1)


# Calculate previous day
    previous_day = date_object - timedelta(days=1)
    shifts=Shift.objects.all()
    machines=Asset.objects.filter(assetTypes=2)
    machines_with_amar=[]
    m_count=1

    if(q):
        sum_randeman=0
        for index,m in enumerate(machines):

            asset_types=get_asset_count(m.assetCategory)
            shift_val=[]
            sum=0

            max_speed=1
            sum_cat=0
            for i in shifts:
                try:
                    amar=DailyProduction.objects.filter(machine=m,shift=i,dayOfIssue=q)[0]
                    # total_production2 = amar.aggregate(Sum('production_value'))['production_value__sum'] or 0
                    shift_val.append({'value':amar.production_value,'shift':i})
                    sum+=amar.production_value
                    max_speed=amar.eval_max_tolid()


                except Exception as e:
                    shift_val.append({'value':0,'shift':i})
            machines_with_amar.append({'machine':m.assetName,'shift_amar':shift_val,'sum':sum,'max_speed':"{:.2f} %".format((sum/max_speed)*100)})
            print("sum_randeman",sum_randeman)
            if(index<len(machines)):
                sum_randeman+=(sum/max_speed)

            # print(get_sum_machine_by_date_shift(m.assetCategory,q,i))

            try:
                if(machines[index].assetCategory !=machines[index+1].assetCategory and asset_types>1):

                    x=[]
                    for i in shifts:
                        x.append({'value':get_sum_machine_by_date_shift(m.assetCategory,i,q),'shift':i})
                    print(sum_randeman)
                    machines_with_amar.append({'machine':"جمع {} ها".format(m.assetCategory) ,'css':'font-weight-bold','shift_amar':x,'sum':get_sum_machin_product_by_cat(m,q),'max_speed':"{:.2f} %".format((get_sum__speed_machine_by_category(m.assetCategory,q))*100)})
                    sum_randeman=0
            except:

                if(index==len(machines)-1 and asset_types>1):

                    x=[]
                    for i in shifts:
                        x.append({'value':get_sum_machine_by_date_shift(m.assetCategory,i,q),'shift':i})
                    machines_with_amar.append({'machine':"جمع {} ها".format(m.assetCategory) ,'css':'font-weight-bold','shift_amar':x,'sum':get_sum_machin_product_by_cat(m,q),'max_speed':"{:.2f} %".format((get_sum__speed_machine_by_category(m.assetCategory,q))*100)})
                    sum_randeman=0

                pass






    return render(request,'mrp/tolid/daily_amar_tolid.html',{'shift':shifts,'machines_with_amar':machines_with_amar,'title':'راندمان روزانه تولید','next_date':next_day.strftime('%Y-%m-%d'),'prev_date':previous_day.strftime('%Y-%m-%d'),'today':jdatetime.date.fromgregorian(date=date_object)})

def show_daily_analyse_tolid(request):
        q=request.GET.get('date',datetime.now().date())
        q=request.GET.get('date',datetime.now().date())
        date_object = datetime.strptime(q, '%Y-%m-%d')
        next_day = date_object + timedelta(days=1)



    # Calculate previous day
        previous_day = date_object - timedelta(days=1)
        shifts=Shift.objects.all()
        machines=Asset.objects.filter(assetTypes=2)
        machines_with_amar=[]
        if(q):
            for index,m in enumerate(machines):
                asset_types=get_asset_count(m.assetCategory)
                shift_val=[]
                sum=0
                max_speed=0
                tolid_standard=ProductionStandard.objects.get(machine_name=m)
                for i in shifts:
                    try:


                        amar=DailyProduction.objects.filter(machine=m,shift=i,dayOfIssue=q)[0]
                        sum+=amar.production_value

                    except Exception as e:
                        print(e)

                machines_with_amar.append({'machine':m.assetName,'good':tolid_standard.good_production_rate,'mean':tolid_standard.mean_production_rate,
                'bad':tolid_standard.bad_production_rate,'real':sum,'kasre_tolid':sum-tolid_standard.good_production_rate})
                try:
                    if(machines[index].assetCategory !=machines[index+1].assetCategory and asset_types>1):


                        # print(sum_randeman)
                        tolid=get_sum_machin_product_by_cat(m,q)
                        good_tolid=get_good_standard_machine_by_date_category(m.assetCategory)
                        # machines_with_amar.append({'machine':"جمع {} ها".format(m.assetCategory) ,'css':'font-weight-bold','shift_amar':x,'sum':get_sum_machin_product_by_cat(m,q),'max_speed':"{:.2f} %".format((get_sum__speed_machine_by_category(m.assetCategory,q))*100)})
                        machines_with_amar.append({'machine':"جمع {} ها".format(m.assetCategory),'css':'font-weight-bold','good':good_tolid,'mean':get_mean_standard_machine_by_date_category(m.assetCategory)
                        ,'bad':get_bad_standard_machine_by_date_category(m.assetCategory),'real':tolid,'kasre_tolid':tolid-good_tolid})


                        sum_randeman=0
                except Exception as ex:
                    if(index==len(machines)-1 and asset_types>1):
                            tolid=get_sum_machin_product_by_cat(m,q)
                            good_tolid=get_good_standard_machine_by_date_category(m.assetCategory)



                            machines_with_amar.append({'machine':"جمع {} ها".format(m.assetCategory),'css':'font-weight-bold','good':good_tolid,'mean':get_mean_standard_machine_by_date_category(m.assetCategory)
                            ,'bad':get_bad_standard_machine_by_date_category(m.assetCategory),'real':tolid,'kasre_tolid':tolid-good_tolid})


                    pass


        return render(request,'mrp/tolid/daily_analyse_tolid.html',{'machines_with_amar':machines_with_amar,'title':'تحلیل روزانه تولید','next_date':next_day.strftime('%Y-%m-%d'),'prev_date':previous_day.strftime('%Y-%m-%d'),'today':jdatetime.date.fromgregorian(date=date_object)})
def calendar_main(request):
    return render(request,'mrp/tolid/calendar_main.html',{})
def calendar_randeman(request):
    return render(request,'mrp/tolid/calendar_randeman.html',{'title':'راندمان روزانه'})
def calendar_tahlil(request):
    return render(request,'mrp/tolid/calendar_tahlil.html',{'title':'تحلیل روزانه'})
def get_tolid_calendar_info(request):
    data=[]
    user_info=DailyProduction.objects.values_list('dayOfIssue').distinct()
    print(user_info)
    for i in user_info:
        print(i)
        data.append({'title': "آمار روزانه",\
                'start': i[0],\
                 'color': '#53c797',\
                'id':i[0]})

    return JsonResponse(data,safe=False)
def get_randeman_calendar_info(request):
    data=[]
    user_info=DailyProduction.objects.values_list('dayOfIssue').distinct()
    print(user_info)
    for i in user_info:
        z=get_sum_vaz_zayeat_by_date(i[0])
        data.append({'title': "راندمان روزانه",\
                'start': i[0],\
                 'color': '#fb3',\
                'id':i[0]})
        data.append({'title': "جمع ضایعات روز: {}".format(float(z)),\
                'start': i[0],\
                 'color': 'red',\
                'id':i[0]})

    return JsonResponse(data,safe=False)
def get_tahlil_calendar_info(request):
    data=[]
    user_info=DailyProduction.objects.values_list('dayOfIssue').distinct()

    for i in user_info:
        z=get_sum_vaz_zayeat_by_date(i[0])
        data.append({'title': 'تحلیل روزانه',\
                'start': i[0],\
                 'color': '#a6c',\
                'id':i[0]})
        data.append({'title': "جمع ضایعات روز: {}".format(float(z)),\
                'start': i[0],\
                 'color': 'red',\
                'id':i[0]})
    return JsonResponse(data,safe=False)
def list_formula(request):
    formulas=Formula.objects.all()
    return render(request,"mrp/formula/formulaList.html",{'formulas':formulas,'title':'لیست فرمولهای تولید'})
def list_speed_formula(request):
    formulas=SpeedFormula.objects.all()
    return render(request,"mrp/speed_formula/formulaList.html",{'formulas':formulas,'title':'لیست فرمولهای سرعت'})
def monthly_detaild_report(request):
    days=[]
    shift=Shift.objects.all()
    asset_category=asset_categories = AssetCategory.objects.annotate(
        min_priority=models.Min('asset__assetTavali')
        ).order_by('min_priority')

    current_date_time2 = jdatetime.datetime.now()
    current_year=current_date_time2.year
    j_month=request.GET.get('month',current_date_time2.month)


    current_date_time = jdatetime.date(current_year, int(j_month), 1)
    current_jalali_date = current_date_time



    if current_jalali_date.month == 12:
        first_day_of_next_month = current_jalali_date.replace(day=1, month=1, year=current_jalali_date.year + 1)
    else:
        first_day_of_next_month = current_jalali_date.replace(day=1, month=current_jalali_date.month + 1)


    num_days = (first_day_of_next_month - jdatetime.timedelta(days=1)).day
    cat_list=[]
    for cats in asset_category:
        sh_list=[]

        days=[]
        for day in range(1,num_days+1):
            product={}
            j_date=jdatetime.date(current_jalali_date.year,current_jalali_date.month,day)
            for sh in shift:
                product[sh.id]=get_sum_machine_by_date_shift(cats,sh,j_date.togregorian())
            days.append({'cat':cats,'date':"{0}/{1}/{2}".format(current_jalali_date.year,current_jalali_date.month,day),'day_of_week':DateJob.get_day_of_week(j_date),'product':product})

        cat_list.append({'cat':cats,'shift_val':days})

    return render(request,'mrp/tolid/monthly_detailed.html',{'cats':asset_category,'title':'آمار ماهانه','cat_list':cat_list,'shift':shift,'month':j_month})
def list_randeman_tolid(request):
    formulas=AssetRandemanInit.objects.all()
    return render(request,"mrp/tolid_randeman/randemanList.html",{'formulas':formulas,'title':'لیست راندمان'})

def get_sum_randeman_by_shift(mah,sal,shift):


    filtered_production = AssetRandemanPerMonth.objects.filter(
    mah=mah,sal=sal,  # Filter by date range

    shift=shift  # Filter by asset category n
    )
    # Calculate the sum of production_value
    sum_production_value = filtered_production.aggregate(
        total_production_value=models.Sum('tolid_value')
    )['total_production_value']

    if(not sum_production_value):
        return 0

    return sum_production_value
def get_monthly_workbook(request):
    mah=request.GET.get("mah",False)
    sal=request.GET.get("sal",False)
    shift_list=Shift.objects.all()
    randeman_list=AssetRandemanPerMonth.objects.filter(mah=mah,sal=sal)
    d=[]
    for i in randeman_list:

        d.append({'operator_num':AssetRandemanInit.objects.get(asset_category=i.asset_category).operator_count,'randeman':i})
    k=[]
    for i in shift_list:
        k.append({'randeman_kol':get_sum_randeman_by_shift(mah,sal,i),'shift':i})

    return render(request,'mrp/assetrandeman/finalRandemanList.html',{'shift_list':shift_list,'randeman_list':d,'randeman_kol':k})
def list_heatset_info(request):
        dayOfIssue=DateJob.getTaskDate(request.GET.get('event_id',False))
        print(dayOfIssue)

        date_object = datetime.strptime(str(dayOfIssue), '%Y-%m-%d')

        next_day = date_object + timedelta(days=1)
        data=dict()

    # Calculate previous day
        previous_day = date_object - timedelta(days=1)
        machines=Asset.objects.filter(assetCategory__id=8)
        shift=Shift.objects.all()
        machines_with_formulas = []
        for s in shift:
            for machine in machines:
                try:
                    formula = Formula.objects.get(machine=machine)
                    speedformula = SpeedFormula.objects.get(machine=machine)
                    amar=DailyProduction.objects.get(machine=machine,dayOfIssue=dayOfIssue,shift=s)
                    machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speedformula':speedformula.formula,'amar':amar,'shift':s})
                    # else:
                    #     machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})


                except Formula.DoesNotExist:
                    machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0})
                except SpeedFormula.DoesNotExist:
                    machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0,'speedformula':0})
                except DailyProduction.DoesNotExist:
                    machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})
        data['html_heatset_result'] = render_to_string('mrp/tolid/partialHeatsetList.html',{
            'machines':machines_with_formulas,
            'shifts':shift,'next_date':next_day.strftime('%Y-%m-%d'),'prev_date':previous_day.strftime('%Y-%m-%d'),'today':jdatetime.date.fromgregorian(date=date_object)}
        )

        # return render(request,"mrp/tolid/daily_details.html",{'machines':machines_with_formulas,'shifts':shift,'next_date':next_day.strftime('%Y-%m-%d'),'prev_date':previous_day.strftime('%Y-%m-%d'),'today':jdatetime.date.fromgregorian(date=date_object),'title':'آمار روزانه'})
        return JsonResponse(data)
