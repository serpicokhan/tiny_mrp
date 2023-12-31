from django.conf.urls import url
from django.urls import path, include
from mrp.views import *
from . import views
from django.conf import settings
from django.contrib.auth.views import LoginView,LogoutView

from django.conf.urls.static import static
urlpatterns = [
    path(        'login/',        LoginView.as_view(            template_name="mrp/registration/login.html",            ),        name='login'),
    path(        'logout/',        LoginView.as_view(            template_name="mrp/registration/logout.html",            ),        name='logout'),


    url(r'^$',index,name='index'),
    url(r'^Tolid/Daily$',show_daily_amar_tolid,name='show_daily_amar_tolid'),
    url(r'^Tolid/DailyDetails$',get_daily_amar,name='get_daily_amar'),
    url(r'^Tolid/Calendar$',calendar_main,name='calendar_main'),
    url(r'^Tolid/Randeman/Calendar$',calendar_randeman,name='calendar_randeman'),
    url(r'^Tolid/Tahlil/Calendar$',calendar_tahlil,name='calendar_tahlil'),
    url(r'^Tolid/DailyAnalyse$',show_daily_analyse_tolid,name='show_daily_analyse_tolid'),
    url(r'^Tolid/SaveTableInfo$',saveAmarTableInfo,name='saveAmarTableInfo'),
    url(r'^Tolid/GetInfo/$', get_tolid_calendar_info, name='get_tolid_calendar_info'),
    url(r'^Tolid/Randeman/GetInfo/$', get_randeman_calendar_info, name='get_randeman_calendar_info'),
    url(r'^Tolid/Tahlil/GetInfo/$', get_tahlil_calendar_info, name='get_tahlil_calendar_info'),
    url(r'^Shift/$', list_shifts, name='list_shifts'),
    url(r'^Formula/$', list_formula, name='list_formula'),
    url(r'^Tolid/Randeman/Init$', list_randeman_tolid, name='list_randeman_tolid'),
    url(r'^SpeedFormula/$', list_speed_formula, name='list_speed_formula'),
    url(r'^Failures/$', list_failures, name='list_failures'),
    url(r'^Monthly/$', monthly_detaild_report, name='monthly_detaild_report'),
    url(r'^Zayeat/Vazn/Create$', zayeatVazn_create, name='zayeatVazn_create'),
    url(r'^AssetFailure$', asset_failure_list, name='asset_failure_list'),
    url(r'^AssetFailure/calendar$', calendar_asset_failure, name='calendar_asset_failure'),
    url(r'^AssetFailure/Create$', assetFailure_create, name='assetFailure_create'),
    url(r'^AssetFailure/(?P<id>\d+)/update/$', assetFailure_update, name='assetFailure_update'),
    url(r'^AssetFailure/Monthly/$', monthly_detaild_failured_report, name='monthly_detaild_failured_report'),
    url(r'^AssetFailure/Daily/GetInfo/$', get_assetfailure_calendar_info, name='get_assetfailure_calendar_info'),
    url(r'^Asset/Randeman/$', asset_randeman_list, name='asset_randeman_list'),
    url(r'^Asset/Randeman/Create$', assetRandeman_create, name='assetRandeman_create'),
    url(r'^Asset/Randeman/(?P<id>\d+)/update/$', assetRandeman_update, name='assetRandeman_update'),
    url(r'^Asset/Randeman/(?P<id>\d+)/delete/$', assetRandeman_delete, name='assetRandeman_delete'),




]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
