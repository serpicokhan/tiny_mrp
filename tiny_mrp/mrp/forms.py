from django import forms
from django.forms import modelformset_factory
from mrp.models import *
from django.forms import inlineformset_factory
from .models import Maintenance, Task, ChecklistItem, GroupTask, Tool, SparePart
from persiantools.jdatetime import JalaliDate
class ZayeatVaznForm(forms.ModelForm):
    class Meta:
         model = ZayeatVaz
         fields = '__all__'

class AssetFailureForm(forms.ModelForm):
    asset_name= forms.ModelChoiceField(label="نام مکان",queryset=Asset.objects.filter(assetTypes=3),empty_label=None,
    widget=forms.Select(attrs={'class':'selectpicker','data-live-search':'true'}),required=False)
    class Meta:
         model = AssetFailure
         fields = '__all__'
class FinancialProfileForm(forms.ModelForm):
    class Meta:
         model = FinancialProfile
         fields = '__all__'

class FailureForm(forms.ModelForm):
    class Meta:
         model = Failure
         fields = '__all__'
class ShiftForm(forms.ModelForm):
    class Meta:
         model = Shift
         fields = '__all__'
class TolidPadashForm(forms.ModelForm):
    class Meta:
         model = TolidPadash
         exclude = ('profile',)
class NezafatPadashForm(forms.ModelForm):
    class Meta:
         model = NezafatPadash
         exclude = ('profile',)
class AssetFailureForm2(forms.Form):
    asset_name = forms.ModelMultipleChoiceField(
        queryset=Asset.objects.filter(assetTypes=3).order_by('assetCategory__priority','assetTavali'),
        widget=forms.SelectMultiple,
        label="نام تجهیز",
        required=True
    )
    shift = forms.ModelMultipleChoiceField(
        queryset=Shift.objects.all(),
        label="نام شیفت",
        required=True
    )
    duration = forms.TimeField(label="مدت توقف", required=True)
    failure_name = forms.ModelChoiceField(
        queryset=Failure.objects.all(),
        label="علت توقف",
        required=True
    )
    dayOfIssue = forms.DateField(label="تاریخ", required=True)

class HeatsetMetrajForm(forms.Form):
    metrajdaf1 = forms.IntegerField(initial=0,label='متراز داف 1')
    metrajdaf2 = forms.IntegerField(initial=0,label='متراز داف 2')
    metrajdaf3 = forms.IntegerField(initial=0,label='متراز داف 3')
    metrajdaf4 = forms.IntegerField(initial=0,label='متراز داف 4')
    metrajdaf5 = forms.IntegerField(initial=0,label='متراز داف 5')
    metrajdaf6 = forms.IntegerField(initial=0,label='متراز داف 6')
    metrajdaf7 = forms.IntegerField(initial=0,label='متراز داف 7')
    metrajdaf8 = forms.IntegerField(initial=0,label='متراز داف 8')
    makhraj_metraj_daf = forms.IntegerField(initial=0,label='مخرج متراز داف')
class AssetRandemanInitForm(forms.ModelForm):

    class Meta:
         model = AssetRandemanInit
         exclude = ('profile',)
         

class AssetRandemanForm(forms.ModelForm):
    SAL_CHOICES = (
        (1402, '1402'),
        (1403, '1403'),
        (1404, '1404'),
    )

    MAH_CHOICES = (
         (1, "فروردین"),
        (2, "اردیبهشت"),
        (3, "خرداد"),
        (4, "تیر"),
        (5, "مرداد"),
        (6, "شهریور"),
        (7, "مهر"),
        (8, "آبان"),
        (9, "آذر"),
        (10, "دی"),
        (11, "بهمن"),
        (12, "اسفند")
        # Add other months here based on Hijri Shamsi calendar
    )

    sal = forms.ChoiceField(choices=SAL_CHOICES, label='سال')
    mah = forms.ChoiceField(choices=MAH_CHOICES, label='ماه')
    class Meta:
         model = AssetRandemanList
         fields = '__all__'

class EntryFormForm(forms.ModelForm):
    class Meta:
        model = EntryForm
        fields = ['color', 'name', 'tool', 'la']
class AssetDetailForm(forms.ModelForm):
    class Meta:
        model = AssetDetail
        fields = ['asset_category', 'nomre', 'speed']
