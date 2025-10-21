from django import forms
from mrp.models import *
class ZayeatVaznForm(forms.ModelForm):
    class Meta:
         model = ZayeatVaz
         fields = '__all__'

class AssetFailureForm(forms.ModelForm):
    asset_name= forms.ModelChoiceField(label="نام مکان",queryset=Asset.objects.filter(assetIsLocatedAt__isnull=False),empty_label=None,
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
        queryset=Asset.objects.filter(assetIsLocatedAt__isnull=False),
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
class SysUserForm(forms.ModelForm):
    #CustomerId = forms.ModelChoiceField(queryset=Customer.objects.all())



    class Meta:
        model = SysUser
        fields = '__all__'

class PurchaseRequestFileForm(forms.ModelForm):
    class Meta:
        model = PurchaseRequestFile
        fields = ['purchase_request', 'file']
class RFQForm(forms.ModelForm):
    class Meta:
        model = RFQ
        fields = ['supplier', 'items','total_price','description']
    # def clean_items(self):
    #     items = self.cleaned_data.get('items')
    #     items=RequestItem.objects.get(id=items)
    #     return items
# ////////////////////// MRP Models \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
# ////////////////////// MRP Models \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

class ProductForm(forms.ModelForm):
    """Form for creating and updating products."""
    
    class Meta:
        model = Product
        fields = [
            'name', 
            'code', 
            'product_type', 
            'unit_of_measure',
            'cost_price', 
            'sale_price', 
            'available_quantity'
        ]
        widgets = {
            'name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'نام محصول'
            }),
            'code': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'کد محصول'
            }),
            'product_type': forms.Select(attrs={
                'class': 'form-select'
            }),
            'unit_of_measure': forms.Select(attrs={
                'class': 'form-select'
            }),
            'cost_price': forms.NumberInput(attrs={
                'class': 'form-control',
                'step': '0.01',
                'min': '0'
            }),
            'sale_price': forms.NumberInput(attrs={
                'class': 'form-control',
                'step': '0.01',
                'min': '0'
            }),
            'available_quantity': forms.NumberInput(attrs={
                'class': 'form-control',
                'step': '0.01',
                'min': '0'
            }),
        }
        labels = {
            'product_type': 'نوع',
            'unit_of_measure': 'واحد اندازه گیری',
            'cost_price': 'هزینه تمام شده',
            'sale_price': 'قیمت فروش',
            'available_quantity': 'موجودی'
        }
    
    def clean(self):
        """Custom form validation."""
        cleaned_data = super().clean()
        cost_price = cleaned_data.get('cost_price')
        sale_price = cleaned_data.get('sale_price')
        
        if cost_price and sale_price and sale_price <= cost_price:
            self.add_error(
                'sale_price', 
                "Sale price must be greater than cost price."
            )
        
        return cleaned_data
class ProductFilterForm(forms.Form):
    """Form for filtering products."""
    
    # Stock status choices
    IN_STOCK = 'in_stock'
    LOW_STOCK = 'low_stock'
    OUT_OF_STOCK = 'out_of_stock'
    STOCK_CHOICES = [
        ('', 'All Stock Levels'),
        (IN_STOCK, 'In Stock'),
        (LOW_STOCK, 'Low Stock'),
        (OUT_OF_STOCK, 'Out of Stock'),
    ]
    
    search = forms.CharField(
        required=False,
        widget=forms.TextInput(attrs={
            'class': 'form-control',
            'placeholder': 'Search products...'
        })
    )
    
    product_type = forms.ChoiceField(
        required=False,
        choices=[('', 'All Types')] + Product.PRODUCT_TYPES,
        widget=forms.Select(attrs={
            'class': 'form-select'
        })
    )
    
    stock_status = forms.ChoiceField(
        required=False,
        choices=STOCK_CHOICES,
        widget=forms.Select(attrs={
            'class': 'form-select'
        })
    )
    
    def filter_queryset(self, queryset):
        """Apply filters to the queryset."""
        data = self.cleaned_data
        
        # Search by name or code
        if data.get('search'):
            search_term = data['search']
            queryset = queryset.filter(
                models.Q(name__icontains=search_term) |
                models.Q(code__icontains=search_term)
            )
        
        # Filter by product type
        if data.get('product_type'):
            queryset = queryset.filter(product_type=data['product_type'])
        
        # Filter by stock status
        if data.get('stock_status'):
            stock_status = data['stock_status']
            if stock_status == self.IN_STOCK:
                queryset = queryset.filter(available_quantity__gt=10)
            elif stock_status == self.LOW_STOCK:
                queryset = queryset.filter(
                    available_quantity__gt=0,
                    available_quantity__lte=10
                )
            elif stock_status == self.OUT_OF_STOCK:
                queryset = queryset.filter(available_quantity__lte=0)
        
        return queryset
