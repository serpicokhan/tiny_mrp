import threading

_thread_locals = threading.local()

def get_current_request():
    """دریافت request جاری از thread local"""
    return getattr(_thread_locals, 'request', None)

def get_current_user():
    """دریافت کاربر جاری از request"""
    request = get_current_request()
    if request and hasattr(request, 'user'):
        return request.user
    return None

class ThreadLocalMiddleware:
    """Middleware برای ذخیره request در thread local"""
    
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # ذخیره request در thread local
        _thread_locals.request = request
        
        response = self.get_response(request)
        
        # پاکسازی بعد از اتمام درخواست
        if hasattr(_thread_locals, 'request'):
            del _thread_locals.request
            
        return response