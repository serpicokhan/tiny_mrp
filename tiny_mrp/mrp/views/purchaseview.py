from django.shortcuts import render, get_object_or_404
from django.http import JsonResponse
from django.template.loader import render_to_string
from django.views.decorators.csrf import csrf_exempt
from mrp.models import PurchaseRequest, RequestItem,SysUser,Part,Asset
from django.template.loader import render_to_string

import json

def list_purchase(request):
    return render(request,"mrp/purchase/purchase.html",{})
def list_purchase_req(request):
    requests=PurchaseRequest.objects.filter(user__userId=request.user)
    return render(request,"mrp/purchase/purchaseList.html",{"req":requests})

@csrf_exempt
def save_purchase_request(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            items = data.get('items', [])

            # Create a new PurchaseRequest
            print("user",request.user)
            purchase_request = PurchaseRequest.objects.create(
                user=SysUser.objects.get(userId=request.user),  # Assuming user is logged in
                # consume_place="General",  # Default or get from frontend if applicable
                # description="Auto-generated request"
            )

            # Add items to the PurchaseRequest
            for item in items:
                RequestItem.objects.create(
                    purchase_request=purchase_request,
                    item_name=Part.objects.get(id=item['part_code']),
                    quantity=item['quantity'],
                    consume_place=Asset.objects.get(id=item['machine_code']),
                    description=item['description']

                )

            return JsonResponse({'status': 'success', 'message': 'Purchase request saved successfully.'})

        except Exception as e:
            print('!!!!!!',e)
            return JsonResponse({'status': 'error', 'message': str(e)}, status=400)

    return JsonResponse({'status': 'error', 'message': 'Invalid request method.'}, status=405)

def create_purchase(request):
    if(request.method=="GET"):
        data=dict()
        data["parchase_req_html"]=render_to_string('mrp/purchase/createReq.html', {
                'maintenanceType': [],
                
            })
        return JsonResponse(data)
def update_purchase(request,id):
    company=PurchaseRequest.objects.get(id=id)
    req_items=RequestItem.objects.filter(purchase_request=company)
    if(request.method=="GET"):
        data=dict()
        data["parchase_req_html"]=render_to_string('mrp/purchase/createReq.html', {
                'maintenanceType': [],
                
            })
        return JsonResponse(data)