class BOMForm(forms.ModelForm):
    class Meta:
        model = BillOfMaterials
        fields = ['reference', 'product', 'operation_time']  # بدون فیلد components
        # یا به صورت explicit فیلدها را مشخص کنید
        exclude = ['components']  # این فیلد را حذف کنید
class BomComponentForm(forms.ModelForm):
    class Meta:
         model = BOMComponent
         fields = '__all__'
class WorkCenterForm(forms.ModelForm):
    class Meta:
         model = WorkCenter
         fields = '__all__'


class ManufacturingOrderForm(forms.ModelForm):
    
    # def clean(self):
        
    #     cleaned_data = super().clean()  # Ensure parent clean is called
        
    #     scheduled_date = cleaned_data.get('scheduled_date')
    #     first_date = cleaned_data.get('first_date')
    #     second_date = cleaned_data.get('second_date')
    #     print(scheduled_date,first_date,second_date,'!!!!!!!!!!!!')

    #     # Add custom cross-field validation here if needed
    #     return cleaned_data

    class Meta:
        model = ManufacturingOrder
        fields='__all__'


    def clean_scheduled_date(self):
        print("@@@@@@@@@@@@@@@@@@")
        date_str = self.cleaned_data.get('scheduled_date')
        if not date_str:
            raise forms.ValidationError("تاریخ شروع الزامی است.")
        try:
           
            # Try parsing as Gregorian first (since input might be 2025-06-03)
            try:
                gregorian_date = DateJob.getTaskDate(date_str)
                print(gregorian_date,'!!!!!!!!!!!!')
            except ValueError:
                # Fallback to Jalali if Gregorian parsing fails
                jalali_date = jdatetime.date.fromisoformat(date_str)
                gregorian_date = jalali_date.togregorian()
            return gregorian_date
        except ValueError as e:
            raise forms.ValidationError("فرمت تاریخ شروع نامعتبر است. لطفاً از فرمت ۱۴۰۴-۰۳-۱۴ یا 2025-06-03 استفاده کنید.")
        
    def clean_second_date(self):
        print("@@@@@@@@@@@@@@@@@@")
        date_str = self.cleaned_data.get('second_date')
        if not date_str:
            raise forms.ValidationError("تاریخ شروع الزامی است.")
        try:
           
            # Try parsing as Gregorian first (since input might be 2025-06-03)
            try:
                gregorian_date = DateJob.getTaskDate(date_str)
                print(gregorian_date,'!!!!!!!!!!!!')
            except ValueError:
                # Fallback to Jalali if Gregorian parsing fails
                jalali_date = jdatetime.date.fromisoformat(date_str)
                gregorian_date = jalali_date.togregorian()
            return gregorian_date
        except ValueError as e:
            raise forms.ValidationError("فرمت تاریخ شروع نامعتبر است. لطفاً از فرمت ۱۴۰۴-۰۳-۱۴ یا 2025-06-03 استفاده کنید.")
    def clean_first_date(self):
        print("@@@@@@@@@@@@@@@@@@")
        date_str = self.cleaned_data.get('first_date')
        if not date_str:
            raise forms.ValidationError("تاریخ شروع الزامی است.")
        try:
           
            # Try parsing as Gregorian first (since input might be 2025-06-03)
            try:
                gregorian_date = DateJob.getTaskDate(date_str)
                print(gregorian_date,'!!!!!!!!!!!!')
            except ValueError:
                # Fallback to Jalali if Gregorian parsing fails
                jalali_date = jdatetime.date.fromisoformat(date_str)
                gregorian_date = jalali_date.togregorian()
            return gregorian_date
        except ValueError as e:
            raise forms.ValidationError("فرمت تاریخ شروع نامعتبر است. لطفاً از فرمت ۱۴۰۴-۰۳-۱۴ یا 2025-06-03 استفاده کنید.")
       

