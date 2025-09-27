@csrf_exempt
@require_POST
def chatbot_api(request):
    data = json.loads(request.body)
    user_message = data.get('message', '')
    
    # تحلیل سوال با LLM
    parsed_question = LLMQuestionParser.parse_with_llm(user_message)
    
    # تولید پاسخ بر اساس نوع سوال
    response = generate_dynamic_response(parsed_question, user_message)
    
    return JsonResponse({'reply': response})

def generate_dynamic_response(parsed_question, original_message):
    report_type = parsed_question.get('report_type', 'general')
    
    if report_type == 'today':
        productions = ProductionDataHandler.get_today_production()
        return ProductionDataHandler.generate_production_report(
            productions, "گزارش تولید امروز"
        )
    
    elif report_type == 'date_range':
        start_date = parsed_question.get('start_date')
        end_date = parsed_question.get('end_date')
        
        if start_date and end_date:
            productions = ProductionDataHandler.get_date_range_production(
                start_date, end_date
            )
            title = f"گزارش تولید از {start_date} تا {end_date}"
            return ProductionDataHandler.generate_production_report(productions, title)
    
    elif report_type == 'last_n_days':
        days = parsed_question.get('days', 7)  # پیش‌فرض ۷ روز
        productions = ProductionDataHandler.get_last_n_days_production(days)
        title = f"گزارش تولید {days} روز گذشته"
        return ProductionDataHandler.generate_production_report(productions, title)
    
    elif report_type == 'comparison':
        return generate_comparison_report(parsed_question)
    
    elif report_type == 'trend':
        return generate_trend_report(parsed_question)
    
    # برای سوالات پیچیده‌تر از LLM کمک بگیرید
    return generate_ai_enhanced_response(original_message, parsed_question)