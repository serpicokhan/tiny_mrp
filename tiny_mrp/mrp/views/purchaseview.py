from django.shortcuts import render,redirect, get_object_or_404
from django.http import JsonResponse,HttpResponse
from django.template.loader import render_to_string
from django.views.decorators.csrf import csrf_exempt
from mrp.models import PurchaseRequest, RequestItem,SysUser,Part,Asset2,PurchaseRequestFile,Asset
from django.template.loader import render_to_string
from mrp.business.purchaseutility import *
from mrp.business.DateJob import *
from django.db.models import Q
from django.contrib.auth.context_processors import PermWrapper
from django.core.files.storage import FileSystemStorage
from mrp.forms import PurchaseRequestFileForm
import openpyxl
from openpyxl.styles import Border, Side, PatternFill,Font,Alignment
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
        start_of_month=start_of_month.strftime('%Y-%m-%d')
        end_of_month=end_of_month.strftime('%Y-%m-%d')
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
                    'end':end_of_month,
                    })
def list_purchase_req_detail(request):
    search_query = request.GET.get('q', '').strip() 
    start = request.GET.get('start', False) 
    end = request.GET.get('end', False)
    userlist = request.GET.getlist('userlist', False)

    sort_by = request.GET.get('sort_by', '-created_at')  # Default sorting by `created_at` in descending order
    status_filter = request.GET.get('status', 'all')  # Default to show all statuses
    requests=PurchaseRequest.objects.all().order_by('-created_at')
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
        start_of_month=start_of_month.strftime('%Y-%m-%d')
        end_of_month=end_of_month.strftime('%Y-%m-%d')
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
    if(userlist):
        userlist = [int(user_id) for user_id in userlist]
        requests=requests.filter(user__id__in=userlist)
    
    
    ws=PurchaseUtility.doPaging(request,requests)
    return render(request,"mrp/purchase/purchaseList2.html",
                  {
                    "req":ws,
                    "search_query": search_query,
                    "sort_by": sort_by,
                    "status": status_filter,
                    'perms': PermWrapper(request.user),
                    'users':SysUser.objects.all(),
                    'start':start_of_month,
                    'end':end_of_month,
                    'userlist':userlist
                    })
@csrf_exempt
def save_purchase_request(request):
    if request.method == 'POST':
        # try:
            data = json.loads(request.body)
            items = data.get('items', [])
            req_id=data.get('id', False)
            created_at=data.get("created_at",False)
            is_emergency=data.get("emergency",False)


            print("312321########",req_id)
            purchase_request=None


            # Create a new PurchaseRequest
            r_user=data.get('user_name', False)
            if(r_user):
                r_user=SysUser.objects.get(userId=r_user)
            else:
                r_user=SysUser.objects.get(userId=request.user)
            
            if(req_id):
                #update
                purchase_request = get_object_or_404(PurchaseRequest, id=req_id)
                purchase_request.created_at=DateJob.getTaskDate(created_at)
                purchase_request.save()
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
                print(request.POST)
                print(created_at," date!!!!!!!!")
                purchase_request = PurchaseRequest.objects.create(
                user=r_user,
                is_emergency=is_emergency,  # Assuming user is logged in
                created_at=DateJob.getTaskDate(created_at)
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
                       

                        
                    },request)
            data["http_status"]="ok"
            data['purchase_request']=purchase_request.id

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
    files=PurchaseRequestFile.objects.filter(purchase_request=company)
    if(request.method=="GET"):
        data=dict()
        data["parchase_req_html"]=render_to_string('mrp/purchase/updateReq.html', {
                'company': company,
                'items':req_items,
                'files':files,
                'date_':company.created_at.strftime('%Y/%m/%d'),
                
                
            },request)
        return JsonResponse(data)

def update_purchase_v2(request,id):
    print(request.GET.get('page'),'!!!!!!!!!!!!!!')
    company=PurchaseRequest.objects.get(id=id)
    req_items=RequestItem.objects.filter(purchase_request=company)
    files=PurchaseRequestFile.objects.filter(purchase_request=company)

    if(request.method=="GET"):
        data=dict()
        data["parchase_req_html"]=render_to_string('mrp/purchase/updateReq_v2.html', {
                'company': company,
                'items':req_items,
                'files':files,
                'date_':company.created_at.strftime('%Y/%m/%d')

                
            },request)
        return JsonResponse(data)

def purchase_dash(request):
    list_items=PurchaseRequest.objects.filter(status='Pending').order_by('-id')
    list_items=PurchaseUtility.doPaging(request,list_items)
    
    return render(request,"mrp/purchase/mainList.html",{'items':list_items})