# Create a formset for AssetDetail
AssetDetailFormSet = modelformset_factory(
    AssetDetail,
    form=AssetDetailForm,
    extra=0,  # No extra blank forms; we populate dynamically
    can_delete=False
)
class SysUserForm(forms.ModelForm):
    #CustomerId = forms.ModelChoiceField(queryset=Customer.objects.all())



    class Meta:
        model = SysUser
        fields = '__all__'

class PurchaseRequestFileForm(forms.ModelForm):
    class Meta:
        model = PurchaseRequestFile
        fields = ['purchase_request', 'file']
class MaintenanceForm(forms.ModelForm):
    due_date = forms.CharField(
        widget=forms.TextInput(attrs={'type': 'date'}),
        label='تاریخ سررسید',
        required=True
    )

    class Meta:
        model = Maintenance
        fields = [
            'title', 'equipment', 'operation_type', 'priority',
            'assigned_to', 'due_date', 'description',
            'safety_instructions', 'completion_notes',
            'approval_required', 'approval_role', 'documentation'
        ]
        widgets = {
            'description': forms.Textarea(attrs={'rows': 2}),
            'safety_instructions': forms.Textarea(attrs={'rows': 3}),
            'completion_notes': forms.Textarea(attrs={'rows': 2}),
            'equipment': forms.Select(attrs={'class': 'form-select'}),
            'operation_type': forms.Select(attrs={'class': 'form-select'}),
            'priority': forms.Select(attrs={'class': 'form-select'}),
            'assigned_to': forms.Select(attrs={'class': 'form-select'}),
            'approval_role': forms.Select(attrs={'class': 'form-select'}),
            'documentation': forms.SelectMultiple(attrs={'class': 'form-select'}),
            'approval_required': forms.CheckboxInput(attrs={'class': 'form-check-input'}),
        }

    def clean_due_date(self):
        jalali_date_str = self.cleaned_data.get('due_date')
        if jalali_date_str:
            try:
                # jalali_date = JalaliDate.parse(jalali_date_str.replace('-', '/'))
                return datetime.now()
            except ValueError:
                raise forms.ValidationError("فرمت تاریخ نامعتبر است.")
        return None

    def clean(self):
        cleaned_data = super().clean()
        cleaned_data['maintenance_type'] = 'manual'  # تنظیم نوع به دستی
        return cleaned_data

class TaskForm(forms.ModelForm):
    class Meta:
        model = Task
        fields = ['task_type', 'title', 'description', 'order']
        widgets = {
            'task_type': forms.Select(attrs={'class': 'form-select'}),
            'title': forms.TextInput(attrs={'class': 'form-control'}),
            'description': forms.TextInput(attrs={'class': 'form-control'}),
            'order': forms.HiddenInput(),
        }

class ChecklistItemForm(forms.ModelForm):
    class Meta:
        model = ChecklistItem
        fields = ['description', 'order']
        widgets = {
            'description': forms.TextInput(attrs={'class': 'form-control'}),
            'order': forms.HiddenInput(),
        }

class GroupTaskForm(forms.ModelForm):
    class Meta:
        model = GroupTask
        fields = ['description', 'subtask_type', 'order']
        widgets = {
            'description': forms.TextInput(attrs={'class': 'form-control'}),
            'subtask_type': forms.Select(attrs={'class': 'form-select'}),
            'order': forms.HiddenInput(),
        }

class ToolForm(forms.ModelForm):
    class Meta:
        model = Tool
        fields = ['name']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control'}),
        }

class SparePartForm(forms.ModelForm):
    class Meta:
        model = SparePart
        fields = ['name', 'part_code', 'quantity']
        widgets = {
            'name': forms.TextInput(attrs={'class': 'form-control'}),
            'part_code': forms.TextInput(attrs={'class': 'form-control'}),
            'quantity': forms.NumberInput(attrs={'class': 'form-control', 'min': 1}),
        }

# فرم‌ست‌ها برای روابط چندگانه
TaskFormSet = inlineformset_factory(
    Maintenance, Task, form=TaskForm, extra=0, can_delete=True
)
ChecklistItemFormSet = inlineformset_factory(
    Task, ChecklistItem, form=ChecklistItemForm, extra=0, can_delete=True
)
GroupTaskFormSet = inlineformset_factory(
    Task, GroupTask, form=GroupTaskForm, extra=0, can_delete=True
)
ToolFormSet = inlineformset_factory(
    Maintenance, Tool, form=ToolForm, extra=0, can_delete=True
)
SparePartFormSet = inlineformset_factory(
    Maintenance, SparePart, form=SparePartForm, extra=0, can_delete=True
)