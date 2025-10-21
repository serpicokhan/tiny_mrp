from django.db import models
from django.core.validators import MinValueValidator
from datetime import datetime, timedelta
import jdatetime

MO_STATUS = [
    ('draft', 'Draft'),
    ('confirmed', 'Confirmed'),
    ('in_progress', 'In Progress'),
    ('done', 'Done'),
    ('cancelled', 'Cancelled'),
]

WO_STATUS = [
    ('planned', 'Planned'),
    ('in_progress', 'In Progress'),
    ('done', 'Done'),
    ('cancelled', 'Cancelled'),
]
class Line(models.Model):
    name = models.CharField(max_length=100)
    capacity_per_day = models.PositiveIntegerField()

    def __str__(self):
        return self.name

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
    product = models.ForeignKey(Product, on_delete=models.CASCADE,limit_choices_to={'product_type__in': ['component', 'raw']},verbose_name="محصول")
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
    

    
class WorkOrderTemplate(models.Model):
    """Model representing a reusable template for work orders."""
    name = models.CharField(max_length=200)
    code = models.CharField(max_length=50, unique=True)
    bom = models.ForeignKey(
        BillOfMaterials,
        on_delete=models.CASCADE,
        related_name='work_order_templates',
        help_text="BoM this template is associated with"
    )
    description = models.TextField(blank=True, help_text="Optional description of the template")
    active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['name']
        constraints = [
            models.UniqueConstraint(fields=['bom', 'code'], name='unique_template_per_bom')
        ]

    def __str__(self):
        return f"{self.name} ({self.code}) - {self.bom}"

