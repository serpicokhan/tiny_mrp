from mrp.models import *
import jdatetime
import datetime
import json
from django.core.paginator import *
from django.db.models import Count
from django.db.models import Q
# from cmms.business.AssetUtility import AssetUtility
import json

class AssetUtility:
    @staticmethod
    def getAssets(searchStr):
        result=Asset.objects.all()
        qstr=searchStr
        # for qstr in q:
        if(qstr.isdigit()):
             result = result.filter(Q(assetName__icontains=qstr)|Q(assetCode__icontains=qstr)|Q(id=int(qstr))|Q(assetCategory__name__icontains=qstr)).order_by('assetName')
        else:
            result= result.filter(Q(assetName__icontains=qstr)|Q(assetCode__icontains=qstr)
                               |Q(assetCategory__name__icontains=qstr)).order_by('assetName')
        # (Q(assetName__icontains=qstr)|Q(assetCode__icontains=qstr)|Q(assetCategory__name__icontains=qstr))).order_by('-id')
        result=result.extra(select={'length':'Length(assetName)'}).order_by('length').values('id', 'assetName','assetCode')[:10]
        return result