class ManufacturingOrderForm2(forms.ModelForm):
    class Meta:
        model = ManufacturingOrder
        fields = [
            'hb_type', 
            'shade', 
            'color_code', 
            'grade', 
            'scheduled_date',
            'customer', 
            'quantity_to_produce'
        ]
        widgets = {
            'hb_type': forms.Select(attrs={
                'class': 'form-select',
                'placeholder': 'نوع هایبالک را انتخاب کنید'
            }),
            'shade': forms.Select(attrs={
                'class': 'form-select',
                'placeholder': 'شید را انتخاب کنید'
            }),
            'color_code': forms.Select(attrs={
                'class': 'form-select', 
                'placeholder': 'کد رنگ را انتخاب کنید'
            }),
            'grade': forms.Select(attrs={
                'class': 'form-select',
                'placeholder': 'نمره را انتخاب کنید'
            }),
            'scheduled_date': forms.DateInput(attrs={
                'class': 'form-control',
                
                'placeholder': 'تاریخ تحویل'
            }),
            'customer': forms.Select(attrs={
                'class': 'form-select',
                'placeholder': 'مشتری را انتخاب کنید'
            }),
            'quantity_to_produce': forms.NumberInput(attrs={
                'class': 'form-control',
                'placeholder': 'مقدار تولید',
                'min': '0.0',
                'step': '0.1'
            })
        }
        labels = {
            'hb_type': 'نوع هایبالک',
            'shade': 'شید/رنگ',
            'color_code': 'کد رنگ',
            'grade': 'نمره',
            'scheduled_date': 'تاریخ تحویل',
            'customer': 'مشتری',
            'quantity_to_produce': 'مقدار تولید'
        }

    def clean_quantity_to_produce(self):
        quantity = self.cleaned_data.get('quantity_to_produce')
        if quantity <= 0:
            raise forms.ValidationError("مقدار تولید باید بزرگتر از صفر باشد")
        return quantity
    # def clean_delivery_date(self):
    #     print("Entering clean_delivery_date")
    #     delivery_date = self.cleaned_data.get('delivery_date')
    #     print(f"Raw delivery_date: {delivery_date}")
    #     if delivery_date:
    #         try:
    #             print("Attempting to process date")
    #             result = DateJob.getTaskDate(delivery_date)
    #             print(f"Processed date: {result}")
    #             return result
    #         except Exception as e:
    #             print(f"Error in clean_delivery_date: {str(e)}")
    #             raise forms.ValidationError(f"خطا در تبدیل تاریخ: {str(e)}")
    #     print("Returning original delivery_date")
    #     return delivery_date


class RequestItemForm(forms.ModelForm):
    # item_name = forms.CharField(
    #     required=True,
    #     widget=forms.TextInput(attrs={'disabled': 'disabled'}),
    #     label="Item Name"
    # )
    # # Define supplier_assigned as a CharField to render as a text input
    # supplier_assigned = forms.CharField(
    #     required=False,
    #     widget=forms.TextInput(attrs={'disabled': 'disabled'}),
    #     label="Supplier Assigned",
    #     help_text="Supplier who can provide this item (optional)"
    # )
    # consume_place = forms.CharField(
    #     required=False,
    #     widget=forms.TextInput(attrs={'disabled': 'disabled'}),
    #     label="consume_place",
    #     help_text="Supplier who can provide this item (optional)"
    # )

    class Meta:
        model = RequestItem
        fields = [ 'description', 'price','supplied_quantity']
        widgets = {
            'description': forms.Textarea(attrs={'rows': 4}),
        }

    


class FormulaForm(forms.ModelForm):
    class Meta:
         model = Formula
         fields = '__all__'
class ReportForm(forms.ModelForm):
    class Meta:
        model = Report
        fields = '__all__'
class MoshakhaseForm(forms.ModelForm):
    class Meta:
        model = EntryForm
        fields = '__all__'