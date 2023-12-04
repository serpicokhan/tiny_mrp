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
            # print(i)
            # print(i)
            # print("********")
            amar=DailyProduction()
            # amar.shift=i["shift"]
            amar.machine=Asset.objects.get(id=int(i["machine"]))
            amar.shift=Shift.objects.get(id=int(i["shift"]))
            amar.dayOfIssue=DateJob.getTaskDate(i["dayOfIssue"].replace('/','-'))
            amar.speed=i["speed"]
            amar.nomre=i["nomre"]
            amar.counter=i["counter"]
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
    for m in machines:
        shift_val=[]
        for i in shifts:
            try:
                amar=DailyProduction.objects.get(machine=m,shift=i,dayOfIssue=q)
                shift_val.append({'value':amar.production_value,'shift':i})
            except:
                pass
        machines_with_amar.append({'machine':m,'shift_amar':shift_val})

    return render(request,'mrp/tolid/daily_amar_tolid.html',{'shift':shifts,'machines_with_amar':machines_with_amar})