from django.http import JsonResponse
from django.views.decorators.http import require_POST
from django.views.decorators.csrf import csrf_exempt
import json
from webpush.models import SubscriptionInfo, PushInformation
from django.contrib.auth.models import User

@require_POST
@csrf_exempt
def save_subscription(request):
    try:
        data = json.loads(request.body)
        subscription_data = data.get('subscription', {})
        
        # Get or create SubscriptionInfo
        sub_info, created = SubscriptionInfo.objects.get_or_create(
            endpoint=subscription_data.get('endpoint'),
            defaults={
                'auth': subscription_data.get('keys', {}).get('auth'),
                'p256dh': subscription_data.get('keys', {}).get('p256dh')
            }
        )
        
        # Associate with user if authenticated
        user = request.user if request.user.is_authenticated else None
        
        # Create PushInformation
        PushInformation.objects.create(
            subscription=sub_info,
            user=user,
            browser=data.get('browser', ''),
            device=data.get('device', ''),
            os=data.get('os', '')
        )
        
        return JsonResponse({'data': {'success': True}}, status=201)
    except Exception as e:
        return JsonResponse({'data': {'success': False, 'error': str(e)}}, status=400)