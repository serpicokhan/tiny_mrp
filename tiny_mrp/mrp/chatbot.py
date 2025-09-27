# در views.py
import re
from datetime import datetime, timedelta
from dateutil import parser
from mrp.models import DailyProduction
import openai

class QuestionClassifier:
    @staticmethod
    def classify_question(message):
        message = message.lower()
        
        # الگوهای مختلف سوالات
        patterns = {
            'today_production': r'(تولید امروز|امروز چطور|امروز چه مقدار)',
            'date_range_production': r'(تولید از|تولید بین|از تاریخ|تا تاریخ|از.*تا)',
            'last_n_days': r'(\d+)\s*روز\s*گذشته|(\d+)\s*روز\s*اخیر|تولید\s*(\d+)\s*روز',
            'machine_status': r'(وضعیت ماشین|ماشین‌ها|خطوط تولید)',
            'comparison': r'(مقایسه|مقایسه کنید|بهترین|بدترین)',
            'trend': r'(روند|تغییرات|گراف|نمودار)',
            'problems': r'(مشکل|خطا|خرابی|ایراد)'
        }
        
        # استخراج پارامترها
        params = {}
        
        # تشخیص بازه زمانی
        date_range = QuestionClassifier.extract_date_range(message)
        if date_range:
            params['date_range'] = date_range
        
        # تشخیص تعداد روز
        days_match = re.search(r'(\d+)\s*روز', message)
        if days_match:
            params['days'] = int(days_match.group(1))
        
        # تشخیص نام ماشین
        machine_match = re.search(r'(خط\s+[آ-ی]+|ماشین\s+[آ-ی]+)', message)
        if machine_match:
            params['machine'] = machine_match.group(1)
        
        # تشخیص نوع سوال
        for question_type, pattern in patterns.items():
            if re.search(pattern, message):
                return question_type, params
        
        return 'general', params
    
    @staticmethod
    def extract_date_range(message):
        # استخراج تاریخ از متن
        date_patterns = [
            r'از\s+(\d+\/\d+\/\d+)\s+تا\s+(\d+\/\d+\/\d+)',
            r'بین\s+(\d+\/\d+\/\d+)\s+و\s+(\d+\/\d+\/\d+)',
            r'from\s+(\d+\-\d+\-\d+)\s+to\s+(\d+\-\d+\-\d+)',  # برای تاریخ انگلیسی
        ]
        
        for pattern in date_patterns:
            match = re.search(pattern, message)
            if match:
                try:
                    start_date = parser.parse(match.group(1), dayfirst=True).date()
                    end_date = parser.parse(match.group(2), dayfirst=True).date()
                    return {'start_date': start_date, 'end_date': end_date}
                except:
                    continue
        
        return None
    
class ProductionDataHandler:
    @staticmethod
    def get_today_production():
        today = datetime.date.today()
        return DailyProduction.objects.filter(dayOfIssue=today)
    
    @staticmethod
    def get_last_n_days_production(days):
        end_date = datetime.date.today()
        start_date = end_date - timedelta(days=days)
        
        return DailyProduction.objects.filter(
            dayOfIssue__range=[start_date, end_date]
        )
    
    @staticmethod
    def get_date_range_production(start_date, end_date):
        return DailyProduction.objects.filter(
            dayOfIssue__range=[start_date, end_date]
        )
    
    @staticmethod
    def generate_production_report(productions, title):
        if not productions.exists():
            return f"داده‌ای برای {title} یافت نشد."
        
        total_production = sum(p.production_value or 0 for p in productions)
        total_wastage = sum(p.wastage_value or 0 for p in productions)
        
        efficiency = ((total_production - total_wastage) / total_production * 100) if total_production > 0 else 0
        
        report = f"""
        <strong>{title}</strong><br>
        <div class="kpi-card mt-2">
            <div class="kpi-title">تعداد کل تولید</div>
            <div class="kpi-value">{total_production:,.0f} واحد</div>
        </div>
        
        <div class="row mt-3">
            <div class="col-md-4">
                <div class="kpi-card">
                    <div class="kpi-title">نرخ بهره‌وری</div>
                    <div class="kpi-value">{efficiency:.1f}%</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="kpi-card">
                    <div class="kpi-title">ضایعات کل</div>
                    <div class="kpi-value">{total_wastage:,.0f} واحد</div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="kpi-card">
                    <div class="kpi-title">تعداد روزها</div>
                    <div class="kpi-value">{productions.dates('dayOfIssue', 'day').count()} روز</div>
                </div>
            </div>
        </div>
        """
        
        return report
    

class LLMQuestionParser:
    @staticmethod
    def parse_with_llm(user_message):
        prompt = f"""
        شما یک دستیار هوشمند برای سیستم مدیریت تولید هستید. سوال کاربر را تحلیل کرده و پارامترهای زیر را استخراج کنید:
        
        - نوع گزارش: today, date_range, comparison, trend, etc.
        - تاریخ شروع (start_date)
        - تاریخ پایان (end_date) 
        - تعداد روز (days)
        - نام ماشین یا خط تولید (machine_name)
        - معیار مقایسه (comparison_metric)
        
        سوال کاربر: "{user_message}"
        
        پاسخ را به صورت JSON برگردانید:
        {{
            "report_type": "today|date_range|comparison|trend|...",
            "start_date": "YYYY-MM-DD or null",
            "end_date": "YYYY-MM-DD or null", 
            "days": number or null,
            "machine_name": "string or null",
            "comparison_metric": "production|efficiency|wastage or null"
        }}
        """
        
        try:
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[{"role": "user", "content": prompt}],
                max_tokens=200
            )
            
            result = json.loads(response.choices[0].message.content)
            return result
            
        except:
            # Fallback به روش regex اگر LLM در دسترس نبود
            return QuestionClassifier.classify_question(user_message)
        