def confirm_request(request,id):
    company=PurchaseRequest.objects.get(id=id)
    company.status="Approved"
    company.save()
    list_item=list_purchaseRequeset(request)
    data=dict()
    data["parchase_req_html"]=render_to_string('mrp/purchase/partialPurchaseList_v2.html', {
                
                'req':list_item,

                
            },request)
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

                
            },request)
    data["http_status"]="ok"
    data["status"]=company.status


    return JsonResponse(data)

def list_purchaseRequeset(request):
    return filter_request_by(request)

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
@csrf_exempt
def upload_purchase_images(request):
    
    print(request.method,'####################')
    if request.method == 'POST':
        purchase_request_id = request.GET.get('p_id')
        uploaded_files = request.FILES.getlist('file')
        print("files:",uploaded_files)
        print("p_id:",purchase_request_id)

        if not purchase_request_id or not uploaded_files:
            print("here!!!")


            return JsonResponse({'success': False,
                                  'errors': 'Both purchase_request and file are required.'}, status=400)

        # Validate and get the PurchaseRequest instance
        purchase_request = get_object_or_404(PurchaseRequest, id=purchase_request_id)

        # Create and save the PurchaseRequestFile instance
        for uploaded_file in uploaded_files:
            PurchaseRequestFile.objects.create(
                purchase_request=purchase_request,
                file=uploaded_file
            )

        return JsonResponse({'success': True, 'message': 'File uploaded successfully!'})
    return JsonResponse({'success': False, 'message': 'Invalid request method.'}, status=405)
