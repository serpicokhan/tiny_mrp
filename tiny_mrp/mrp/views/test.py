from django.shortcuts import render
from mrp.models import *
def index(request):
    machines=Asset.objects.filter(assetTypes=2)
    shift=Shift.objects.all()
    machines_with_formulas = []
    for machine in machines:
        try:
            speed=DailyProduction.objects.filter(machine=machine).last()
            formula = Formula.objects.get(machine=machine)
            if(speed):
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':speed.speed})
            else:
                machines_with_formulas.append({'machine': machine, 'formula': formula.formula,'speed':None})


        except Formula.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': None})
        except DailyProduction.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': None,'speed':None})

    return render(request,"mrp/tolid/details.html",{'machines':machines_with_formulas,'shifts':shift})
