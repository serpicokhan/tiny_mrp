from mrp.business.assetutility import *
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt


@csrf_exempt
def asset_getAssets(request):
    searchStr= request.GET['qry'] if request.GET['qry'] else ''
    x=list(AssetUtility.getAssets(searchStr))
    return JsonResponse(x, safe=False)
@csrf_exempt
def asset_getAssets2(request):
    searchStr= request.GET['qry'] if request.GET['qry'] else ''
    x=list(AssetUtility.getAssets2(searchStr))
    return JsonResponse(x, safe=False)
@csrf_exempt  # Temporarily disable CSRF for testing; remove or replace with proper CSRF handling in production
def create_asset2(request):
    print(request.method,'!!!!!!!!!!')
    if request.method == "POST":
        try:
            # Parse JSON data from request body
            data = json.loads(request.body)

            # Validate input
            asset_name = data.get("name")
            if not asset_name:
                print({"error": "Asset name is required"})
                return JsonResponse({"error": "Asset name is required"}, status=400)

            # Generate part code (optional logic, modify as needed)
            asset_code = data.get("code", str(asset_name).replace(" ", "_").lower())

            # Check for duplicates
            if Asset2.objects.filter(assetName=asset_name).exists():
                print({"error": "َAsset with this name already exists"})

                return JsonResponse({"error": "Part with this name already exists"}, status=400)

            # Create new part
            new_asset = Asset2.objects.create(assetCode=asset_code, assetName=asset_name)

            # Return created part details
            return JsonResponse(
                {
                    "id": new_asset.id,
                    "code": new_asset.assetCode,
                    "name": new_asset.assetName,
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