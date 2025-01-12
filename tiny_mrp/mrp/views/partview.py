from mrp.business.partutility import *
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
def wo_getParts(request):
    # print(request.GET['q'])
    searchStr= request.GET['qry'] if request.GET['qry'] else ''
    x=list(PartUtility.getParts(searchStr))
    return JsonResponse(x, safe=False)
@csrf_exempt  # Temporarily disable CSRF for testing; remove or replace with proper CSRF handling in production
def create_part(request):
    print(request.method,'!!!!!!!!!!!')
    if request.method == "POST":
        try:
            # Parse JSON data from request body
            data = json.loads(request.body)

            # Validate input
            part_name = data.get("name")
            if not part_name:
                return JsonResponse({"error": "Part name is required"}, status=400)

            # Generate part code (optional logic, modify as needed)
            part_code = data.get("code", str(part_name).replace(" ", "_").lower())

            # Check for duplicates
            if Part.objects.filter(partName=part_name).exists():
                return JsonResponse({"error": "Part with this name already exists"}, status=400)

            # Create new part
            new_part = Part.objects.create(partCode=part_code, partName=part_name)

            # Return created part details
            return JsonResponse(
                {
                    "id": new_part.id,
                    "code": new_part.partCode,
                    "name": new_part.partName,
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