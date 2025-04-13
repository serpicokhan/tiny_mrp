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
    
    name = models.CharField(max_length=200)
    code = models.CharField(max_length=50, unique=True)
    product_type = models.CharField(max_length=20, choices=PRODUCT_TYPES)
    unit_of_measure = models.CharField(max_length=50, choices=UOM_CHOICES)
    cost_price = models.DecimalField(max_digits=10, decimal_places=2)
    sale_price = models.DecimalField(max_digits=10, decimal_places=2)
    available_quantity = models.FloatField(
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