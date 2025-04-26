from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from mrp.forms import MaintenanceForm, TaskFormSet, ChecklistItemFormSet, GroupTaskFormSet, ToolFormSet, SparePartFormSet
from mrp.models import Maintenance, Task

def list_workorder(request):
    return render(request,"mrp/maintenance/workorder/woList.html",{})

@login_required
def create_work_order(request):
    if request.method == 'POST':
        form = MaintenanceForm(request.POST)
        task_formset = TaskFormSet(request.POST, prefix='tasks')
        tool_formset = ToolFormSet(request.POST, prefix='tools')
        spare_part_formset = SparePartFormSet(request.POST, prefix='spare_parts')

        if form.is_valid() and task_formset.is_valid() and tool_formset.is_valid() and spare_part_formset.is_valid():
            # Save Maintenance
            maintenance = form.save(commit=False)
            maintenance.maintenance_type = 'manual'
            maintenance.save()
            form.save_m2m()  # Save ManyToMany fields (e.g., documentation)

            # Save Tasks
            tasks = task_formset.save(commit=False)
            for task in tasks:
                task.maintenance = maintenance
                task.save()

                # Process ChecklistItemFormSet for checklist tasks
                if task.task_type == 'checklist':
                    checklist_formset = ChecklistItemFormSet(
                        request.POST,
                        prefix=f'task_{task.id}_checklist',
                        instance=task
                    )
                    if checklist_formset.is_valid():
                        checklist_formset.save()

                # Process GroupTaskFormSet for group tasks
                elif task.task_type == 'group':
                    group_task_formset = GroupTaskFormSet(
                        request.POST,
                        prefix=f'task_{task.id}_group',
                        instance=task
                    )
                    if group_task_formset.is_valid():
                        group_task_formset.save()

            # Save Tools and Spare Parts
            tool_formset.instance = maintenance
            tool_formset.save()
            spare_part_formset.instance = maintenance
            spare_part_formset.save()

            return redirect('home')  # Replace with actual URL
    else:
        form = MaintenanceForm()
        task_formset = TaskFormSet(prefix='tasks')
        tool_formset = ToolFormSet(prefix='tools')
        spare_part_formset = SparePartFormSet(prefix='spare_parts')

    # Prepare checklist and group task formsets for both GET and POST requests
    task_formset_formsets = []
    for task_form in task_formset:
        task_type = None
        if task_form.is_bound:
            task_type = task_form.cleaned_data.get('task_type')
        else:
            task_type = task_form.initial.get('task_type')
            
        checklist_formset = None
        group_task_formset = None
        
        if task_type == 'checklist':
            checklist_formset = ChecklistItemFormSet(prefix=f'task_{task_form.prefix}_checklist')
        elif task_type == 'group':
            group_task_formset = GroupTaskFormSet(prefix=f'task_{task_form.prefix}_group')
            
        task_formset_formsets.append({
            'task_form': task_form,
            'checklist_formset': checklist_formset,
            'group_task_formset': group_task_formset,
        })

    context = {
        'form': form,
        'task_formset': task_formset,
        'task_formset_formsets': task_formset_formsets,
        'tool_formset': tool_formset,
        'spare_part_formset': spare_part_formset,
    }
    return render(request, 'mrp/maintenance/workorder/create_work_order.html', context)

