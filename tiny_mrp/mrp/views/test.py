from django.shortcuts import render
from mrp.models import *
def index(request):
    machines=Asset.objects.filter(assetTypes=2)
    machines_with_formulas = []
    for machine in machines:
        try:
            formula = Formula.objects.get(machine=machine)
            machines_with_formulas.append({'machine': machine, 'formula': formula.formula})
        except Formula.DoesNotExist:
            machines_with_formulas.append({'machine': machine, 'formula': None})

    return render(request,"mrp/tolid/details.html",{'machines':machines_with_formulas})
