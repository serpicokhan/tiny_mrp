from django.contrib import admin
from mrp.models import *
from .models import Tarh, Color, Asset, Size, DailySingleRecord

admin.site.register(Zayeat)
admin.site.register(ZayeatVaz)
admin.site.register(Asset)
admin.site.register(Failure)
admin.site.register(AssetFailure)

# Register your models here.
admin.site.register(Tarh)
admin.site.register(Color)
admin.site.register(Size)
admin.site.register(DailySingleRecord)
# Register your models here.
