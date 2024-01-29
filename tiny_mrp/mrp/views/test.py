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
from mrp.forms import HeatsetMetrajForm

from django.db.models import Q
@login_required
def get_daily_amar(request):
    dayOfIssue=request.GET.get('event_id',datetime.datetime.now())
    date_object = datetime.datetime.strptime(dayOfIssue, '%Y-%m-%d')

    next_day = date_object + timedelta(days=1)

# Calculate previous day
    previous_day = date_object - timedelta(days=1)
    machines=Asset.objects.filter(assetTypes=2)
    heatsets=Asset.objects.filter(assetCategory__id=8)
    shift=Shift.objects.all()
    machines_with_formulas = []
    machines_with_formulas2 = []
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

    for s in shift:
        for machine in heatsets:
            try:
                formula = Formula.objects.get(machine=machine)
                speedformula = SpeedFormula.objects.first()
                amar=DailyProduction.objects.get(machine=machine,dayOfIssue=dayOfIssue,shift=s)
                machines_with_formulas2.append({'machine': machine, 'formula': formula.formula,'speedformula':speedformula.formula,'amar':amar,'shift':s})
            except Exception as ex:
                print(ex)


    return render(request,"mrp/tolid/daily_details.html",{'heatsets':machines_with_formulas2,'machines':machines_with_formulas,'shifts':shift,'next_date':next_day.strftime('%Y-%m-%d'),'prev_date':previous_day.strftime('%Y-%m-%d'),'today':jdatetime.date.fromgregorian(date=date_object),'title':'آمار روزانه'})

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
                x=d[0]
                x.machine=m
                x.shift=s
                x.dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-'))
                x.speed=i["speed"]
                x.nomre=i["nomre"]
                x.counter=float(i["counter"])
                x.production_value=float(i["production_value"])
                x.save()

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
                x=d[0]
                x.machine=m
                x.shift=s
                x.dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-'))


                x.speed=int(i["speed"])


                x.nomre=i["nomre"]
                x.counter=float(i["counter"])
                x.production_value=float(i["production_value"])

                x.daf_num=float(i["daf_num"])
                x.dook_weight=float(i["dook_weight"])
                x.weight1=float(i["weight1"])
                x.weight2=float(i["weight2"])
                x.weight3=float(i["weight3"])
                x.weight4=float(i["weight4"])
                x.weight5=float(i["weight5"])
                x.net_weight=float(i["vazne_baghi"])
                z=i["data_metraj"]
                if(z):
                   print(type(z))
                   if('dict' in str(type(z))):
                        # z=json.loads(i["data_metraj"])
                        print(z,z['metrajdaf1'])
                        x.metrajdaf1=z["metrajdaf1"]
                        print(x.metrajdaf1)

                        x.metrajdaf2=int(i["data_metraj"]["metrajdaf2"])
                        x.metrajdaf3=int(i["data_metraj"]["metrajdaf3"])
                        x.metrajdaf4=int(i["data_metraj"]["metrajdaf4"])
                        x.metrajdaf5=int(i["data_metraj"]["metrajdaf5"])
                        x.metrajdaf6=int(i["data_metraj"]["metrajdaf6"])
                        x.metrajdaf7=int(i["data_metraj"]["metrajdaf7"])
                        x.metrajdaf8=int(i["data_metraj"]["metrajdaf8"])
                        x.makhraj_metraj_daf=int(i["data_metraj"]["makhraj_metraj_daf"])


                    # x.metrajdaf1=int(i["data_metraj"][0])
                    # x.metrajdaf2=int(i["data_metraj"]["metrajdaf2"])
                    # x.metrajdaf3=int(i["data_metraj"]["metrajdaf3"])
                    # x.metrajdaf4=int(i["data_metraj"]["metrajdaf4"])
                    # x.metrajdaf5=int(i["data_metraj"]["metrajdaf5"])
                    # x.metrajdaf6=int(i["data_metraj"]["metrajdaf6"])
                    # x.metrajdaf7=int(i["data_metraj"]["metrajdaf7"])
                    # x.metrajdaf8=int(i["data_metraj"]["metrajdaf8"])
                    # x.makhraj_metraj_daf=int(i["data_metraj"]["makhraj_metraj_daf"])
                else:
                    x.metrajdaf1=0
                    x.metrajdaf2=0
                    x.metrajdaf3=0
                    x.metrajdaf4=0
                    x.metrajdaf5=0
                    x.metrajdaf6=0
                    x.metrajdaf7=0
                    x.metrajdaf8=0
                    x.makhraj_metraj_daf=0

                x.save()

            # print(i)
            # print(i)
            # print("********")
            else:
                print("here!!!")


                amar=DailyProduction()
                if(i["data_metraj"]):

                    amar.metrajdaf1=i["data_metraj"]["metrajdaf1"]
                    amar.metrajdaf2=i["data_metraj"]["metrajdaf2"]
                    amar.metrajdaf3=i["data_metraj"]["metrajdaf3"]
                    amar.metrajdaf4=i["data_metraj"]["metrajdaf4"]
                    amar.metrajdaf5=i["data_metraj"]["metrajdaf5"]
                    amar.metrajdaf6=i["data_metraj"]["metrajdaf6"]
                    amar.metrajdaf7=i["data_metraj"]["metrajdaf7"]
                    amar.metrajdaf8=i["data_metraj"]["metrajdaf8"]
                    amar.makhraj_metraj_daf=i["data_metraj"]["makhraj_metraj_daf"]
                else:
                    amar.metrajdaf1=0
                    amar.metrajdaf2=0
                    amar.metrajdaf3=0
                    amar.metrajdaf4=0
                    amar.metrajdaf5=0
                    amar.metrajdaf6=0
                    amar.metrajdaf7=0
                    amar.metrajdaf8=0
                    amar.makhraj_metraj_daf=0

                # amar.shift=i["shift"]
                amar.machine=m
                amar.shift=s
                amar.dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-'))
                amar.speed=0
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
    q=request.GET.get('date',datetime.datetime.now().date())
    date_object = datetime.datetime.strptime(q, '%Y-%m-%d')

    next_day = date_object + timedelta(days=1)


