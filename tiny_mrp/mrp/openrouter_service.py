# openrouter_service.py
import requests
import json
from django.conf import settings

class OpenRouterService:
    @staticmethod
    def generate_response(prompt, model="google/gemini-pro", max_tokens=1000):
        headers = {
            "Authorization": f"Bearer {settings.OPENROUTER_API_KEY}",
            "Content-Type": "application/json",
            "HTTP-Referer": "http://localhost:8000",  # آدرس سایت شما
            "X-Title": "Production Chatbot"
        }
        
        payload = {
            "model": model,
            "messages": [
                {
                    "role": "system",
                    "content": """شما یک دستیار هوشمند مدیریت تولید هستید. 
                    تمام پاسخ‌ها باید به زبان فارسی باشد.
                    از فرمت HTML برای زیبایی پاسخ استفاده کنید.
                    از تگ‌های div, strong, table, ul, li استفاده نمایید.
                    پاسخ‌ها باید دقیق، کاربردی و مبتنی بر داده‌ها باشد."""
                },
                {
                    "role": "user",
                    "content": prompt
                }
            ],
            "max_tokens": max_tokens,
            "temperature": 0.7,
            "top_p": 0.9
        }
        
        try:
            response = requests.post(
                settings.OPENROUTER_API_URL,
                headers=headers,
                json=payload,
                timeout=30
            )
            print(f"📥 وضعیت پاسخ: {response.status_code}")
            # print(f"📦 محتوای پاسخ: {response.text}...")
            
            if response.status_code == 200:
                result = response
                return result.text
            else:
                return f"خطا در ارتباط با OpenRouter: {response.status_code} - {response.text}"
                
        except Exception as e:
            print(e)
            return f"خطا: {str(e)}"
    
    @staticmethod
    def get_available_models():
        """دریافت لیست مدل‌های قابل دسترس"""
        try:
            response = requests.get("https://openrouter.ai/api/v1/models")
            return response.json()
        except:
            return None