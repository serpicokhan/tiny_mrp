from django.db import models
from django.contrib.auth.models import User
import jdatetime
from django.utils import timezone

import os
import json
from mrp.models import SysUser,Asset2,Part
class PurchaseRequest(models.Model):
    def has_attachment(self):
        # files
        return self.files.select_related('file').all().count()>0



    def getItems(self):
        items = self.items.select_related('item_name').all()
        item_details = [f"{item.item_name.partName} (تعداد: {item.quantity}) (موردمصرف :{item.consume_place})" for item in items]  # Assuming Part model has a 'name' field
        return ", ".join(item_details)
    # def getItems(self):
    #     items = self.items.select_related('item_name').all()
    #     rows = [
    #         f"<li>Item Name: {item.item_name.partName} (Quantity: {item.quantity}, Consume Place: {item.consume_place})</li>"
    #         for item in items
    #     ]
    #     return f"<ul>{''.join(rows)}</ul>"  # Wrap items in an unordered list

    def getItems2(self):
        items = self.items.select_related('item_name').all()
        rows = [
            f"نام کالا: {item.item_name.partName}, تعداد: {item.quantity}, مکان: {item.consume_place}"
            for item in items
        ]
        return "\n".join(rows)  # Join rows with newline for better readability
    def get_dateCreated_jalali(self):
        return jdatetime.date.fromgregorian(date=self.created_at)
    def get_purchase_status_color(self):
        if self.status == "Rejected":
            return "danger"
        elif self.status == "Approved":
            return "success"
        elif self.status == "Pending":
            return "info"
        elif self.status == "Approve2":
            return "warning"
        elif self.status == "Approve3":
            return "primary"
        else:
            return "secondary"  # Neutral color for unknown statuses
    def add_viewer(self, user):
        """Function to add a user to the viewed_by field (serialized list)"""
        viewed_by_list = json.loads(self.viewed_by)  # Convert the string to a Python list
        if user not in viewed_by_list:
            viewed_by_list.append(user)  # Add the user ID to the list
            self.viewed_by = json.dumps(viewed_by_list)  # Serialize the list back to a string
            self.save()  # Save the updated PurchaseRequest with the new viewer
    def get_viwer(self):
        return json.loads(self.viewed_by)
    """Represents a purchase request submitted by an employee."""


    user = models.ForeignKey(SysUser, on_delete=models.CASCADE, related_name='purchase_requests')
    created_at = models.DateField(auto_now_add=False, default=timezone.now)
    is_emergency = models.BooleanField(default=False)
    viewed_by = models.TextField(blank=True, default='[]')
    status = models.CharField(
        max_length=20,
        choices=[('Pending', 'درخواست شده'), ('Approved', 'تایید انبار'), ('Rejected', 'رد شده'),
                  ('Ordered', 'سفارش '), ('Approve2', 'تایید مهندس اعزامی'),
            ('Approve3', 'تایید مهندس ارزنده')],
        default='Pending'
    )
    

    def __str__(self):
        return f"درخواست {self.id} توسط {self.user}"


class RequestItem(models.Model):
    """Represents an individual item in a purchase request."""
    purchase_request = models.ForeignKey(PurchaseRequest, on_delete=models.CASCADE, related_name='items')
    item_name  =models.ForeignKey(Part, on_delete=models.CASCADE, related_name='consume_place')
    consume_place =models.ForeignKey(Asset2, on_delete=models.CASCADE, related_name='consume_place')

    description = models.TextField(blank=True, null=True)
    price=models.FloatField(default=0)
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
class PurchaseRequestFile(models.Model):
    # Foreign Key to the PurchaseRequest model
    purchase_request = models.ForeignKey(PurchaseRequest, on_delete=models.CASCADE, related_name='files')

    # File field to store the uploaded file
    file = models.FileField(upload_to='purchase_requests/files/')

    # Optional: Timestamp when the file was uploaded
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
         return os.path.basename(self.file.name)
class Comment(models.Model):
    purchase_request = models.ForeignKey(
        PurchaseRequest, on_delete=models.CASCADE, related_name='comments'
    )
    user = models.ForeignKey(SysUser, on_delete=models.CASCADE)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    parent = models.ForeignKey(
        'self', on_delete=models.CASCADE, null=True, blank=True, related_name='replies'
    )

    def __str__(self):
        return f"Comment by {self.user} on {self.purchase_request}"