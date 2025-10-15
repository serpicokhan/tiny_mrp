from django.conf.urls import url
from django.urls import path, include
from automation.views import *
from django.conf import settings
from django.contrib.auth.views import LoginView,LogoutView

from django.conf.urls.static import static
# handler404 = custom_404

urlpatterns = [
    url(r'^List/$', mail_list, name='mail_list'),
   
]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)