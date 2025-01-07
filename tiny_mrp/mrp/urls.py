from django.conf.urls import url
from django.urls import path, include
from mrp.views import *
from . import views
from django.conf import settings
from django.contrib.auth.views import LoginView,LogoutView

from django.conf.urls.static import static
urlpatterns = [
    path(        'login/',        LoginView.as_view(            template_name="mrp/registration/login.html",            ),        name='login'),
    path(        'logout/',        LogoutView.as_view(            template_name="mrp/registration/logout.html",            ),        name='logout'),


    url(r'^$',index,name='index'),
    url(r'^Register/$',register_daily_amar,name='register_daily_amar'),
    url(r'^User/$',list_user,name='list_user'),
    url(r'^User/create/$', user_create, name='user_create'),
    url(r'^User/(?P<id>\d+)/update/$', user_update, name='user_update'),
    url(r'^User/(?P<id>\d+)/delete/$', user_delete, name='user_delete'),
    url(r'^Backup/$',backup_database,name='backup_database'),
    url(r'^Dashboard$',list_dashboard,name='list_dashboard'),
    url(r'^Tolid/Heatset$',tolid_heatset,name='tolid_heatset'),
    url(r'^Tolid/Heatset/Delete$',delete_heatset_info,name='delete_heatset_info'),
    url(r'^Tolid/Delete$',delete_amar_info,name='delete_amar_info'),
    url(r'^Tolid/Heatset/Metraj/Create$',tolid_heatset_metraj_create,name='tolid_heatset_metraj_create'),
    url(r'^Tolid/Daily$',show_daily_amar_tolid,name='show_daily_amar_tolid'),
    url(r'^Tolid/Daily/Brief$',show_daily_amar_tolid_brief,name='show_daily_amar_tolid_brief'),
    url(r'^Tolid/DailyDetails$',get_daily_amar,name='get_daily_amar'),
    url(r'^Tolid/DailyZayeat$',get_daily_zaye,name='get_daily_zaye'),
    url(r'^Tolid/Zayeat/Monthly$',monthly_zayeat_detaild_report,name='monthly_zayeat_detaild_report'),
    url(r'^Tolid/Zayeat/Export/Monthly$',export_monthly_zayeat,name='export_monthly_zayeat'),
    url(r'^Tolid/Calendar$',calendar_main,name='calendar_main'),
    url(r'^Tolid/Randeman/Calendar$',calendar_randeman,name='calendar_randeman'),
    url(r'^Tolid/Randeman/Brief/Calendar$',calendar_randeman_brief,name='calendar_randeman_brief'),
    url(r'^Tolid/Tahlil/Calendar$',calendar_tahlil,name='calendar_tahlil'),
    url(r'^Tolid/DailyAnalyse$',show_daily_analyse_tolid,name='show_daily_analyse_tolid'),
    url(r'^Tolid/SaveTableInfo$',saveAmarTableInfo,name='saveAmarTableInfo'),
    url(r'^Tolid/SaveHTableInfo$',saveAmarHTableInfo,name='saveAmarHTableInfo'),
    url(r'^Tolid/GetInfo/$', get_tolid_calendar_info, name='get_tolid_calendar_info'),
    url(r'^Tolid/Move/$', move_tolid_calendar_info, name='move_tolid_calendar_info'),
    url(r'^Tolid/Randeman/GetInfo/$', get_randeman_calendar_info, name='get_randeman_calendar_info'),
    url(r'^Tolid/Tahlil/GetInfo/$', get_tahlil_calendar_info, name='get_tahlil_calendar_info'),
    url(r'^Shift/$', list_shifts, name='list_shifts'),
    url(r'^Shift/(?P<id>\d+)/update/$', shift_update, name='shift_update'),

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
    url(r'^Monthly/Ezami$', monthly_detaild_report_ezami, name='monthly_detaild_report_ezami'),
    url(r'^Monthly/Brief$', monthly_brief_report, name='monthly_brief_report'),
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
    url(r'^Asset/Randeman/Sarshift/Workprofile/$', get_monthly_sarshift_workbook, name='get_monthly_sarshift_workbook'),
    url(r'^Asset/Randeman/(?P<id>\d+)/NezafatRanking/$', assetRandeman_nezafat_ranking, name='assetRandeman_nezafat_ranking'),
    url(r'^Asset/Randeman/NezafatRanking/Create$', assetRandeman_ranking_create, name='assetRandeman_ranking_create'),
    url(r'^Asset/Randeman/NezafatRanking/calc_assetRandeman_nezafat_ranking$', calc_assetRandeman_nezafat_ranking, name='calc_assetRandeman_nezafat_ranking'),
    url(r'^Asset/Randeman/NezafatRanking/calc_assetRandeman_tolid_ranking$', calc_assetRandeman_tolid_ranking, name='calc_assetRandeman_tolid_ranking'),
    url(r'^Asset/Randeman/TolidRanking/Create$', assetRandeman_tolid_ranking_create, name='assetRandeman_tolid_ranking_create'),
    url(r'^Asset/Randeman/(?P<id>\d+)/TolidRanking/$', assetRandeman_padash_ranking, name='assetRandeman_padash_ranking'),
    url(r'^Asset/Randeman/NezafatPadash/$', list_nezafat_padash, name='list_nezafat_padash'),
    url(r'^Asset/Randeman/TolidPadash/$', list_tolid_padash, name='list_tolid_padash'),
    url(r'^Asset/Randeman/InitRandeman/$', get_init_asset_randeman, name='get_init_asset_randeman'),
    url(r'^Asset/Randeman/InitRandeman/(?P<id>\d+)/update$', assetrandemaninit_update, name='assetrandemaninit_update'),
    url(r'^Asset/Randeman/InitRandeman/(?P<id>\d+)/Partial/update$', assetrandemaninit_partial_update, name='assetrandemaninit_partial_update'),
    url(r'^Asset/Randeman/TolidPadash/(?P<id>\d+)/update$', tolidPadash_update, name='tolidPadash_update'),
    url(r'^Asset/Randeman/NezafatPadash/(?P<id>\d+)/update$', nezafatPadash_update, name='nezafatPadash_update'),

    url(r'^Dashboard/Zayeat/Line/$', get_line_zayeat_vazn_data, name='get_line_zayeat_vazn_data'),
    url(r'^Dashboard/Zayeat/Pie/$', get_pie_zayeat_vazn_data, name='get_pie_zayeat_vazn_data'),
    url(r'^Dashboard/AssetFailure/Line/$', assetFailure_duration_data, name='assetFailure_duration_data'),
    url(r'^Dashboard/Asset/Production/Line/$', get_line_tolid_vazn_data, name='get_line_tolid_vazn_data'),
    url(r'^Dashboard/Asset/Production/Daily/Bar/$', production_chart, name='production_chart'),
    url(r'^Dashboard/Asset/Production/Daily/Bar2/$', production_chart2, name='production_chart2'),
    url(r'^Dashboard/Asset/Production/Daily/Bar/List/$', production_chart_with_table, name='production_chart_with_table'),
    url(r'^Dashboard/AssetFailure/Pie/$', failure_pie_data, name='failure_pie_data'),
    url(r'^Dashboard/AssetFailure/Monthly/$', jalali_monthly_duration_data, name='jalali_monthly_duration_data'),
    url(r'^Dashboard/Production/Monthly/$', jalali_monthly_production_data, name='jalali_monthly_production_data'),
    url(r'^Dashboard/AssetFailure/StackedMonthly/$', jalali_monthly_duration_by_failure_data, name='jalali_monthly_duration_by_failure_data'),
    url(r'^Dashboard/Tab/CurrentMonth/Production/Daily/$', get_monthly_production_data, name='get_monthly_production_data'),
    url(r'^Dashboard/Card/Info/$', get_dashboard_production_sum, name='get_dashboard_production_sum'),
    url(r'^profile/$', profile_list, name='profile_list'),
    url(r'^profile/create/$', profile_create, name='profile_create'),
    url(r'^profile/(?P<pk>\d+)/update/$', profile_update, name='profile_update'),
    url(r'^profile/(?P<pk>\d+)/delete/$', profile_delete, name='profile_delete'),
    url(r'^Report/$', daily_tolid_with_chart, name='daily_tolid_with_chart'),
    url(r'^Purchase/$', list_purchase, name='list_purchase'),
    url(r'^Purchase/Dash$', purchase_dash, name='purchase_dash'),

    url(r'^Purchase/Create$', create_purchase, name='create_purchase'),
    url(r'^Purchase/(?P<id>\d+)/Update$', update_purchase, name='update_purchase'),
    url(r'^Purchase/(?P<id>\d+)/Update2$', update_purchase_v2, name='update_purchase_v2'),
    url(r'^Purchases/$', list_purchase_req, name='list_purchase_req'),
    url(r'^Purchases/All$', list_purchase_req_detail, name='list_purchase_req_detail'),
    url(r'^Purchases/(?P<id>\d+)/Confirm$', confirm_request, name='confirm_request'),
    url(r'^Purchases/(?P<id>\d+)/Reject$', reject_request, name='reject_request'),
    url(r'^WoPart/GetParts$', wo_getParts, name='wo_getParts'),
    url(r'^Asset/GetAssets$', asset_getAssets2, name='asset_getAssets2'),
    url(r'^api/create-part/$', create_part, name="create_part"),
    url(r'^api/create-asset/$', create_asset2, name="create_asset2"),
    url(r'^api/save-purchase-request/', views.save_purchase_request, name='save-purchase-request'),
    





]+ static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
