from django.shortcuts import render
from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from django.template.loader import render_to_string
from mrp.models import Supplier
from mrp.business.supplierutility import *
from django.views.decorators.csrf import csrf_exempt

def wo_getSuppliers(request):
    # print(request.GET['q'])
    searchStr= request.GET['qry'] if request.GET['qry'] else ''
    x=list(PartUtility.getSupplier(searchStr))
    return JsonResponse(x, safe=False)

@csrf_exempt  # Temporarily disable CSRF for testing; remove or replace with proper CSRF handling in production
def create_supplier(request):
    print(request.method,'!!!!!!!!!!!')
    if request.method == "POST":
        try:
            # Parse JSON data from request body
            data = json.loads(request.body)

            # Validate input
            supplier_name = data.get("name")
            if not supplier_name:
                return JsonResponse({"error": "Part name is required"}, status=400)

            # Generate part code (optional logic, modify as needed)
            # part_code = data.get("code", str(supplier_name).replace(" ", "_").lower())

            # Check for duplicates
            if Supplier.objects.filter(name=supplier_name).exists():
                return JsonResponse({"error": "Part with this name already exists"}, status=400)

            # Create new part
            new_supplier = Supplier.objects.create(name=supplier_name)

            # Return created part details
            return JsonResponse(
                {
                    "id": new_supplier.id,
                    
                    "name": new_supplier.name,
                },
                status=201,
            )
        except json.JSONDecodeError:
            return JsonResponse({"error": "Invalid JSON data"}, status=400)
        except Exception as e:
            print(e)
            return JsonResponse({"error": str(e)}, status=500)
    else:
        return JsonResponse({"error": "Invalid request method"}, status=405)