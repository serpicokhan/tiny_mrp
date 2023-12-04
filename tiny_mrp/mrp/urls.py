from django.conf.urls import url
from django.urls import path, include
from mrp.views import *
from . import views
from django.conf import settings
from django.conf.urls.static import static
urlpatterns = [
    url(r'^$',index,name='index'),
    url(r'^Tolid/SaveTableInfo$',saveAmarTableInfo,name='saveAmarTableInfo'),



]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