class Operation(models.Model):
    """Model representing an operation within a work order template."""
    work_order_template = models.ForeignKey(
        WorkOrderTemplate,
        on_delete=models.CASCADE,
        related_name='operations'
    )
    work_center = models.ForeignKey(WorkCenter, on_delete=models.CASCADE)
    sequence = models.PositiveIntegerField(
        help_text="Order in which this operation is performed"
    )
    name = models.CharField(max_length=200, help_text="Name of the operation")
    duration = models.FloatField(
        validators=[MinValueValidator(0.0)],
        help_text="Expected duration in hours"
    )
    instructions = models.TextField(
        blank=True,
        help_text="Instructions for the operator"
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['sequence', 'name']
        constraints = [
            models.UniqueConstraint(
                fields=['work_order_template', 'sequence'],
                name='unique_sequence_per_template'
            ),
            models.CheckConstraint(
                check=models.Q(duration__gt=0),
                name='duration_positive'
            )
        ]

    def __str__(self):
        return f"{self.name} (Seq: {self.sequence}) - {self.work_order_template}"
    
    
class Shade(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name
class ColorCode(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name
    
class Grade(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name
class ManufacturingOrder(models.Model):
    def get_dateCreated_jalali(self):
        return jdatetime.date.fromgregorian(date=self.created_at)
    def get_status_color(self):
        status_colors = {
            'draft': 'secondary',
            'confirmed': 'primary', 
            'progress': 'warning',
            'done': 'success',
            'canceled': 'danger'
        }
        return status_colors.get(self.status, 'secondary')
    
    def can_change_status(self, new_status):
        """بررسی امکان تغییر وضعیت"""
        valid_transitions = {
            'draft': ['confirmed', 'canceled'],
            'confirmed': ['progress', 'canceled'],
            'progress': ['done', 'canceled'],
            'done': [],
            'canceled': ['draft']
        }
        return new_status in valid_transitions.get(self.status, [])
    """Model representing a manufacturing order in the MRP system."""
    HB_TYPE_CHOICES = [
        ('HS', 'HS'),
        ('HB', 'HB'),
    ]
    reference = models.CharField(max_length=50, unique=True)
    line = models.ForeignKey(
        Line,
        on_delete=models.SET_NULL,
        blank=True,null=True,
        
        related_name="orderd_line"
    )
    product_to_manufacture = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        limit_choices_to={'product_type': 'finished'}
    )
    quantity_to_produce = models.FloatField(validators=[MinValueValidator(0.0)])
    bom = models.ForeignKey(BillOfMaterials, on_delete=models.CASCADE)
    work_order_template = models.ForeignKey(
        'WorkOrderTemplate',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        help_text="Template for generating work orders"
    )  # Added to link to template
    status = models.CharField(max_length=20, choices=MO_STATUS, default='draft')
    scheduled_date = models.DateField()
    first_date = models.DateField(null=True,blank=True)
    second_date = models.DateField(null=True,blank=True)
    
    responsible = models.ForeignKey(
        'SysUser',
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )
    customer = models.ForeignKey(
        'Customer',
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    notes=models.TextField(null=True,blank=True)
    hb_type = models.CharField(max_length=2, choices=HB_TYPE_CHOICES, verbose_name="هایبالک/رگولار",blank=True,null=True)
    shade = models.ForeignKey(Shade, on_delete=models.PROTECT, verbose_name="شید/رنگ",blank=True,null=True)
    color_code = models.ForeignKey(ColorCode, on_delete=models.PROTECT, verbose_name="کد رنگ",blank=True,null=True)
    grade = models.ForeignKey(Grade, on_delete=models.PROTECT, verbose_name="نمره",blank=True,null=True)
    delivery_date = models.DateField(verbose_name="تاریخ تحویل",blank=True,null=True)
    class Meta:
        ordering = ['-scheduled_date', 'reference']
        constraints = [
            models.CheckConstraint(
                check=models.Q(quantity_to_produce__gt=0),
                name='quantity_to_produce_positive'
            )
        ]

    def __str__(self):
        return f"{self.reference} - {self.product_to_manufacture}"

    def generate_work_orders(self):
        """Generate work orders based on the linked work order template."""
        if not self.work_order_template:
            return  # No template linked, skip generation
        # Delete existing work orders to avoid duplicates (optional, based on your logic)
        self.work_orders.all().delete()
        # Get operations from the template
        operations = self.work_order_template.operations.order_by('sequence')
        for operation in operations:
            # Calculate start and end dates (simplified logic; adjust as needed)
            start_date = self.scheduled_date
            duration_hours = operation.duration
            end_date = start_date + timedelta(hours=duration_hours)
            WorkOrder.objects.create(
                manufacturing_order=self,
                work_center=operation.work_center,
                operation=operation,  # Link to operation for traceability
                duration=duration_hours,
                start_date=start_date,
                end_date=end_date,
                status='planned'
            )

class WorkOrder(models.Model):
    """Model representing a specific work order within a manufacturing order."""
    manufacturing_order = models.ForeignKey(
        ManufacturingOrder,
        on_delete=models.CASCADE,
        related_name='work_orders'
    )
    work_center = models.ForeignKey(WorkCenter, on_delete=models.CASCADE)
    operation = models.ForeignKey(
        Operation,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        help_text="Operation from template this work order is based on"
    )  # Added to link to template operation
    duration = models.FloatField(
        validators=[MinValueValidator(0.0)],
        help_text="Duration in hours"
    )
    status = models.CharField(max_length=20, choices=WO_STATUS, default='planned')
    start_date = models.DateTimeField()
    end_date = models.DateTimeField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['start_date']
        constraints = [
            models.CheckConstraint(
                check=models.Q(duration__gt=0),
                name='work_order_duration_positive'
            )
        ]

    def __str__(self):
        return f"WO for {self.manufacturing_order.reference} - {self.work_center}"
    
class Customer(models.Model):
    """Model representing a customer in the MRP system."""

    name = models.CharField(
        max_length=100,
        help_text="Full name or company name of the customer"
    )
    email = models.EmailField(
        null=True,
        blank=True,
        help_text="Customer's contact email"
    )


    class Meta:
        ordering = ['name']
        constraints = [
            models.UniqueConstraint(fields=['name', 'email'], name='unique_customer_name_email')
        ]

    def __str__(self):
        return f"{self.name} - {self.name}"
    


    
    
class CalendarEvent(models.Model):
    order = models.ForeignKey(
        ManufacturingOrder, 
        on_delete=models.CASCADE, 
        related_name='calendar_events', 
        null=True, 
        blank=True
    )
    line = models.ForeignKey(
        Line,
        on_delete=models.CASCADE,
        related_name='calendar_events',
        verbose_name="خط تولید",
        help_text="خط تولیدی که این رویداد در آن اجرا می‌شود"
    )
    quantity = models.FloatField(default=0, verbose_name="مقدار")
    event_date = models.DateField(verbose_name="تاریخ رویداد")
    title = models.CharField(max_length=255, verbose_name="عنوان")
    type = models.CharField(
        max_length=50, 
        default='appointment',
        choices=[
            ('order', 'سفارش تولید'),
            ('vacation', 'تعطیلات'),
            ('offday', 'روز تعطیل'),
            ('maintenance', 'تعمیر و نگهداری'),
        ],
        verbose_name="نوع رویداد"
    )
    description = models.TextField(blank=True, verbose_name="توضیحات")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        verbose_name = "رویداد تقویم"
        verbose_name_plural = "رویدادهای تقویم"
        ordering = ['event_date', 'line']
        constraints = [
            models.CheckConstraint(
                check=models.Q(quantity__gte=0),
                name='calendar_event_quantity_positive'
            )
        ]

    def __str__(self):
        return f"{self.title} - {self.line.name} - {self.event_date}"

    def clean(self):
        """اعتبارسنجی سفارشی"""
        from django.core.exceptions import ValidationError
        
        # بررسی ظرفیت خط تولید
        if self.type == 'order' and self.quantity > 0:
            # محاسبه مجموع مقدار رویدادهای همان روز و خط
            same_day_events = CalendarEvent.objects.filter(
                event_date=self.event_date,
                line=self.line,
                type='order'
            ).exclude(pk=self.pk)
            
            total_quantity = sum(event.quantity for event in same_day_events)
            
            if total_quantity + self.quantity > self.line.capacity_per_day:
                raise ValidationError(
                    f"ظرفیت خط {self.line.name} در تاریخ {self.event_date} "
                    f"تکمیل است. ظرفیت باقی‌مانده: "
                    f"{self.line.capacity_per_day - total_quantity} کیلوگرم"
                )