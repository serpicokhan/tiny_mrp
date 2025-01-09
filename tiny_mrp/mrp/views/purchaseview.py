from django.shortcuts import render, get_object_or_404
from django.http import JsonResponse
from django.template.loader import render_to_string
from django.views.decorators.csrf import csrf_exempt
from mrp.models import PurchaseRequest, RequestItem,SysUser,Part,Asset2
from django.template.loader import render_to_string
from mrp.business.purchaseutility import *
from mrp.business.DateJob import *
from django.db.models import Q
from django.contrib.auth.context_processors import PermWrapper


import json

def list_purchase(request):
    return render(request,"mrp/purchase/purchase.html",{})
def list_purchase_req(request):
    search_query = request.GET.get('q', '').strip() 
    start = request.GET.get('start', False) 
    end = request.GET.get('end', False)

    sort_by = request.GET.get('sort_by', '-created_at')  # Default sorting by `created_at` in descending order
    status_filter = request.GET.get('status', 'all')  # Default to show all statuses
    requests=PurchaseRequest.objects.filter(user__userId=request.user).order_by('-created_at')
    if search_query:
        filters = Q(items__item_name__partName__icontains=search_query) | \
                Q(items__description__icontains=search_query) | \
                Q(user__fullName__icontains=search_query)
        
        # Only add the id filter if the search query is a digit
        if search_query.isdigit():
            filters |= Q(id=search_query)
        
        requests = requests.filter(filters).distinct()
    # Status filtering
    if status_filter != 'all':
        requests = requests.filter(status=status_filter)
    valid_sort_fields = ['id', '-id', 'created_at', '-created_at', 'status', '-status']
    if sort_by in valid_sort_fields:
        requests = requests.order_by(sort_by)
    if start and end:
        # print(start,end,'!!!!!!!!!!!!!!!!!')
        start_of_month=DateJob.getTaskDate(start)
        end_of_month=DateJob.getTaskDate(end)
        # print(start,end,'!!!!!!!!!!!!!!!!!')

        requests=requests.filter(created_at__range=[start_of_month,end_of_month])
    else:
        today_shamsi = jdatetime.date.today()
        start_of_month = jdatetime.date(today_shamsi.year, today_shamsi.month, 1)

        # Calculate the end of the current month
        if today_shamsi.month < 12:  # Not the last month of the year
            next_month = jdatetime.date(today_shamsi.year, today_shamsi.month + 1, 1)
        else:  # For Esfand (last month), move to Farvardin of the next year
            next_month = jdatetime.date(today_shamsi.year + 1, 1, 1)

        end_of_month = next_month - jdatetime.timedelta(days=1)
        start_of_month=start_of_month.togregorian().strftime('%Y-%m-%d')
        end_of_month=end_of_month.togregorian().strftime('%Y-%m-%d')
    
    
    ws=PurchaseUtility.doPaging(request,requests)
    return render(request,"mrp/purchase/purchaseList.html",
                  {
                    "req":ws,
                    "search_query": search_query,
                    "sort_by": sort_by,
                    "status": status_filter,
                    'perms': PermWrapper(request.user),
                    'users':SysUser.objects.all(),
                    'start':start_of_month,
                    'end':end_of_month
                    })
def list_purchase_req_detail(request):
    requests=list_purchaseRequeset(request)
    return render(request,"mrp/purchase/purchaseList2.html",{"req":requests})

