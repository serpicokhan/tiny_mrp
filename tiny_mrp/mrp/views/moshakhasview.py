from django.shortcuts import render, redirect,get_object_or_404
from mrp.models import EntryForm, AssetCategory2, AssetDetail,Color
from mrp.forms import EntryFormForm
def create_entry_form(request):
    if request.method == "POST":
        # Extract main form fields
        color = request.POST.get('color')
        name = request.POST.get('name')
        tool = request.POST.get('tool')
        la = request.POST.get('la')

        # Save the entry form
        entry_form = EntryForm.objects.create(
            color=Color.objects.get(id=color),
            name=name,
            tool=tool,
            la=la
        )

        # Extract and save asset details
        asset_categories = AssetCategory2.objects.all()
        for category in asset_categories:
            nomre = request.POST.get(f'nomre_{category.id}')
            speed = request.POST.get(f'speed_{category.id}')

            # Save AssetDetail for the entry
            if nomre and speed:  # Validate input
                AssetDetail.objects.create(
                    entry=entry_form,
                    asset_category=category,
                    nomre=int(nomre),
                    speed=float(speed)
                )

        return redirect('list_entry_form')  # Replace with your success URL

    else:
        # Render the form with all asset categories
        asset_categories = AssetCategory2.objects.all()
        
        form=EntryFormForm()
        return render(request, 'mrp/moshakhase/create_entry_form.html', {
            'asset_categories': asset_categories,'form':form
        })
def update_entry_form(request, entry_id):
    # Fetch the EntryForm instance to update
    entry_form_instance = get_object_or_404(EntryForm, id=entry_id)
    asset_details = AssetDetail.objects.filter(entry=entry_form_instance)

    if request.method == "POST":
        # Update EntryForm
        entry_form = EntryFormForm(request.POST, instance=entry_form_instance)

        # Handle AssetDetails
        updated_details = []
        for category in AssetCategory2.objects.all():
            nomre = request.POST.get(f'nomre_{category.id}')
            speed = request.POST.get(f'speed_{category.id}')
            if nomre is not None and speed is not None:
                updated_details.append({
                    'asset_category': category,
                    'nomre': nomre,
                    'speed': speed,
                })

        if entry_form.is_valid():
            # Save EntryForm
            entry_instance = entry_form.save()

            # Update or create AssetDetails
            for detail in updated_details:
                AssetDetail.objects.update_or_create(
                    entry=entry_instance,
                    asset_category=detail['asset_category'],
                    defaults={
                        'nomre': detail['nomre'],
                        'speed': detail['speed'],
                    }
                )

            return redirect('list_entry_form')  # Replace with your success URL
    else:
        # Prepopulate the form with the existing data
        entry_form = EntryFormForm(instance=entry_form_instance)

        # Prepare data for the AssetDetails table
        asset_categories = AssetCategory2.objects.all()
        asset_data = []
        for category in asset_categories:
            asset_detail = asset_details.filter(asset_category=category).first()
            asset_data.append({
                'category': category,
                'nomre': asset_detail.nomre if asset_detail else '',
                'speed': asset_detail.speed if asset_detail else '',
            })
    return render(request, 'mrp/moshakhase/update_entry_form.html', {
        'entry_form': entry_form,
        'asset_data': asset_data,
    })

def list_entry_form(request):
    lists=EntryForm.objects.all()
    return render(request,'mrp/moshakhase/list.html',{'list':lists,'title':'مشخصات'})