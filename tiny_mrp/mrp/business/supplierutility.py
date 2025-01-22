from mrp.models import Supplier
import jdatetime
import datetime
import json
from django.core.paginator import *
from django.db.models import Count
from django.db.models import Q
# from cmms.business.AssetUtility import AssetUtility
import json

class PartUtility:
    @staticmethod
    def getSupplier(searchStr):
        qstr=searchStr
        result=Supplier.objects.all()

        for q in searchStr:
            result = result.filter(Q(name__icontains=qstr)|Q(phone__icontains=qstr)).order_by('-id').values('id', 'name')
        # res= Part.objects.filter(partName__isnull=False).filter(partName__icontains=searchStr)
        result=result.extra(select={'length':'Length(name)'}).order_by('length').values('id', 'name')[:10]

        return result