##########EXCEL#######################
def export_purchase_requests(request):
    # Create a workbook and a sheet
    wb = openpyxl.Workbook()
    sheet = wb.active
    sheet.title = 'Purchase Requests'

    # Set row index to start at 1
    row = 1
    thin_border = Border(
        left=Side(style='thin'),
        right=Side(style='thin'),
        top=Side(style='thin'),
        bottom=Side(style='thin')
    )

    # Define the header fill color (for PurchaseRequest and items table)
    header_fill = PatternFill(start_color="FFFF99", end_color="FFFF99", fill_type="solid")
    nazanin_font = Font(name='B Nazanin', size=14)
    justified_alignment = Alignment(horizontal="center", wrap_text=True)
    

    # Get all purchase requests
    purchase_requests=filter_request_by(request)

    for purchase_request in purchase_requests:
        # Add the header for the PurchaseRequest
        sheet[f'A{row}'] = f'شماره درخواست: {purchase_request.id}'
        sheet[f'B{row}'] = f'کاربر: {purchase_request.user.fullName}'
        sheet[f'C{row}'] = f'تاریخ: {purchase_request.get_dateCreated_jalali().strftime("%Y/%m/%d")}'
        # sheet[f'D{row}'] = f'اضطراری: {purchase_request.is_emergency}'
        sheet[f'D{row}'] = f"اضطراری: {'بله' if purchase_request.is_emergency else 'خیر'}"
        sheet[f'E{row}'] = f'وضعیت: {purchase_request.status}'
        for col in ['A', 'B', 'C', 'D', 'E']:
            cell = sheet[f'{col}{row}']
            cell.border = thin_border
            cell.fill = header_fill
            cell.font = nazanin_font  # Apply B Nazanin font
            # cell.alignment = Alignment(horizontal="justify")
            cell.alignment = justified_alignment 
            
        
        row += 2  # Leave some space between PurchaseRequest header and items table

        # Now, create the header for the items table under each PurchaseRequest
        sheet[f'A{row}'] = 'نام کالا'
        sheet[f'B{row}'] = 'تعداد'
        sheet[f'C{row}'] = 'مورد مصرف'
        sheet[f'D{row}'] = 'قیمت'
        sheet[f'E{row}'] = 'تامین کننده'
        for col in ['A', 'B', 'C', 'D', 'E']:
            cell = sheet[f'{col}{row}']
            cell.border = thin_border
            cell.fill = header_fill
            cell.font = nazanin_font  # Apply B Nazanin font
            cell.alignment = justified_alignment 

        row += 1  # Move to the next row to start the items list
        

        # Fetch all items for the current purchase request
        items = purchase_request.items.all()

        for item in items:
            sheet[f'A{row}'] = item.item_name.partName  # Assuming 'partName' is the name field
            sheet[f'B{row}'] = item.quantity
            sheet[f'C{row}'] = item.consume_place.assetName  # Assuming 'name' field in Asset2
            sheet[f'D{row}'] = item.price
            sheet[f'E{row}'] = item.supplier_assigned.name if item.supplier_assigned else "مشخص نشده"
            for col in ['A', 'B', 'C', 'D', 'E']:
                cell = sheet[f'{col}{row}']
                cell.border = thin_border
                cell.font = nazanin_font  # Apply B Nazanin font
                cell.alignment = justified_alignment 

            row += 1  # Move to the next row for the next item
        
        # Leave some space between different PurchaseRequests
        row += 2
     # Set the column widths
    sheet.column_dimensions['A'].width = 30  # 'Item Name' column
    sheet.column_dimensions['B'].width = 15  # 'Quantity' column
    sheet.column_dimensions['C'].width = 25  # 'Consume Place' column
    sheet.column_dimensions['D'].width = 15  # 'Price' column
    sheet.column_dimensions['E'].width = 20  # 'Supplier' column

    # Create a response to download the file
    response = HttpResponse(content_type='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    response['Content-Disposition'] = 'attachment; filename="purchase_requests_with_items.xlsx"'

    # Save the workbook to the response
    wb.save(response)
    return response


def referesh_purchase_list(request):
    search_query = request.GET.get('q', '').strip() 
    # page=request.GET.get('page', False)
    # print(page,request.GET,'@@@@@@@@@@')
    
    start = request.GET.get('start', False) 
    end = request.GET.get('end', False)
    userlist = request.GET.getlist('userlist', False)

    sort_by = request.GET.get('sort_by', '-created_at')  # Default sorting by `created_at` in descending order
    status_filter = request.GET.get('status', 'all')  # Default to show all statuses
    if(request.user.is_superuser):
        requests=PurchaseRequest.objects.all().order_by('-created_at')
    else:
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
    if(userlist):
        userlist = [int(user_id) for user_id in userlist]
        requests=requests.filter(user__id__in=userlist)
    
    
    ws= PurchaseUtility.doPaging(request,requests)
    data=dict()
    data["status"]="ok"
    data["parchase_req_html"]=render_to_string('mrp/purchase/partialPurchaseList.html', {
                        
                        'req':ws,
                       

                        
                    },request)
    return JsonResponse(data)



def filter_request_by(request):
    search_query = request.GET.get('q', '').strip() 
    page=request.GET.get('page', False)
    # print(page,request.GET,'@@@@@@@@@@')
    
    start = request.GET.get('start', False) 
    end = request.GET.get('end', False)
    userlist = request.GET.getlist('userlist', False)

    sort_by = request.GET.get('sort_by', '-created_at')  # Default sorting by `created_at` in descending order
    status_filter = request.GET.get('status', 'all')  # Default to show all statuses
    if(request.user.is_superuser):
        requests=PurchaseRequest.objects.all().order_by('-created_at')
    else:
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
    if(userlist):
        userlist = [int(user_id) for user_id in userlist]
        requests=requests.filter(user__id__in=userlist)
    
    return requests
def calendar_purchase_request_main(request):
    makan_id=request.GET.get("makan_id",False)
    makan=Asset.objects.filter(assetIsLocatedAt__isnull=True)
    return render(request,'mrp/purchase/calendar_Purchase_main.html',{'title':'تولید روزانه','makan':makan,'makan_id':int(makan_id)})
def get_purchasereq_calendar_info(request):
    # print(request.GET.get("makan"),'!!!!!!!!!!!!!!!!!!')
    makan=request.GET.get("makan",False)
    data=[]
    if(request.user.is_superuser):
        user_info=PurchaseRequest.objects.all()
    else:
        user_info=PurchaseRequest.objects.filter(user__userId=request.user)
    # print(user_info)
    for i in user_info:
        if i.status == 'Approved':
            color = '#53c797'  # Green for approved
        elif i.status == 'Pending':
            color = '#5bc0de'  # Yellow for pending
        elif i.status == 'Rejected':
            color = '#d9534f'  # Red for rejected
        elif i.status == 'Ordered':
            color = '#5bc0de'  # Blue for ordered
        else:
            color = '#cccccc'  # Default color if status is unknown
        data.append({'title': f"درخواست {i.user} {i.getItems()}",\
                'start': i.created_at,\
                 'color': color,\
                'id':i.id})
        # data.append({'title': f"جمع ضایعات روز: {round(z,2)}",\
        #         'start': i[0],\
        #          'color': 'red',\
        #         'id':i[0]})

    return JsonResponse(data,safe=False)
def get_purchase_request(request):
    id=request.GET.get('id',False)
    purchase=PurchaseRequest.objects.get(id=id)
    return render(request,'mrp/purchase/purchase_request_bill.html',{'purchase_request':purchase})
def add_view_by(request):
    try:
        # user_id=SysUser.objects.get(userId=request.user).id
        id=request.GET.get('id',False)
        purchase=PurchaseRequest.objects.get(id=id)
        purchase.add_viewer(request.user.id)
        return JsonResponse({},status=201)
    except Exception as e:
        print(e)
        return JsonResponse({'error':'error'},status=201)





