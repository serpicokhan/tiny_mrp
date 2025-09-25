from django.http import JsonResponse
from django.views import View
from mrp.models import AssetCategory, Asset, DailyProduction, EntryForm
from django.db.models import Sum, Avg  # For aggregates
from django.shortcuts import render,redirect, get_object_or_404
from django.db.models import Sum, Avg, Min, Max, Count
from jdatetime import datetime as jdatetime
from datetime import datetime

def graph_index(request):
    return render(request,'mrp/graph/index.html',{'title':'گراف سفارشات'})





class ProductionGraphDataView(View):
    def get(self, request):
        moshakhase_id = request.GET.get('moshakhase_id')
        if not moshakhase_id:
            return JsonResponse({'error': 'moshakhase_id required'}, status=400)
        
        try:
            moshakhase = EntryForm.objects.get(id=moshakhase_id)
        except EntryForm.DoesNotExist:
            return JsonResponse({'error': 'Invalid moshakhase_id'}, status=404)
        
        root_categories = AssetCategory.objects.filter(isPartOf__isnull=True).order_by('priority')
        
        def build_category_data(category):
            machines = category.assetcategory_main.all()
            productions = DailyProduction.objects.filter(
                machine__in=machines,
                moshakhase=moshakhase
            ).aggregate(
                total_production=Sum('production_value'),
                avg_speed=Avg('speed'),
                total_wastage=Sum('wastage_value'),
                first_day=Min('dayOfIssue'),
                last_day=Max('dayOfIssue'),
                first_timestamp=Min('timestamp'),
                last_timestamp=Max('timestamp'),
                distinct_days=Count('dayOfIssue', distinct=True)
            )
            if productions['total_production'] and productions['total_production'] != 0:
                # Convert to Jalali
                def to_jalali(dt):
                    if dt:
                        g_dt = datetime.combine(dt, datetime.min.time()) if hasattr(dt, 'date') else dt
                        j_dt = jdatetime.fromgregorian(datetime=g_dt)
                        return j_dt.strftime('%Y/%m/%d')
                    return 'نامشخص'
                
                def to_jalali_full(dt):
                    if dt:
                        j_dt = jdatetime.fromgregorian(datetime=dt)
                        return j_dt.strftime('%Y/%m/%d %H:%M:%S')
                    return 'نامشخص'
                
                # Build machine data
                machine_data = []
                for machine in machines:
                    machine_productions = DailyProduction.objects.filter(
                        machine=machine,
                        moshakhase=moshakhase
                    ).aggregate(
                        total_production=Sum('production_value'),
                        avg_speed=Avg('speed'),
                        total_wastage=Sum('wastage_value'),
                        first_day=Min('dayOfIssue'),
                        last_day=Max('dayOfIssue'),
                        first_timestamp=Min('timestamp'),
                        last_timestamp=Max('timestamp'),
                        distinct_days=Count('dayOfIssue', distinct=True)
                    )
                    if machine_productions['total_production'] and machine_productions['total_production'] != 0:
                        machine_data.append({
                            'name': machine.assetName,
                            'productionInfo': {
                                'production': f"{float(machine_productions['total_production'] or 0):.2f} کیلوگرم",
                                'speed': f"{float(machine_productions['avg_speed'] or 0):.2f} متر/دقیقه",
                                'wastage': f"{float(machine_productions['total_wastage'] or 0):.2f} کیلوگرم",
                                'first_day': to_jalali(machine_productions['first_day']),
                                'last_day': to_jalali(machine_productions['last_day']),
                                'first_timestamp': to_jalali_full(machine_productions['first_timestamp']),
                                'last_timestamp': to_jalali_full(machine_productions['last_timestamp']),
                                'distinct_days': machine_productions['distinct_days']
                            }
                        })
                
                return {
                    'name': category.name,
                    'code': category.code,
                    'priority': category.priority,
                    'productionInfo': {
                        'production': f"{float(productions['total_production'] or 0):.2f} کیلوگرم",
                        'speed': f"{float(productions['avg_speed'] or 0):.2f} متر/دقیقه",
                        'wastage': f"{float(productions['total_wastage'] or 0):.2f} کیلوگرم",
                        'first_day': to_jalali(productions['first_day']),
                        'last_day': to_jalali(productions['last_day']),
                        'first_timestamp': to_jalali_full(productions['first_timestamp']),
                        'last_timestamp': to_jalali_full(productions['last_timestamp']),
                        'distinct_days': productions['distinct_days']
                    },
                    'children': machine_data
                }
            return None
        
        category_data = [build_category_data(cat) for cat in root_categories]
        category_data = [cat for cat in category_data if cat is not None]
        
        # Root node aggregation
        total_production = sum(float(cat['productionInfo']['production'].split()[0]) for cat in category_data)
        total_wastage = sum(float(cat['productionInfo']['wastage'].split()[0]) for cat in category_data)
        all_productions = DailyProduction.objects.filter(
            machine__assetCategory__in=root_categories,
            moshakhase=moshakhase
        ).aggregate(
            first_day=Min('dayOfIssue'),
            last_day=Max('dayOfIssue'),
            first_timestamp=Min('timestamp'),
            last_timestamp=Max('timestamp'),
            distinct_days=Count('dayOfIssue', distinct=True)
        )
        
        def to_jalali(dt):
            if dt:
                g_dt = datetime.combine(dt, datetime.min.time()) if hasattr(dt, 'date') else dt
                j_dt = jdatetime.fromgregorian(datetime=g_dt)
                return j_dt.strftime('%Y/%m/%d')
            return 'نامشخص'
        
        def to_jalali_full(dt):
            if dt:
                j_dt = jdatetime.fromgregorian(datetime=dt)
                return j_dt.strftime('%Y/%m/%d %H:%M:%S')
            return 'نامشخص'
        
        return JsonResponse({
            'moshakhase': str(moshakhase),
            'data': {
                'name': 'خط ریسندگی',
                'productionInfo': {
                    'production': f"{total_production:.2f} کیلوگرم",
                    'speed': 'N/A',
                    'wastage': f"{total_wastage:.2f} کیلوگرم",
                    'first_day': to_jalali(all_productions['first_day']),
                    'last_day': to_jalali(all_productions['last_day']),
                    'first_timestamp': to_jalali_full(all_productions['first_timestamp']),
                    'last_timestamp': to_jalali_full(all_productions['last_timestamp']),
                    'distinct_days': all_productions['distinct_days']
                },
                'children': category_data
            }
        })