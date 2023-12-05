from django.shortcuts import render
from mrp.models import *
import jdatetime
from django.db import IntegrityError
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import JsonResponse
from mrp.business.DateJob import *

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
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':speed.speed,'nomre':speed.nomre,'speedformula':speedformula.formula})
            else:
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})


        except Formula.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0})
        except SpeedFormula.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': None,'formula': 0,'speed':0,'nomre':0,'speedformula':0})
        except DailyProduction.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':0,'nomre':0,'speedformula':speedformula.formula})

    return render(request,"mrp/tolid/details.html",{'machines':machines_with_formulas,'shifts':shift})
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
def show_daily_amar_tolid(request):
    q=request.GET.get('date',datetime.datetime.now().date())
    shifts=Shift.objects.all()
    machines=Asset.objects.filter(assetTypes=2)
    machines_with_amar=[]
    if(q):
        for m in machines:
            shift_val=[]
            sum=0
            max_speed=0
            for i in shifts:
                try:


                    amar=DailyProduction.objects.filter(machine=m,shift=i,dayOfIssue=q)[0]
                    shift_val.append({'value':amar.production_value,'shift':i})
                    sum+=amar.production_value
                    max_speed=amar.eval_max_tolid()

                except Exception as e:
                    print(e)
                    shift_val.append({'value':0,'shift':i})

            machines_with_amar.append({'machine':m,'shift_amar':shift_val,'sum':sum,'max_speed':"{:.2f} %".format((sum/max_speed)*100)})

    return render(request,'mrp/tolid/daily_amar_tolid.html',{'shift':shifts,'machines_with_amar':machines_with_amar})
def show_daily_analyse_tolid(request):
        q=request.GET.get('date',datetime.datetime.now().date())
        shifts=Shift.objects.all()
        machines=Asset.objects.filter(assetTypes=2)
        machines_with_amar=[]
        if(q):
            for m in machines:
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

                machines_with_amar.append({'machine':m,'good':tolid_standard.good_production_rate,'mean':tolid_standard.mean_production_rate,
                'bad':tolid_standard.bad_production_rate,'real':sum,'kasre_tolid':sum-tolid_standard.good_production_rate})

        return render(request,'mrp/tolid/daily_analyse_tolid.html',{'machines_with_amar':machines_with_amar})
def calendar_main(request):
    return render(request,'mrp/tolid/calendar_main.html',{})