# Calculate previous day
    previous_day = date_object - timedelta(days=1)
    shifts=Shift.objects.all()
    machines=Asset.objects.filter(Q(assetTypes=2)|Q(assetCategory__id=8))
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
            mx_speed=0
            if(max_speed>0):
                mx_speed=(sum/max_speed)*100
            machines_with_amar.append({'machine':m.assetName,'shift_amar':shift_val,'sum':sum,'max_speed':"{:.2f} %".format(mx_speed)})
            print("sum_randeman",sum_randeman)
            if(index<len(machines)):
                sum_randeman+=mx_speed

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
        q=request.GET.get('date',datetime.datetime.now().date())
        q=request.GET.get('date',datetime.datetime.now().date())
        date_object = datetime.datetime.strptime(q, '%Y-%m-%d')
        next_day = date_object + timedelta(days=1)



    # Calculate previous day
        previous_day = date_object - timedelta(days=1)
        shifts=Shift.objects.all()
        machines=Asset.objects.filter(Q(assetTypes=2)|Q(assetCategory__id=8))
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
                natije=round(sum-tolid_standard.good_production_rate)
                machines_with_amar.append({'machine':m.assetName,'good':tolid_standard.good_production_rate,'mean':tolid_standard.mean_production_rate,
                'bad':tolid_standard.bad_production_rate,'real':sum,'kasre_tolid':natije})
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
        z=get_sum_vaz_zayeat_by_date(i[0])
        data.append({'title': "آمار روزانه",\
                'start': i[0],\
                 'color': '#53c797',\
                'id':i[0]})
        data.append({'title': "جمع ضایعات روز: {}".format(float(z)),\
                'start': i[0],\
                 'color': 'red',\
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
def list_nezafat_padash(request):
    formulas=NezafatPadash.objects.all()
    return render(request,"mrp/assetrandeman/nezafatPadashList.html",{'formulas':formulas,'title':'پاداش نظافت'})
def list_tolid_padash(request):
    formulas=TolidPadash.objects.all()
    return render(request,"mrp/assetrandeman/tolidPadashList.html",{'formulas':formulas,'title':'پاداش تولید'})
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
        product={}
        start=jdatetime.date(current_jalali_date.year,current_jalali_date.month,1)
        end=jdatetime.date(current_jalali_date.year,current_jalali_date.month,num_days)
        for sh in shift:
            product[sh.id]=get_monthly_machine_by_date_shift(cats,sh,start.togregorian(),end.togregorian())
        days.append({'cat':cats,'date':"",'day_of_week':'جمع','product':product})
        product={}
        for sh in shift:
            product[sh.id]=get_day_machine_failure_monthly_shift(cats,sh,start.togregorian(),end.togregorian())

        total_day_per_shift={}
        for sh in shift:
            total_day_per_shift[sh.id]=num_days-product[sh.id]
        days.append({'cat':cats,'date':"",'day_of_week':'روز کاری','product':total_day_per_shift})
        mean_day_per_shift={}
        for sh in shift:
            mean_day_per_shift[sh.id]=product[sh.id]/total_day_per_shift[sh.id]
        days.append({'cat':cats,'date':"",'day_of_week':'میانگین','product':mean_day_per_shift})


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
def get_sum_randeman(mah,sal):


    filtered_production = AssetRandemanPerMonth.objects.filter(
    mah=mah,sal=sal  # Filter by date range


    )
    # Calculate the sum of production_value
    sum_production_value = filtered_production.aggregate(
        total_production_value=models.Sum('tolid_value')
    )['total_production_value']

    if(not sum_production_value):
        return 0

    return sum_production_value
def get_monthly_workbook(request):
    my_dict = {
    1: 'اول',
    2: 'دوم',
    3:'سوم'
    # Add more key-value pairs as needed
}
    mah=request.GET.get("mah",False)
    sal=request.GET.get("sal",False)
    shift_list=Shift.objects.all()
    randeman_list=AssetRandemanPerMonth.objects.filter(mah=mah,sal=sal)
    d=[]
    for i in randeman_list:
        d.append({'operator_num':AssetRandemanInit.objects.get(asset_category=i.asset_category).operator_count,'randeman':i})
    k=[]
    for i in shift_list:
        randeman_list=AssetRandemanList.objects.get(mah=mah,sal=sal)
        nezafat_rank=NezafatRanking.objects.get(asset_randeman_list=randeman_list,shift=i).rank
        tolid_rank=TolidRanking.objects.get(asset_randeman_list=randeman_list,shift=i).rank
        padashe_nezafat_personel=NezafatPadash.objects.get(rank=nezafat_rank).price_personnel
        padashe_tolid_personel=TolidPadash.objects.get(rank=tolid_rank).price_personnel
        randeman_kol=get_sum_randeman_by_shift(mah,sal,i)
        sum=randeman_kol+padashe_nezafat_personel+padashe_tolid_personel
        k.append({'randeman_kol':randeman_kol,'shift':i,'nezafat_rank':my_dict[nezafat_rank],'tolid_rank':my_dict[tolid_rank],'padashe_nezafat':padashe_nezafat_personel,'padashe_tolid':padashe_tolid_personel,'sum':sum})

    return render(request,'mrp/assetrandeman/finalRandemanList.html',{'shift_list':shift_list,'randeman_list':d,'randeman_kol':k})
def get_monthly_sarshift_workbook(request):
        my_dict = {
        1: 'اول',
        2: 'دوم',
        3:'سوم'
        # Add more key-value pairs as needed
        }
        mah=request.GET.get("mah",False)
        sal=request.GET.get("sal",False)
        shift_list=Shift.objects.all()
        k=[]

        sum_shift_randeman_tolid=0
        sum_padashe_tolid_personel=0
        sum_padashe_nezafat_personel=0
        sum_sum=0
        randeman_tolid=get_sum_randeman(mah,sal)
        for i in shift_list:
            randeman_list=AssetRandemanList.objects.get(mah=mah,sal=sal)
            nezafat_rank=NezafatRanking.objects.get(asset_randeman_list=randeman_list,shift=i).rank
            tolid_rank=TolidRanking.objects.get(asset_randeman_list=randeman_list,shift=i).rank
            padashe_nezafat_personel=NezafatPadash.objects.get(rank=nezafat_rank).price_sarshift
            padashe_tolid_personel=TolidPadash.objects.get(rank=tolid_rank).price_sarshift
            randeman_kol=get_sum_randeman_by_shift(mah,sal,i)
            shift_randeman_tolid=(230000000*randeman_kol)/randeman_tolid
            sum_shift_randeman_tolid+=shift_randeman_tolid
            sum=randeman_kol+padashe_nezafat_personel+padashe_tolid_personel+shift_randeman_tolid
            sum_padashe_tolid_personel+=padashe_tolid_personel
            sum_padashe_nezafat_personel+=padashe_nezafat_personel
            k.append({'randeman_kol':randeman_kol,'shift':i,'nezafat_rank':my_dict[nezafat_rank],'tolid_rank':my_dict[tolid_rank],'padashe_nezafat':padashe_nezafat_personel,'padashe_tolid':padashe_tolid_personel,'sum':sum,'shift_randeman_tolid':shift_randeman_tolid,
            })

        sum_sum=randeman_tolid+sum_shift_randeman_tolid+sum_padashe_tolid_personel+sum_padashe_nezafat_personel
        return render(request,'mrp/assetrandeman/finalSarshiftRandemanList.html',{'title':'راندمان ماهانه سر شیفت ها','k':k,
        'randeman_tolid':randeman_tolid,'shift_randeman_tolid':shift_randeman_tolid,'sum_padashe_tolid_personel':sum_padashe_tolid_personel,'sum_padashe_nezafat_personel':sum_padashe_nezafat_personel,'sum_sum':sum_sum,'sum_shift_randeman_tolid':sum_shift_randeman_tolid})
def list_heatset_info(request):
        dayOfIssue=DateJob.getTaskDate(request.GET.get('event_id',False))
        date_object = datetime.datetime.strptime(str(dayOfIssue), '%Y-%m-%d')
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
                    saved_data = {
                        'metrajdaf1': amar.metrajdaf1,
                        'metrajdaf2': amar.metrajdaf2,
                        'metrajdaf3': amar.metrajdaf3,
                        'metrajdaf4': amar.metrajdaf4,
                        'metrajdaf5': amar.metrajdaf5,
                        'metrajdaf6': amar.metrajdaf6,
                        'metrajdaf7': amar.metrajdaf7,
                        'metrajdaf8': amar.metrajdaf8,

                        'makhraj_metraj_daf': amar.makhraj_metraj_daf,
                    }
                    metraj_val = [
                        amar.metrajdaf1,
                        amar.metrajdaf2,
                        amar.metrajdaf3,
                        amar.metrajdaf4,
                        amar.metrajdaf5,
                        amar.metrajdaf6,
                        amar.metrajdaf7,
                        amar.metrajdaf8,
                    ]
                    # metraj_val_with_default = {key: value if value is not None else 0 for key, value in metraj_val.items()}
                    metraj_val = [value if value is not None else 0 for value in metraj_val]
                    saved_data_with_default = {key: value if value is not None else 0 for key, value in saved_data.items()}

                    makhraj_value = amar.makhraj_metraj_daf
                    if(not makhraj_value or makhraj_value==0):
                        makhraj_value=1

                    total_metraj = sum(value if value is not None else 0 for value in metraj_val)

                    # Calculate the sum of makhraj values
                    total_val = total_metraj / makhraj_value
                    machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speedformula':speedformula.formula,'amar':amar,'shift':s,'metraj':saved_data_with_default,'total_val':total_val})
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
def list_amar_daily_info(request):

        data=dict()
        dayOfIssue=request.GET.get('event_id',datetime.datetime.now())
        date_object = DateJob.getTaskDate(dayOfIssue)

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
                    amar=DailyProduction.objects.get(machine=machine,dayOfIssue=date_object,shift=s)
                    machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speedformula':speedformula.formula,'amar':amar,'shift':s})

                    # else:
                    #     machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})


                except DailyProduction.DoesNotExist:


                        new_daily_production = DailyProduction(
                        machine=machine,
                        shift=s,
                        dayOfIssue=dayOfIssue,

                        speed=0,
                        nomre=0,
                        counter=0,
                        production_value=0,
                        daf_num=0,
                        dook_weight=0,
                        weight1=0,
                        weight2=0,
                        weight3=0,
                        weight4=0,
                        weight5=0,
                        net_weight=0,
                        metrajdaf1=0,
                        metrajdaf2=0,
                        metrajdaf3=0,
                        metrajdaf4=0,
                        metrajdaf5=0,
                        metrajdaf6=0,
                        metrajdaf7=0,
                        metrajdaf8=0,
                        makhraj_metraj_daf=1,
                        )

                        # Save the object to the database
                        # new_daily_production.save()

                        machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0,'amar':new_daily_production,'shift':s,'speedformula':speedformula.formula})
                except Formula.DoesNotExist:
                    machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0})
                except SpeedFormula.DoesNotExist:
                    machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0,'speedformula':0,'speedformula':speedformula.formula})
                except DailyProduction.DoesNotExist:
                    machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})


        data['html_heatset_result'] = render_to_string('mrp/tolid/partialAssetAmarList.html',{
            'machines':machines_with_formulas,
            'shifts':shift,'next_date':next_day.strftime('%Y-%m-%d'),'prev_date':previous_day.strftime('%Y-%m-%d'),'today':jdatetime.date.fromgregorian(date=date_object)}
        )

        # return render(request,"mrp/tolid/daily_details.html",{'machines':machines_with_formulas,'shifts':shift,'next_date':next_day.strftime('%Y-%m-%d'),'prev_date':previous_day.strftime('%Y-%m-%d'),'today':jdatetime.date.fromgregorian(date=date_object),'title':'آمار روزانه'})
        return JsonResponse(data)

