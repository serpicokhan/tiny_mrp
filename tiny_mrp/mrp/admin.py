from django.contrib import admin
from mrp.models import *
admin.site.register(Zayeat)
admin.site.register(ZayeatVaz)
admin.site.register(Asset)
admin.site.register(Failure)
admin.site.register(AssetFailure)
admin.site.register(Color)
admin.site.register(AssetCategory2)
admin.site.register(EntryForm)

# Register your models here.

admin.site.site_header = "سیستم مدیریت تولید شرکت آرایا ریس مهستان قم"
admin.site.site_title = "مدیریت تولید دایانا"
admin.site.index_title = "خوش آمدید"