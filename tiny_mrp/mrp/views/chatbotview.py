from django.shortcuts import render
from mrp.models import *

import jdatetime
from django.db import IntegrityError
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import JsonResponse
from mrp.business.DateJob import *
from datetime import datetime, timedelta
from django.contrib.contenttypes.models import ContentType
from django.contrib.auth.decorators import permission_required
from django.contrib.auth.context_processors import PermWrapper
from django.contrib.auth.decorators import login_required
from django.template.loader import render_to_string
from mrp.business.tolid_util import *
import datetime
from django.shortcuts import get_object_or_404
from django.core.exceptions import ValidationError
from rest_framework import generics
from mrp.production_ai_service import ProductionAIService
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET, require_POST


def load_chart(request):
    return render(request,'mrp/chat/main.html',{})

@csrf_exempt
@require_POST
def chatbot_api(request):
    data = json.loads(request.body)
    user_message = data.get('message', '')
    user_id = data.get('user_id')
    
    try:
        # تولید پاسخ با Gemini از طریق OpenRouter
        ai_response = ProductionAIService.generate_production_response(user_message, user_id)
        
        # ذخیره در تاریخچه (اختیاری)
        # save_chat_history(user_id, user_message, ai_response)
        
        return JsonResponse({
            'reply': ai_response,
            'suggestions': [
                "تولید امروز چطور بوده؟",
                "وضعیت ماشین‌ها را نشان بده",
                "گزارش هفته گذشته",
                "مقایسه خطوط تولید"
            ],
            'chat_id': None  # اگر سیستم تاریخچه دارید
        })
        
    except Exception as e:
        return JsonResponse({
            'reply': f"خطا در پردازش سوال: {str(e)}",
            'suggestions': [],
            'chat_id': None
        })
# @csrf_exempt
# @require_POST
# def chatbot_api(request):
#     data = json.loads(request.body)
#     user_message = data.get('message', '')
    
#     # تحلیل سوال با LLM
#     parsed_question = LLMQuestionParser.parse_with_llm(user_message)
    
#     # تولید پاسخ بر اساس نوع سوال
#     response = generate_dynamic_response(parsed_question, user_message)
    
#     return JsonResponse({'reply': response})

# def generate_dynamic_response(parsed_question, original_message):
#     report_type = parsed_question.get('report_type', 'general')
    
#     if report_type == 'today':
#         productions = ProductionDataHandler.get_today_production()
#         return ProductionDataHandler.generate_production_report(
#             productions, "گزارش تولید امروز"
#         )
    
#     elif report_type == 'date_range':
#         start_date = parsed_question.get('start_date')
#         end_date = parsed_question.get('end_date')
        
#         if start_date and end_date:
#             productions = ProductionDataHandler.get_date_range_production(
#                 start_date, end_date
#             )
#             title = f"گزارش تولید از {start_date} تا {end_date}"
#             return ProductionDataHandler.generate_production_report(productions, title)
    
#     elif report_type == 'last_n_days':
#         days = parsed_question.get('days', 7)  # پیش‌فرض ۷ روز
#         productions = ProductionDataHandler.get_last_n_days_production(days)
#         title = f"گزارش تولید {days} روز گذشته"
#         return ProductionDataHandler.generate_production_report(productions, title)
    
#     elif report_type == 'comparison':
#         return generate_comparison_report(parsed_question)
    
#     elif report_type == 'trend':
#         return generate_trend_report(parsed_question)
    
#     # برای سوالات پیچیده‌تر از LLM کمک بگیرید
#     return generate_ai_enhanced_response(original_message, parsed_question)