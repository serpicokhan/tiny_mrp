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
         fields = '__all__'
class BomComponentForm(forms.ModelForm):
    class Meta:
         model = BOMComponent
         fields = '__all__'
