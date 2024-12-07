from django.db import models
from django.contrib.auth.models import User
from mrp.models import SysUser,Asset,Part
class PurchaseRequest(models.Model):
    """Represents a purchase request submitted by an employee."""
    user = models.ForeignKey(SysUser, on_delete=models.CASCADE, related_name='purchase_requests')
    created_at = models.DateTimeField(auto_now_add=True)
    status = models.CharField(
        max_length=20,
        choices=[('Pending', 'Pending'), ('Approved', 'Approved'), ('Rejected', 'Rejected'), ('Ordered', 'Ordered')],
        default='Pending'
    )
    

    def __str__(self):
        return f"Request {self.id} by {self.user.username}"


class RequestItem(models.Model):
    """Represents an individual item in a purchase request."""
    purchase_request = models.ForeignKey(PurchaseRequest, on_delete=models.CASCADE, related_name='items')
    item_name  =models.ForeignKey(Part, on_delete=models.CASCADE, related_name='consume_place')
    consume_place =models.ForeignKey(Asset, on_delete=models.CASCADE, related_name='consume_place')

    description = models.TextField(blank=True, null=True)

    quantity = models.PositiveIntegerField()
    supplier_assigned = models.ForeignKey(
        'Supplier', 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True, 
        related_name='assigned_items',
        help_text="Supplier who can provide this item"
    )

    def __str__(self):
        return f"{self.item_name} (x{self.quantity})"

    def is_assigned(self):
        """Check if the item has been assigned to a supplier."""
        return self.supplier_assigned is not None


class Supplier(models.Model):
    """Represents a supplier who can provide requested items."""
    name = models.CharField(max_length=255)
    email = models.EmailField()
    phone = models.CharField(max_length=15, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    provided_items = models.ManyToManyField(
        'RequestItem',
        related_name='potential_suppliers',
        blank=True,
        help_text="Items that this supplier can provide"
    )

    def __str__(self):
        return self.name


class RFQ(models.Model):
    """Represents a Request for Quotation (RFQ) for a supplier to provide specific items."""
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name='rfqs')
    items = models.ManyToManyField(RequestItem, related_name='rfqs')
    issued_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='rfqs')
    issued_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"RFQ for Supplier {self.supplier.name}"


class SupplierResponse(models.Model):
    """Represents a supplier's response to an RFQ."""
    rfq = models.ForeignKey(RFQ, on_delete=models.CASCADE, related_name='responses')
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name='responses')
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    payment_terms = models.TextField()
    arrival_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Response from {self.supplier.name} for RFQ {self.rfq.id}"


class Order(models.Model):
    """Represents an order placed with a supplier for specific items."""
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name='orders')
    items = models.ManyToManyField(RequestItem, related_name='orders')
    total_price = models.DecimalField(max_digits=10, decimal_places=2)
    payment_terms = models.TextField()
    arrival_date = models.DateField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Order for Supplier {self.supplier.name}"