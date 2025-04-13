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
from django.template.loader import render_to_string
from mrp.business.tolid_util import *
import datetime
from django.shortcuts import get_object_or_404
from django.core.exceptions import ValidationError
from rest_framework import generics
from mrp.models import BillOfMaterials
from mrp.serializers import BillOfMaterialsSerializer

def bom_create(request):
    return render(request,"mrp/bom/partialBOMCreate.html",{})
class BOMListView(generics.ListAPIView):
    serializer_class = BillOfMaterialsSerializer
    
    def get_queryset(self):
        return BillOfMaterials.objects.select_related('product')\
                                     .prefetch_related('bomcomponent_set__product', 
                                                     'bomcomponent_set__uom')\
                                     .order_by('reference')

