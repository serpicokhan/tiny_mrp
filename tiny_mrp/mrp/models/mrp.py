from django.db import models
from django.core.validators import MinValueValidator

class Product(models.Model):
    """Model representing products (raw materials or finished goods) in the MRP system."""
    
    # Product type choices
    RAW_MATERIAL = 'raw'
    FINISHED_GOOD = 'finished'
    COMPONENT = 'component'
    PRODUCT_TYPES = [
        (RAW_MATERIAL, 'Raw Material'),
        (FINISHED_GOOD, 'Finished Good'),
        (COMPONENT, 'Component'),
    ]
    
    # Unit of measure choices
    UNITS = 'units'
    KILOGRAMS = 'kg'
    GRAMS = 'g'
    LITERS = 'l'
    MILLILITERS = 'ml'
    METERS = 'm'
    CENTIMETERS = 'cm'
    UOM_CHOICES = [
        (UNITS, 'Units'),
        (KILOGRAMS, 'Kilograms'),
        (GRAMS, 'Grams'),
        (LITERS, 'Liters'),
        (MILLILITERS, 'Milliliters'),
        (METERS, 'Meters'),
        (CENTIMETERS, 'Centimeters'),
    ]
    
    name = models.CharField("نام محصول",max_length=200)
    code = models.CharField("کد محصول",max_length=50, unique=True)
    product_type = models.CharField("نوع محصول",max_length=20, choices=PRODUCT_TYPES)
    unit_of_measure = models.CharField("واحد اندازه گیری",max_length=50, choices=UOM_CHOICES)
    cost_price = models.DecimalField("قیمت تمام شده",max_digits=10, decimal_places=2)
    sale_price = models.DecimalField("قیمت فروش",max_digits=10, decimal_places=2)
    available_quantity = models.FloatField("موجودی",
        default=0,
        validators=[MinValueValidator(0.0)]
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['name']
        verbose_name = 'Product'
        verbose_name_plural = 'Products'

    def __str__(self):
        return f"{self.name} ({self.code})"
    
    def get_stock_status(self):
        """Returns the stock status as a string."""
        if self.available_quantity <= 0:
            return 'out_of_stock'
        elif self.available_quantity <= 10:
            return 'low_stock'
        return 'in_stock'
    
    def clean(self):
        """Custom validation for the product model."""
        super().clean()
        
        # Ensure sale price is greater than cost price
        if self.sale_price <= self.cost_price:
            raise ValidationError("Sale price must be greater than cost price.")

class UnitOfMeasure(models.Model):
    name = models.CharField(max_length=20)
    abbreviation = models.CharField(max_length=10)
    
    def __str__(self):
        return self.abbreviation     
class BOMComponent(models.Model):
    """Through model for Bill of Materials components with quantity."""
    bom = models.ForeignKey('BillOfMaterials', on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE,limit_choices_to={'product_type': 'component'},verbose_name="محصول")
    quantity = models.FloatField("تعداد",validators=[MinValueValidator(0.0)])
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    uom = models.ForeignKey(UnitOfMeasure, on_delete=models.PROTECT,verbose_name="واحد اندازه گیری")

    class Meta:
        ordering = ['product__name']

    def __str__(self):
        return f"{self.product.name} - {self.quantity}"


class BillOfMaterials(models.Model):
    """Model representing a Bill of Materials for manufacturing a product."""
    reference = models.CharField("کد",max_length=50, unique=True)
    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        related_name='boms',verbose_name="محصول",
        limit_choices_to={'product_type': 'finished'}
    )
    components = models.ManyToManyField(Product, through=BOMComponent, related_name='used_in_boms',null=True,blank=True)
    operation_time = models.FloatField("زمان عملیات",
        validators=[MinValueValidator(0.0)],
        help_text="Time in minutes"
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['reference']

    def __str__(self):
        return self.reference
class WorkCenter(models.Model):
    """Model representing a work center where manufacturing operations occur."""
    name = models.CharField("نام",max_length=200)
    code = models.CharField("کد",max_length=50, unique=True)
    capacity_per_hour = models.FloatField("ظرفیت بر ساعت",validators=[MinValueValidator(0.0)])
    active = models.BooleanField("فعال",default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['name']

    def __str__(self):
        return f"{self.name} ({self.code})"