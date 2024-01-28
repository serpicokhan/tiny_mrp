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
    url(r'^Dashboard$',list_dashboard,name='list_dashboard'),
    url(r'^Tolid/Heatset$',tolid_heatset,name='tolid_heatset'),
    url(r'^Tolid/Heatset/Metraj/Create$',tolid_heatset_metraj_create,name='tolid_heatset_metraj_create'),
    url(r'^Tolid/Daily$',show_daily_amar_tolid,name='show_daily_amar_tolid'),
    url(r'^Tolid/DailyDetails$',get_daily_amar,name='get_daily_amar'),
    url(r'^Tolid/DailyZayeat$',get_daily_zaye,name='get_daily_zaye'),
    url(r'^Tolid/Calendar$',calendar_main,name='calendar_main'),
    url(r'^Tolid/Randeman/Calendar$',calendar_randeman,name='calendar_randeman'),
    url(r'^Tolid/Tahlil/Calendar$',calendar_tahlil,name='calendar_tahlil'),
    url(r'^Tolid/DailyAnalyse$',show_daily_analyse_tolid,name='show_daily_analyse_tolid'),
    url(r'^Tolid/SaveTableInfo$',saveAmarTableInfo,name='saveAmarTableInfo'),
    url(r'^Tolid/SaveHTableInfo$',saveAmarHTableInfo,name='saveAmarHTableInfo'),
    url(r'^Tolid/GetInfo/$', get_tolid_calendar_info, name='get_tolid_calendar_info'),
    url(r'^Tolid/Randeman/GetInfo/$', get_randeman_calendar_info, name='get_randeman_calendar_info'),
    url(r'^Tolid/Tahlil/GetInfo/$', get_tahlil_calendar_info, name='get_tahlil_calendar_info'),
    url(r'^Shift/$', list_shifts, name='list_shifts'),
    url(r'^Formula/$', list_formula, name='list_formula'),
    url(r'^Tolid/Randeman/Init$', list_randeman_tolid, name='list_randeman_tolid'),
    url(r'^Tolid/Heatset/LoadInfo$', list_heatset_info, name='list_heatset_info'),
    url(r'^Tolid/Asset/LoadInfo$', list_amar_daily_info, name='list_amar_daily_info'),
    url(r'^SpeedFormula/$', list_speed_formula, name='list_speed_formula'),
    url(r'^Failures/$', list_failures, name='list_failures'),
    url(r'^Failures/Create$', failure_create, name='failure_create'),
    url(r'^Failures/(?P<id>\d+)/update$', failure_update, name='failure_update'),
    url(r'^Failures/(?P<id>\d+)/delete$', failure_delete, name='failure_delete'),
    url(r'^Monthly/$', monthly_detaild_report, name='monthly_detaild_report'),
    url(r'^Zayeat/Vazn/Create$', zayeatVazn_create, name='zayeatVazn_create'),
    url(r'^AssetFailure$', asset_failure_list, name='asset_failure_list'),
    url(r'^AssetFailure/calendar$', calendar_asset_failure, name='calendar_asset_failure'),
    url(r'^AssetFailure/Create$', assetFailure_create, name='assetFailure_create'),
    url(r'^AssetFailure/(?P<id>\d+)/delete$', assetFailure_delete, name='assetFailure_delete'),

    url(r'^AssetFailure/(?P<id>\d+)/update/$', assetFailure_update, name='assetFailure_update'),
    url(r'^AssetFailure/Monthly/$', monthly_detaild_failured_report, name='monthly_detaild_failured_report'),
    url(r'^AssetFailure/Daily/GetInfo/$', get_assetfailure_calendar_info, name='get_assetfailure_calendar_info'),
    url(r'^Asset/Randeman/$', asset_randeman_list, name='asset_randeman_list'),
    url(r'^Asset/Randeman/Create$', assetRandeman_create, name='assetRandeman_create'),
    url(r'^Asset/Randeman/(?P<id>\d+)/update/$', assetRandeman_update, name='assetRandeman_update'),
    url(r'^Asset/Randeman/(?P<id>\d+)/delete/$', assetRandeman_delete, name='assetRandeman_delete'),
    url(r'^Asset/Randeman/WorkBook/$', get_monthly_workbook, name='get_monthly_workbook'),
    url(r'^Asset/Randeman/Sarshift/WorkBook/$', get_monthly_sarshift_workbook, name='get_monthly_sarshift_workbook'),
    url(r'^Asset/Randeman/(?P<id>\d+)/NezafatRanking/$', assetRandeman_nezafat_ranking, name='assetRandeman_nezafat_ranking'),
    url(r'^Asset/Randeman/NezafatRanking/Create$', assetRandeman_ranking_create, name='assetRandeman_ranking_create'),
    url(r'^Asset/Randeman/TolidRanking/Create$', assetRandeman_tolid_ranking_create, name='assetRandeman_tolid_ranking_create'),
    url(r'^Asset/Randeman/(?P<id>\d+)/TolidRanking/$', assetRandeman_padash_ranking, name='assetRandeman_padash_ranking'),
    url(r'^Asset/Randeman/NezafatPadash/$', list_nezafat_padash, name='list_nezafat_padash'),
    url(r'^Asset/Randeman/TolidPadash/$', list_tolid_padash, name='list_tolid_padash'),
    url(r'^Dashboard/Zayeat/Line/$', get_line_zayeat_vazn_data, name='get_line_zayeat_vazn_data'),
    url(r'^Dashboard/Zayeat/Pie/$', get_pie_zayeat_vazn_data, name='get_pie_zayeat_vazn_data'),
    url(r'^Dashboard/AssetFailure/Line/$', assetFailure_duration_data, name='assetFailure_duration_data'),
    url(r'^Dashboard/AssetFailure/Pie/$', failure_pie_data, name='failure_pie_data'),
    url(r'^Dashboard/Zayeat/Monthly/$', current_year_vazn_data, name='current_year_vazn_data'),
    url(r'^Dashboard/Zayeat/StackedMonthly/$', monthly_vazn_by_zayeat_data, name='monthly_vazn_by_zayeat_data'),
    url(r'^Dashboard/AssetFailure/Monthly/$', jalali_monthly_duration_data, name='jalali_monthly_duration_data'),
    url(r'^Dashboard/AssetFailure/StackedMonthly/$', jalali_monthly_duration_by_failure_data, name='jalali_monthly_duration_by_failure_data'),





]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
