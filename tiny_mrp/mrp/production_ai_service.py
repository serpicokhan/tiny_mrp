# production_ai_service.py
from .openrouter_service import OpenRouterService
from .models import DailyProduction, Asset
from datetime import date, timedelta
import json

class ProductionAIService:
    @staticmethod
    def generate_production_response(user_question, user_id=None):
        print("here!")
        # استخراج داده‌های واقعی از دیتابیس
        context_data = ProductionAIService.get_production_context()
        
        # ساخت پرمپت هوشمند
        prompt = ProductionAIService.build_smart_prompt(user_question, context_data)
        
        # ارسال به OpenRouter + Gemini
        response = OpenRouterService.generate_response(prompt)
        
        return response
    
    @staticmethod
    def get_production_context():
        """دریافت داده‌های تولید از دیتابیس"""
        today = date.today()
        yesterday = today - timedelta(days=1)
        
        # داده‌های امروز
        today_production = DailyProduction.objects.filter(dayOfIssue=today)
        yesterday_production = DailyProduction.objects.filter(dayOfIssue=yesterday)
        
        context = {
            "today": {
                "total_units": sum(p.production_value or 0 for p in today_production),
                "total_wastage": sum(p.wastage_value or 0 for p in today_production),
                "machine_count": today_production.values('machine').distinct().count(),
                "records_count": today_production.count()
            },
            "yesterday": {
                "total_units": sum(p.production_value or 0 for p in yesterday_production),
                "total_wastage": sum(p.wastage_value or 0 for p in yesterday_production)
            },
            "machines_status": ProductionAIService.get_machines_status(today),
            "recent_trends": ProductionAIService.get_recent_trends()
        }
        
        return json.dumps(context, ensure_ascii=False, indent=2)
    
    @staticmethod
    def get_machines_status(target_date):
        """وضعیت ماشین‌آلات"""
        machines = Asset.objects.all()
        status = {}
        
        for machine in machines:
            production = DailyProduction.objects.filter(
                machine=machine, 
                dayOfIssue=target_date
            ).first()
            
            if production:
                status[machine.assetName] = {
                    "status": "active" if production.production_value > 0 else "idle",
                    "production": production.production_value or 0,
                    "wastage": production.wastage_value or 0
                }
            else:
                status[machine.assetName] = {
                    "status": "inactive",
                    "production": 0,
                    "wastage": 0
                }
        
        return status
    
    @staticmethod
    def get_recent_trends(days=7):
        """روند تولید ۷ روز گذشته"""
        trends = []
        for i in range(days):
            day = date.today() - timedelta(days=i)
            production = DailyProduction.objects.filter(dayOfIssue=day)
            total = sum(p.production_value or 0 for p in production)
            trends.append({"date": day.isoformat(), "production": total})
        
        return trends
    
    @staticmethod
    def build_smart_prompt(user_question, context_data):
        """ساخت پرمپت هوشمند برای Gemini"""
        
        prompt = f"""
        # نقش: دستیار هوشمند مدیریت تولید
        # زمینه: سیستم مدیریت یک کارخانه تولیدی
        
        ## داده‌های واقعی سیستم:
        {context_data}
        
        ## سوال کاربر:
        {user_question}
        
        ## دستورالعمل‌های پاسخ‌دهی:
        1. پاسخ باید کاملاً به زبان فارسی باشد
        2. از فرمت HTML برای زیبایی استفاده کن
        3. از تگ‌های زیر استفاده کن:
           - <div class="kpi-card"> برای اعداد مهم
           - <table> برای داده‌های جدولی  
           - <ul> و <li> برای لیست‌ها
           - <strong> برای تأکید
        4. اگر سوال مربوط به داده‌ای است که موجود نیست، صادقانه بگو
        5. پیشنهادات عملی برای بهبود ارائه ده
        
        ## نمونه پاسخ خوب:
        <div class="kpi-card">
            <strong>تولید امروز:</strong> ۱,۲۵۰ واحد
        </div>
        <p>این مقدار نسبت به دیروز <strong>۵٪ افزایش</strong> داشته است.</p>
        
        پاسخ:
        """
        
        return prompt