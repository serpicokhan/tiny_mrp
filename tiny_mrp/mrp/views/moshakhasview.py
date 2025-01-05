from django.shortcuts import render, redirect,get_object_or_404
from mrp.models import EntryForm,Color
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

        return redirect('list_entry_form')  # Replace with your success URL

    else:
        # Render the form with all asset categories
        
        
        form=EntryFormForm()
        return render(request, 'mrp/moshakhase/create_entry_form.html', {
           'form':form
        })
def update_entry_form(request, entry_id):
    # Fetch the EntryForm instance to update
    entry_form_instance = get_object_or_404(EntryForm, id=entry_id)
    # asset_details = AssetDetail.objects.filter(entry=entry_form_instance)

    if request.method == "POST":
        # Update EntryForm
        entry_form = EntryFormForm(request.POST, instance=entry_form_instance)


        if entry_form.is_valid():
            # Save EntryForm
            entry_instance = entry_form.save()

            # Update or create AssetDetails

            return redirect('list_entry_form')  # Replace with your success URL
    else:
        # Prepopulate the form with the existing data
        entry_form = EntryFormForm(instance=entry_form_instance)

        # Prepare data for the AssetDetails table
    return render(request, 'mrp/moshakhase/update_entry_form.html', {
        'entry_form': entry_form,
        
    })

def list_entry_form(request):
    lists=EntryForm.objects.all()
    return render(request,'mrp/moshakhase/list.html',{'list':lists,'title':'مشخصات'})