#####################        heatset    ########################
def save_HeatsetMetraj_form(request, form, template_name):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():

            # Handle form submission
            # Access form.cleaned_data to get the values
            # Save the data or perform any necessary actions
            saved_data = {
                'metrajdaf1': form.cleaned_data['metrajdaf1'],
                'metrajdaf2': form.cleaned_data['metrajdaf2'],
                'metrajdaf3': form.cleaned_data['metrajdaf3'],
                'metrajdaf4': form.cleaned_data['metrajdaf4'],
                'metrajdaf5': form.cleaned_data['metrajdaf5'],
                'metrajdaf6': form.cleaned_data['metrajdaf6'],
                'metrajdaf7': form.cleaned_data['metrajdaf7'],
                'metrajdaf8': form.cleaned_data['metrajdaf8'],
                'makhraj_metraj_daf': form.cleaned_data['makhraj_metraj_daf'],
            }
            metraj_values = [
                form.cleaned_data['metrajdaf1'],
                form.cleaned_data['metrajdaf2'],
                form.cleaned_data['metrajdaf3'],
                form.cleaned_data['metrajdaf4'],
                form.cleaned_data['metrajdaf5'],
                form.cleaned_data['metrajdaf6'],
                form.cleaned_data['metrajdaf7'],
                form.cleaned_data['metrajdaf8'],
            ]
            makhraj_value = form.cleaned_data['makhraj_metraj_daf']
            total_metraj = sum(metraj_values)

            # Calculate the sum of makhraj values
            total_val = total_metraj / makhraj_value

            # Here you can perform additional actions, such as saving the data to the database

            # Return a JSON response with the saved data
            return JsonResponse({'success': True, 'data': saved_data,'form_is_valid':True,'total_val': total_val})
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form}


    data['html_heatsetmetraj_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
def tolid_heatset_metraj_create(request):
    if (request.method == 'POST'):
        form = HeatsetMetrajForm(request.POST)
        return save_HeatsetMetraj_form(request, form, 'mrp/tolid/partialHeatsetMetrajCreate.html')
    else:
        data_is_ok=False
        initial_data=None
        try:
            metraj_data=eval(json.loads(request.GET.get("data",False)))

            initial_data=metraj_data
            data_is_ok=True

        except  Exception as ex:
            # print(request.GET.get("data",False))
            print(ex)
            pass

        if(data_is_ok==False):
            initial_data = {'metrajdaf1': 0, 'metrajdaf2': 0, 'metrajdaf3': 0, 'metrajdaf4': 0,
                        'metrajdaf5': 0, 'metrajdaf6': 0, 'metrajdaf7': 0, 'metrajdaf8': 0,
                        'makhraj_metraj_daf': 1}
        form = HeatsetMetrajForm(initial=initial_data)



        return save_HeatsetMetraj_form(request, form, 'mrp/tolid/partialHeatsetMetrajCreate.html')