@csrf_exempt
def save_purchase_request(request):
    if request.method == 'POST':
        # try:
            data = json.loads(request.body)
            items = data.get('items', [])
            req_id=data.get('id', False)
            print("312321########",req_id)


            # Create a new PurchaseRequest
            r_user=data.get('user_name', False)
            if(r_user):
                r_user=SysUser.objects.get(userId=r_user)
            else:
                r_user=SysUser.objects.get(userId=request.user)
            
            if(req_id):
                #update
                purchase_request = get_object_or_404(PurchaseRequest, id=req_id)
                existing_item_ids = [item.get('id') for item in items if 'id' in item]
                RequestItem.objects.filter(purchase_request=purchase_request).exclude(id__in=existing_item_ids).delete()
                for item in items:
                    if ('id' in item) and (item['id']):  # Update existing item
                        request_item = get_object_or_404(RequestItem, id=item['id'], purchase_request=purchase_request)
                        request_item.item_name = Part.objects.get(id=item['part_code'])
                        request_item.quantity = item['quantity']
                        request_item.consume_place = Asset2.objects.get(id=item['machine_code'])
                        request_item.description = item['description']
                        request_item.save()
                    else:  # Create new item
                        RequestItem.objects.create(
                            purchase_request=purchase_request,
                            item_name=Part.objects.get(id=item['part_code']),
                            quantity=item['quantity'],
                            consume_place=Asset2.objects.get(id=item['machine_code']),
                            description=item['description']
                        )
                # print(existing_item_ids)
            else:
                purchase_request = PurchaseRequest.objects.create(
                user=r_user,  # Assuming user is logged in
                # consume_place="General",  # Default or get from frontend if applicable
                # description="Auto-generated request"
                )               

            # Add items to the PurchaseRequest
                for item in items:
                    RequestItem.objects.create(
                        purchase_request=purchase_request,
                        item_name=Part.objects.get(id=item['part_code']),
                        quantity=item['quantity'],
                        consume_place=Asset2.objects.get(id=item['machine_code']),
                        description=item['description']

                    )
            list_item=list_purchaseRequeset(request)
            data=dict()
            data["parchase_req_html"]=render_to_string('mrp/purchase/partialPurchaseList.html', {
                        
                        'req':list_item,

                        
                    })
            data["http_status"]="ok"

            return JsonResponse(data)

        # except Exception as e:
        #     print('!!!!!!',e)
        #     return JsonResponse({'status': 'error', 'message': str(e)}, status=400)

    return JsonResponse({'status': 'error', 'message': 'Invalid request method.'}, status=405)

def create_purchase(request):
    if(request.method=="GET"):
        data=dict()
        sysusers=SysUser.objects.all()
        data["parchase_req_html"]=render_to_string('mrp/purchase/createReq.html', {
                'users': sysusers,

                
            },request)
        return JsonResponse(data)
def update_purchase(request,id):
    company=PurchaseRequest.objects.get(id=id)
    req_items=RequestItem.objects.filter(purchase_request=company)
    if(request.method=="GET"):
        data=dict()
        data["parchase_req_html"]=render_to_string('mrp/purchase/updateReq.html', {
                'company': company,
                'items':req_items
                
            })
        return JsonResponse(data)

def update_purchase_v2(request,id):
    company=PurchaseRequest.objects.get(id=id)
    req_items=RequestItem.objects.filter(purchase_request=company)
    if(request.method=="GET"):
        data=dict()
        data["parchase_req_html"]=render_to_string('mrp/purchase/updateReq_v2.html', {
                'company': company,
                'items':req_items
                
            })
        return JsonResponse(data)

def purchase_dash(request):
    list_items=PurchaseRequest.objects.filter(status='Pending')
    print(list_items)
    return render(request,"mrp/purchase/mainList.html",{'items':list_items})
def confirm_request(request,id):
    company=PurchaseRequest.objects.get(id=id)
    company.status="Approved"
    company.save()
    list_item=list_purchaseRequeset(request)
    data=dict()
    data["parchase_req_html"]=render_to_string('mrp/purchase/partialPurchaseList_v2.html', {
                
                'req':list_item,

                
            })
    data["http_status"]="ok"
    data["status"]=company.status


    return JsonResponse(data)
    # return JsonResponse({"status":"ok",'status':company.status})
def reject_request(request,id):
    company=PurchaseRequest.objects.get(id=id)
    company.status="Rejected"
    company.save()
    list_item=list_purchaseRequeset(request)
    data=dict()
    data["parchase_req_html"]=render_to_string('mrp/purchase/partialPurchaseList_v2.html', {
                
                'req':list_item,

                
            })
    data["http_status"]="ok"
    data["status"]=company.status


    return JsonResponse(data)

def list_purchaseRequeset(request):
    list_items=PurchaseRequest.objects.filter(user__userId=request.user).order_by('-id')
    return list_items

@csrf_exempt

def delete_purchase_request(request,id):
    company=  get_object_or_404(PurchaseRequest, id=id)
    if(request.method=="POST"):
        data=dict()

        if(company.status=="Pending"):
            company.delete()
            list_item=list_purchaseRequeset(request)
            data["parchase_req_html"]=render_to_string('mrp/purchase/partialPurchaseList.html', {
                        
                        'req':list_item,

                        
                    })
            data["http_status"]="ok"
            data["status"]=company.status
        else:
            data["http_status"]="ok"
            data["status"]=company.status
            data["message"]="حدف درخواست به خاطر تغییر وضعیت امکان پذیر نمی باشد"



        return JsonResponse(data)
    return JsonResponse({'stats':'BAD!','message':'Bad Data'})

   