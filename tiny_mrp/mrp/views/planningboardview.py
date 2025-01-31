from django.shortcuts import render,redirect, get_object_or_404
from django.http import JsonResponse,HttpResponse
from django.template.loader import render_to_string
from django.views.decorators.csrf import csrf_exempt
from mrp.models import PurchaseRequest, RequestItem,SysUser,Part,Asset2,PurchaseRequestFile,Asset,Comment,PurchaseNotes,PurchaseActivityLog,Supplier
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
from django.contrib.auth.decorators import login_required
from django.contrib.auth.decorators import permission_required
from django.views.decorators.csrf import csrf_exempt


def list_pboard(request):
    items=RequestItem.objects.filter(purchase_request__status="Ordered",price=0,supplied_quantity=0 )
    return render(request,'mrp/purchase_planningboard/list.html',{"items":items})


@csrf_exempt  # Disable CSRF for testing purposes; ensure proper CSRF handling in production

def save_suppliers_pb(request):
    if request.method == 'POST':
    #     data = json.loads(request.body)
    #     suppliers = data.get('suppliers', [])
        
    #     for supplier in suppliers:

    #         print(f"Saving supplier {supplier['item_id']}")

    #     return JsonResponse({"message": "Suppliers saved successfully"}, status=200)

    # return JsonResponse({"error": "Invalid request"}, status=400)
    
        try:
            # Get the posted JSON data
            data = json.loads(request.body.decode('utf-8'))
            suppliers = data.get('suppliers', [])
            # print(suppliers[1],'!!!!!!')

            
            # Loop through the received data to update the RequestItem models
            for item_data in suppliers:
                print(item_data,'!!!!!!!!!!')
                item_id = item_data.get('item_id')
                supplier_id = item_data.get('supplier_id')
                username = item_data.get('user_name')
                place = item_data.get('place')
                item_name = item_data.get('item_name')
                quantity = item_data.get('quantity')
                price = item_data.get('price')

                # Get or create the related Supplier, Part, and Asset2 objects
                supplier = get_object_or_404(Supplier, pk=supplier_id)
                part = get_object_or_404(Part, id=item_id)  # Adjust according to your Part model
                # consume_place = get_object_or_404(Asset2, name=place)  # Adjust according to your Asset2 model

                # Update or create the RequestItem
                # request_item, created = RequestItem.objects.update_or_create(
                #     item_name=part,
                #     defaults={
                #         'price': price,
                #         'supplied_quantity': quantity,
                #         'supplier_assigned': supplier,
                        
                #     }
                # )
                request_item=RequestItem.objects.get(id=item_id)
                request_item.supplier_assigned=supplier
                request_item.supplied_quantity=quantity
                request_item.price=price
                request_item.save()


            return JsonResponse({'status': 'success', 'message': 'Items updated successfully'}, status=200)
        except Exception as e:
            print("eroor!!!!!!!!!!",e)
            return JsonResponse({'status': 'error', 'message': str(e)}, status=400)
    else:
        return JsonResponse({'status': 'error', 'message': 'Invalid method'}, status=405)