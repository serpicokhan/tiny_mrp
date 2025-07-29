# views.py
from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from mrp.models import Notification
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from django.utils import timezone
from django.contrib.humanize.templatetags.humanize import naturaltime

def get_notifications(request):
    if not request.user.is_authenticated:
        return JsonResponse({'notifications': []})
    
    notifications = Notification.objects.filter(user=request.user.sysuser, read=False).order_by('created_at')
    def humanize_time_diff(dt):
        now = timezone.now()
        diff = now - dt
        
        seconds = diff.total_seconds()
        minutes = int(seconds // 60)
        hours = int(minutes // 60)
        days = int(hours // 24)
        
        if days > 0:
            return f"{days} روز قبل" if days == 1 else f"{days} روز قبل"
        elif hours > 0:
            return f"{hours} ساعت قبل" if hours == 1 else f"{hours} ساعت قبل"
        elif minutes > 0:
            return f"{minutes} دقیقه قبل" if minutes == 1 else f"{minutes} دقیقه قبل"
        else:
            return "همین حالا"
    data = [{
        'message': n.message,
        'id': n.id,
        'link': n.link,
        'created_at': n.created_at.strftime("%Y-%m-%d %H:%M"),
        'time_ago': humanize_time_diff(n.created_at)
    } for n in notifications]
    return JsonResponse({'notifications': data})

def mark_as_read(request, notification_id):
    notification = get_object_or_404(Notification, id=notification_id, user=request.user)
    notification.read = True
    notification.save()
    return JsonResponse({'success': True})


def some_view(request):
    # ... your view logic ...
    
    # Create notification
    notification = Notification.objects.create(
        user=request.user.sysuser,
        message="New notification message",
        link="/some/link/",
        
    )
    
    # Send real-time update
    channel_layer = get_channel_layer()
    async_to_sync(channel_layer.group_send)(
        f"user_{request.user.sysuser.id}",
        {
            "type": "send_notification",
            "content": {
                "message": notification.message,
                "link": notification.link,
                "id": notification.id
            }
        }
    )
    return JsonResponse({'status':'ok'})
