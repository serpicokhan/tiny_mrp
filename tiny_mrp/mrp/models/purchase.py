from django.db import models
from django.contrib.auth.models import User
import jdatetime
from django.utils import timezone
from django.utils.timezone import now

import os
import json
from mrp.models import SysUser,Asset2,Part
class PurchaseRequest(models.Model):
    def has_attachment(self):
        # files
        return self.files.select_related('file').all().count()>0
    def has_faktor(self):
        # files
        return self.faktors.select_related('file').all().count()>0
    def has_rfq(self):
        # files
        return self.items.filter(rfqitem__isnull=False).exists()
    def has_mgm_comment(self):
        # files
        return len(self.manager_comment)>0
    def has_comment(self):
        # files
        return self.comments.select_related('content').all().count()>0
    def get_comment(self):
        # files
        return self.comments.all()

    def has_comment_by_user(self, user):
        """
        Check if the given user has commented on this purchase request.
        """
        return self.notes.filter(user=user).exists()

    def getItems(self):
        items = self.items.select_related('item_name').all()
        item_details = [f"{item.item_name.partName} (تعداد: {item.quantity}) (موردمصرف :{item.consume_place})" for item in items]  # Assuming Part model has a 'name' field
        return ", ".join(item_details)
    def getItems3(self):
        number_emojis = ['1️⃣', '2️⃣', '3️⃣', '4️⃣', '5️⃣', '6️⃣', '7️⃣', '8️⃣', '9️⃣', '🔟']
        items = self.items.select_related('item_name').all()
        # item_details = [f"1️⃣ {item.item_name.partName} (تعداد: {item.quantity}) (موردمصرف :{item.consume_place})" for item in items]  # Assuming Part model has a 'name' field
        item_details = [
            f"{number_emojis[i]} {item.item_name.partName} (تعداد: {item.quantity}) (موردمصرف: {item.consume_place})"
            for i, item in enumerate(items)
        ]
        return "\n".join(item_details)
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
    manager_comment = models.TextField(blank=True, default='')
    status = models.CharField(
        max_length=20,
        choices=[
            ('Pending', 'درخواست شده'),
            ('Approved', 'تایید انبار'),
            ('Rejected', 'رد شده'),
            ('Ordered', 'سفارش '),
            ('Approve2', 'تایید مهندس اعزامی'),
            ('Approve3', 'تایید مهندس ارزنده'),
            ('Purchased', 'خریداری شد'),
            ('Approve4', 'تایید بازرگانی'),
            ('GuardApproved', 'تأیید نگهبانی'),  # وضعیت جدید
            ('Completed', 'کامل شده')  # وقتی همه آیتم‌ها تأمین و تأیید شدن
            ],
        default='Pending'
    )
    def is_fully_supplied(self):
        return all(item.is_fully_supplied() for item in self.items.all())
    def update_status(self):
        if self.is_fully_supplied():
            all_guard_approved = all(
                entry.guard_approved 
                for item in self.items.all() 
                for entry in item.entries.all()
            )
            if all_guard_approved:
                self.status = 'Completed'
            elif self.status != 'GuardApproved':
                self.status = 'GuardApproved'
        self.save()

    

    def __str__(self):
        return f"درخواست {self.id} توسط {self.user}"


class RequestItem(models.Model):
    """Represents an individual item in a purchase request."""
    purchase_request = models.ForeignKey(PurchaseRequest, on_delete=models.CASCADE, related_name='items')
    item_name  =models.ForeignKey(Part, on_delete=models.CASCADE, related_name='consume_part')
    consume_place =models.ForeignKey(Asset2, on_delete=models.CASCADE, related_name='consume_place')

    description = models.TextField(blank=True, null=True)
    price=models.FloatField(default=0)
    quantity = models.PositiveIntegerField()
    supplied_quantity = models.PositiveIntegerField(default=0)
    supplier_assigned = models.ForeignKey(
        'Supplier', 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True, 
        related_name='assigned_items',
        help_text="Supplier who can provide this item"
    )
    def is_fully_supplied(self):
        return self.supplied_quantity >= self.quantity

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
    supplier = models.ForeignKey(Supplier, on_delete=models.CASCADE, related_name='rfqsupplier')
    items = models.ForeignKey(RequestItem,on_delete=models.CASCADE, related_name='rfqitem',null=True,blank=True)
    issued_by = models.ForeignKey(SysUser, on_delete=models.CASCADE, related_name='rfquser',null=True,blank=True)
    total_price = models.DecimalField(max_digits=10, decimal_places=0)

    issued_at = models.DateTimeField(auto_now_add=True)
    description = models.TextField(blank=True, null=True)
    is_verified = models.BooleanField(default=False)



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
class PurchaseRequestFaktor(models.Model):
    # Foreign Key to the PurchaseRequest model
    purchase_request = models.ForeignKey(PurchaseRequest, on_delete=models.CASCADE, related_name='faktors')

    # File field to store the uploaded file
    file = models.FileField(upload_to='purchase_requests/faktors/')

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
    
class PurchaseNotes(models.Model):
    purchase_request = models.ForeignKey(
        PurchaseRequest, on_delete=models.CASCADE, related_name='notes'
    )
    user = models.ForeignKey(SysUser, on_delete=models.CASCADE)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)    

    def __str__(self):
        return f"Comment by {self.user} on {self.purchase_request}"
class PurchaseActivityLog(models.Model):
    user = models.ForeignKey(SysUser, on_delete=models.SET_NULL, null=True, blank=True)
    purchase_request = models.ForeignKey('PurchaseRequest', on_delete=models.CASCADE,related_name='plogs')
    action = models.CharField(max_length=255)
    timestamp = models.DateTimeField(default=now)

    def __str__(self):
        return f"{self.user} {self.action} on {self.purchase_request}"
    def get_dateCreated_jalali(self):
        return jdatetime.date.fromgregorian(date=self.timestamp) 
class GoodsEntry(models.Model):
    request_item = models.ForeignKey(RequestItem, on_delete=models.CASCADE, related_name='entries')
    entry_date = models.DateField(default=timezone.now)
    quantity_received = models.PositiveIntegerField(help_text="تعداد کالای وارد شده در این ورود")
    guard_approved = models.BooleanField(default=False, help_text="تأیید شده توسط نگهبانی")
    guard_comment = models.TextField(blank=True, null=True, help_text="توضیحات نگهبان در صورت رد")
    supplier = models.ForeignKey(
        'Supplier', 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True, 
        related_name='delivered_entries'
    )

    def save(self, *args, **kwargs):
        super().save(*args, **kwargs)
        # به‌روزرسانی supplied_quantity در RequestItem
        total_received = self.request_item.entries.aggregate(total=models.Sum('quantity_received'))['total'] or 0
        self.request_item.supplied_quantity = total_received
        self.request_item.save()

    def __str__(self):
        return f"ورود {self.quantity_received} عدد از {self.request_item.item_name} در {self.entry_date}"

