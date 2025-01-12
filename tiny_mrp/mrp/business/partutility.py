from mrp.models import *
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
    def getParts(searchStr):
        qstr=searchStr
        result=Part.objects.all()

        for q in searchStr:
            result = result.filter(Q(partName__icontains=qstr)|Q(partCode__icontains=qstr)|Q(partCategory__name__icontains=qstr)).order_by('-id').values('id', 'partName')
        # res= Part.objects.filter(partName__isnull=False).filter(partName__icontains=searchStr)
        result=result.extra(select={'length':'Length(partName)'}).order_by('length').values('id', 'partName','partCode')[:10]

        return result
