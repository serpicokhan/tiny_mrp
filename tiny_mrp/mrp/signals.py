from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.utils import timezone
from mrp.serializers import serialize_daily_production
from mrp.models import DailyProduction,DailyProductionLog
from .middleware import get_current_user
# def get_previous_data(instance):
#     """دریافت داده‌های قبلی"""
#     if hasattr(instance, '_old_instance') and instance._old_instance:
#         return serialize_daily_production(instance._old_instance)
#     return None

# def get_changed_fields(instance):
#     """دریافت فیلدهای تغییر کرده"""
#     changed_fields = []
#     if hasattr(instance, '_old_instance') and instance._old_instance:
#         old_instance = instance._old_instance
#         fields = [
#             'speed', 'nomre', 'counter1', 'counter2', 'vahed', 
#             'production_value', 'wastage_value', 'enzebat_value', 'qc_value'
#         ]
        
#         for field in fields:
#             old_value = getattr(old_instance, field)
#             new_value = getattr(instance, field)
#             if old_value != new_value:
#                 changed_fields.append(field)
    
#     return changed_fields
# @receiver(post_save, sender=DailyProduction)
# def log_daily_production_save(sender, instance, created, **kwargs):
#     """
#     ثبت لاگ هنگام ایجاد یا ویرایش رکورد
#     """
#     # ایمپورت داخل تابع برای جلوگیری از circular import
    
#     action = 'create' if created else 'update'
    
#     # گرفتن کاربر فعلی
#     current_user = get_current_user()
#     username = 'System'
    
#     if current_user and current_user.is_authenticated:
#         username = current_user.username
#     elif hasattr(instance, 'register_user') and instance.register_user:
#         username = instance.register_user
    
#     # برای استفاده از request در سیگنال‌ها می‌توانید از middleware استفاده کنید
#     # یا کاربر را از context بگیرید
    
#     # آماده‌سازی داده‌ها
#     if created:
#         old_data = None
#         new_data = serialize_daily_production(instance)
#         changed_fields = list(new_data.keys())
#     else:
#         old_data = get_previous_data(instance)
#         new_data = serialize_daily_production(instance)
#         changed_fields = get_changed_fields(instance)
    
#     # ایجاد لاگ
#     # DailyProductionLog.objects.create(
#     #     daily_production=instance,
#     #     action=action,
#     #     changed_by=username,
#     #     old_data=old_data,
#     #     new_data=new_data,
#     #     changed_fields=changed_fields
#     # )

@receiver(post_delete, sender=DailyProduction)
def log_daily_production_delete(sender, instance, **kwargs):
    """
    ثبت لاگ هنگام حذف رکورد
    """
    from .models import DailyProductionLog
    
    # DailyProductionLog.objects.create(
    #     daily_production=None,
    #     action='delete',
    #     changed_by='System',
    #     old_data=serialize_daily_production(instance),
    #     new_data=None,
    #     changed_fields=['delete']
    # )
