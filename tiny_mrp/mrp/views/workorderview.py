from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
# from mrp.forms import MaintenanceForm, TaskFormSet, ChecklistItemFormSet, GroupTaskFormSet, ToolFormSet, SparePartFormSet
# from mrp.models import Maintenance, Task

def list_workorder(request):
    return render(request,"mrp/maintenance/workorder/woList.html",{})

# @login_required
# def create_work_order(request):
#     if request.method == 'POST':
#         form = MaintenanceForm(request.POST)
#         task_formset = TaskFormSet(request.POST, prefix='tasks')
#         tool_formset = ToolFormSet(request.POST, prefix='tools')
#         spare_part_formset = SparePartFormSet(request.POST, prefix='spare_parts')

#         # فرم‌ست‌های وظایف پیچیده
#         checklist_formsets = []
#         group_task_formsets = []

#         if form.is_valid() and task_formset.is_valid() and tool_formset.is_valid() and spare_part_formset.is_valid():
#             # ذخیره Maintenance
#             maintenance = form.save(commit=False)
#             maintenance.maintenance_type = 'manual'
#             maintenance.save()

#             # ذخیره وظایف
#             tasks = task_formset.save(commit=False)
#             for task in tasks:
#                 task.maintenance = maintenance
#                 task.save()

#                 # پردازش فرم‌ست‌های ChecklistItem و GroupTask
#                 if task.task_type == 'checklist':
#                     checklist_formset = ChecklistItemFormSet(
#                         request.POST,
#                         prefix=f'task_{task.id}_checklist',
#                         instance=task
#                     )
#                     if checklist_formset.is_valid():
#                         checklist_formset.save()
#                     else:
#                         checklist_formset = None  # برای جلوگیری از خطا

#                 elif task.task_type == 'group':
#                     group_task_formset = GroupTaskFormSet(
#                         request.POST,
#                         prefix=f'task_{task.id}_group',
#                         instance=task
#                     )
#                     if group_task_formset.is_valid():
#                         group_task_formset.save()
#                     else:
#                         group_task_formset = None

#             # ذخیره ابزارها و قطعات
#             tool_formset.instance = maintenance
#             tool_formset.save()
#             spare_part_formset.instance = maintenance
#             spare_part_formset.save()

#             # ذخیره مستندات (به‌صورت دستی، چون multiple select است)
#             form.save_m2m()

#             return redirect('home')  # تغییر به URL مقصد واقعی
#     else:
#         form = MaintenanceForm()
#         task_formset = TaskFormSet(prefix='tasks')
#         tool_formset = ToolFormSet(prefix='tools')
#         spare_part_formset = SparePartFormSet(prefix='spare_parts')

#     context = {
#         'form': form,
#         'task_formset': task_formset,
#         'tool_formset': tool_formset,
#         'spare_part_formset': spare_part_formset,
#     }
#     return render(request, 'maintenance/create_work_order.html', context)

# def edit_workorder(request):
#     return render(request,"mrp/maintenance/workorder/woEdit.html",{})

# def delete_workorder(request):
#     return render(request,"mrp/maintenance/workorder/woDelete.html",{})

# def view_workorder(request):
#     return render(request,"mrp/maintenance/workorder/woView.html",{})


