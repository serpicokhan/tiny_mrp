from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone
from django.core.validators import FileExtensionValidator


class Department(models.Model):
    """واحد سازمانی"""
    name = models.CharField(max_length=200, verbose_name='نام واحد')
    code = models.CharField(max_length=50, unique=True, verbose_name='کد واحد')
    manager = models.ForeignKey(
        User, 
        on_delete=models.SET_NULL, 
        null=True, 
        blank=True,
        related_name='managed_departments',
        verbose_name='مدیر واحد'
    )
    parent = models.ForeignKey(
        'self', 
        on_delete=models.CASCADE, 
        null=True, 
        blank=True,
        related_name='sub_departments',
        verbose_name='واحد والد'
    )
    description = models.TextField(blank=True, verbose_name='توضیحات')
    is_active = models.BooleanField(default=True, verbose_name='فعال')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='تاریخ ایجاد')
    
    class Meta:
        verbose_name = 'واحد سازمانی'
        verbose_name_plural = 'واحدهای سازمانی'
        ordering = ['name']
    
    def __str__(self):
        return self.name


class Employee(models.Model):
    """کارمند"""
    POSITION_CHOICES = [
        ('staff', 'کارمند'),
        ('expert', 'کارشناس'),
        ('senior_expert', 'کارشناس ارشد'),
        ('supervisor', 'سرپرست'),
        ('manager', 'مدیر'),
        ('director', 'مدیر کل'),
    ]
    
    user = models.OneToOneField(User, on_delete=models.CASCADE, verbose_name='کاربر')
    employee_code = models.CharField(max_length=50, unique=True, verbose_name='کد پرسنلی')
    department = models.ForeignKey(
        Department, 
        on_delete=models.SET_NULL, 
        null=True,
        related_name='employees',
        verbose_name='واحد'
    )
    position = models.CharField(
        max_length=20, 
        choices=POSITION_CHOICES,
        default='staff',
        verbose_name='سمت'
    )
    phone = models.CharField(max_length=20, blank=True, verbose_name='تلفن داخلی')
    mobile = models.CharField(max_length=15, blank=True, verbose_name='موبایل')
    signature = models.ImageField(
        upload_to='signatures/',
        null=True,
        blank=True,
        verbose_name='امضا'
    )
    is_active = models.BooleanField(default=True, verbose_name='فعال')
    joined_date = models.DateField(null=True, blank=True, verbose_name='تاریخ استخدام')
    
    class Meta:
        verbose_name = 'کارمند'
        verbose_name_plural = 'کارمندان'
        ordering = ['user__last_name', 'user__first_name']
    
    def __str__(self):
        return f"{self.user.get_full_name()} - {self.employee_code}"
    
    @property
    def full_name(self):
        return self.user.get_full_name()


class Mail(models.Model):
    """نامه"""
    STATUS_CHOICES = [
        ('new', 'جدید'),
        ('pending', 'در انتظار'),
        ('in_progress', 'در حال بررسی'),
        ('signed', 'امضا شده'),
        ('completed', 'تکمیل شده'),
        ('archived', 'بایگانی شده'),
        ('rejected', 'رد شده'),
    ]
    
    PRIORITY_CHOICES = [
        ('normal', 'عادی'),
        ('urgent', 'فوری'),
        ('very_urgent', 'بسیار فوری'),
    ]
    
    mail_number = models.CharField(max_length=100, unique=True, verbose_name='شماره نامه')
    title = models.CharField(max_length=500, verbose_name='عنوان')
    content = models.TextField(verbose_name='متن نامه')
    
    sender = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name='sent_mails',
        verbose_name='فرستنده'
    )
    sender_department = models.ForeignKey(
        Department,
        on_delete=models.SET_NULL,
        null=True,
        related_name='sent_mails',
        verbose_name='واحد فرستنده'
    )
    
    receiver = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name='received_mails',
        null=True,
        blank=True,
        verbose_name='گیرنده'
    )
    receiver_department = models.ForeignKey(
        Department,
        on_delete=models.SET_NULL,
        null=True,
        related_name='received_mails',
        verbose_name='واحد گیرنده'
    )
    
    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='new',
        verbose_name='وضعیت'
    )
    priority = models.CharField(
        max_length=20,
        choices=PRIORITY_CHOICES,
        default='normal',
        verbose_name='اولویت'
    )
    
    is_internal = models.BooleanField(default=True, verbose_name='داخلی')
    is_confidential = models.BooleanField(default=False, verbose_name='محرمانه')
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='تاریخ ایجاد')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='تاریخ بروزرسانی')
    sent_at = models.DateTimeField(null=True, blank=True, verbose_name='تاریخ ارسال')
    
    deadline = models.DateTimeField(null=True, blank=True, verbose_name='مهلت پاسخ')
    
    class Meta:
        verbose_name = 'نامه'
        verbose_name_plural = 'نامه‌ها'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['mail_number']),
            models.Index(fields=['status']),
            models.Index(fields=['-created_at']),
        ]
    
    def __str__(self):
        return f"{self.mail_number} - {self.title}"
    
    def save(self, *args, **kwargs):
        if not self.sent_at and self.status != 'new':
            self.sent_at = timezone.now()
        super().save(*args, **kwargs)


class MailAttachment(models.Model):
    """پیوست نامه"""
    mail = models.ForeignKey(
        Mail,
        on_delete=models.CASCADE,
        related_name='attachments',
        verbose_name='نامه'
    )
    file = models.FileField(
        upload_to='mail_attachments/%Y/%m/',
        validators=[
            FileExtensionValidator(
                allowed_extensions=['pdf', 'doc', 'docx', 'txt', 'jpg', 'png', 'xlsx', 'xls']
            )
        ],
        verbose_name='فایل'
    )
    original_filename = models.CharField(max_length=255, verbose_name='نام فایل')
    file_size = models.IntegerField(verbose_name='حجم فایل (بایت)')
    uploaded_at = models.DateTimeField(auto_now_add=True, verbose_name='تاریخ آپلود')
    description = models.CharField(max_length=500, blank=True, verbose_name='توضیحات')
    
    class Meta:
        verbose_name = 'پیوست'
        verbose_name_plural = 'پیوست‌ها'
        ordering = ['uploaded_at']
    
    def __str__(self):
        return f"{self.original_filename} - {self.mail.mail_number}"


class MailReferral(models.Model):
    """ارجاع نامه"""
    REFERRAL_TYPE_CHOICES = [
        ('info', 'اطلاع'),
        ('action', 'اقدام'),
        ('review', 'بررسی و نظر'),
        ('follow_up', 'پیگیری'),
        ('approval', 'تایید'),
    ]
    
    STATUS_CHOICES = [
        ('pending', 'در انتظار'),
        ('seen', 'مشاهده شده'),
        ('in_progress', 'در حال اقدام'),
        ('completed', 'اقدام شده'),
        ('returned', 'برگشت داده شده'),
    ]
    
    mail = models.ForeignKey(
        Mail,
        on_delete=models.CASCADE,
        related_name='referrals',
        verbose_name='نامه'
    )
    
    referrer = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name='referrals_made',
        verbose_name='ارجاع دهنده'
    )
    
    recipient = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name='referrals_received',
        verbose_name='گیرنده ارجاع'
    )
    recipient_department = models.ForeignKey(
        Department,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        verbose_name='واحد گیرنده'
    )
    
    referral_type = models.CharField(
        max_length=20,
        choices=REFERRAL_TYPE_CHOICES,
        verbose_name='نوع ارجاع'
    )
    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='pending',
        verbose_name='وضعیت'
    )
    
    note = models.TextField(blank=True, verbose_name='توضیحات ارجاع')
    response = models.TextField(blank=True, verbose_name='پاسخ')
    
    is_urgent = models.BooleanField(default=False, verbose_name='فوری')
    deadline = models.DateTimeField(null=True, blank=True, verbose_name='مهلت')
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='تاریخ ارجاع')
    seen_at = models.DateTimeField(null=True, blank=True, verbose_name='تاریخ مشاهده')
    completed_at = models.DateTimeField(null=True, blank=True, verbose_name='تاریخ اقدام')
    
    class Meta:
        verbose_name = 'ارجاع'
        verbose_name_plural = 'ارجاعات'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['status']),
            models.Index(fields=['recipient', '-created_at']),
        ]
    
    def __str__(self):
        return f"ارجاع {self.mail.mail_number} به {self.recipient.full_name}"


class MailSignature(models.Model):
    """امضای نامه"""
    APPROVAL_TYPE_CHOICES = [
        ('approved', 'تایید'),
        ('conditional_approval', 'تایید با شرط'),
        ('rejected', 'رد'),
        ('need_review', 'نیاز به بررسی بیشتر'),
        ('seen', 'مشاهده شده'),
    ]
    
    POSITION_CHOICES = [
        ('header', 'سربرگ'),
        ('footer', 'پاورقی'),
        ('end', 'انتهای سند'),
        ('custom', 'موقعیت دلخواه'),
    ]
    
    mail = models.ForeignKey(
        Mail,
        on_delete=models.CASCADE,
        related_name='signatures',
        verbose_name='نامه'
    )
    
    signer = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name='signatures',
        verbose_name='امضا کننده'
    )
    
    approval_type = models.CharField(
        max_length=30,
        choices=APPROVAL_TYPE_CHOICES,
        verbose_name='نوع تایید'
    )
    
    signature_image = models.ImageField(
        upload_to='signatures/digital/%Y/%m/',
        verbose_name='تصویر امضا'
    )
    
    note = models.TextField(blank=True, verbose_name='نظرات و توضیحات')
    
    position = models.CharField(
        max_length=20,
        choices=POSITION_CHOICES,
        default='end',
        verbose_name='موقعیت امضا'
    )
    
    signed_at = models.DateTimeField(auto_now_add=True, verbose_name='تاریخ امضا')
    ip_address = models.GenericIPAddressField(null=True, blank=True, verbose_name='آدرس IP')
    
    class Meta:
        verbose_name = 'امضا'
        verbose_name_plural = 'امضاها'
        ordering = ['signed_at']
        unique_together = ['mail', 'signer']
    
    def __str__(self):
        return f"امضای {self.signer.full_name} - {self.mail.mail_number}"


class SignedDocument(models.Model):
    """سند امضا شده"""
    mail = models.OneToOneField(
        Mail,
        on_delete=models.CASCADE,
        related_name='signed_document',
        verbose_name='نامه'
    )
    
    original_attachment = models.ForeignKey(
        MailAttachment,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='signed_versions',
        verbose_name='فایل اصلی'
    )
    
    signed_file = models.FileField(
        upload_to='signed_documents/%Y/%m/',
        verbose_name='فایل امضا شده'
    )
    
    file_hash = models.CharField(
        max_length=64,
        blank=True,
        verbose_name='هش فایل',
        help_text='SHA256 hash برای تایید یکپارچگی'
    )
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='تاریخ ایجاد')
    updated_at = models.DateTimeField(auto_now=True, verbose_name='تاریخ بروزرسانی')
    
    class Meta:
        verbose_name = 'سند امضا شده'
        verbose_name_plural = 'اسناد امضا شده'
    
    def __str__(self):
        return f"سند امضا شده - {self.mail.mail_number}"


class MailHistory(models.Model):
    """تاریخچه نامه"""
    ACTION_CHOICES = [
        ('created', 'ایجاد شد'),
        ('sent', 'ارسال شد'),
        ('received', 'دریافت شد'),
        ('referred', 'ارجاع داده شد'),
        ('signed', 'امضا شد'),
        ('status_changed', 'وضعیت تغییر کرد'),
        ('edited', 'ویرایش شد'),
        ('archived', 'بایگانی شد'),
        ('comment_added', 'نظر افزوده شد'),
    ]
    
    mail = models.ForeignKey(
        Mail,
        on_delete=models.CASCADE,
        related_name='history',
        verbose_name='نامه'
    )
    
    employee = models.ForeignKey(
        Employee,
        on_delete=models.SET_NULL,
        null=True,
        verbose_name='کاربر'
    )
    
    action = models.CharField(
        max_length=30,
        choices=ACTION_CHOICES,
        verbose_name='عملیات'
    )
    
    description = models.TextField(blank=True, verbose_name='توضیحات')
    
    old_value = models.TextField(blank=True, verbose_name='مقدار قبلی')
    new_value = models.TextField(blank=True, verbose_name='مقدار جدید')
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='تاریخ')
    ip_address = models.GenericIPAddressField(null=True, blank=True, verbose_name='آدرس IP')
    
    class Meta:
        verbose_name = 'تاریخچه'
        verbose_name_plural = 'تاریخچه‌ها'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['mail', '-created_at']),
        ]
    
    def __str__(self):
        return f"{self.mail.mail_number} - {self.get_action_display()} - {self.created_at}"


class MailTemplate(models.Model):
    """قالب نامه"""
    title = models.CharField(max_length=200, verbose_name='عنوان قالب')
    content = models.TextField(verbose_name='متن قالب')
    department = models.ForeignKey(
        Department,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        verbose_name='واحد'
    )
    is_public = models.BooleanField(default=False, verbose_name='عمومی')
    created_by = models.ForeignKey(
        Employee,
        on_delete=models.SET_NULL,
        null=True,
        verbose_name='ایجاد کننده'
    )
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='تاریخ ایجاد')
    
    class Meta:
        verbose_name = 'قالب نامه'
        verbose_name_plural = 'قالب‌های نامه'
        ordering = ['title']
    
    def __str__(self):
        return self.title


class Notification(models.Model):
    """اعلان"""
    NOTIFICATION_TYPE_CHOICES = [
        ('new_mail', 'نامه جدید'),
        ('referral', 'ارجاع'),
        ('signature_request', 'درخواست امضا'),
        ('deadline_reminder', 'یادآوری مهلت'),
        ('status_change', 'تغییر وضعیت'),
    ]
    
    recipient = models.ForeignKey(
        Employee,
        on_delete=models.CASCADE,
        related_name='notifications',
        verbose_name='گیرنده'
    )
    
    notification_type = models.CharField(
        max_length=30,
        choices=NOTIFICATION_TYPE_CHOICES,
        verbose_name='نوع اعلان'
    )
    
    title = models.CharField(max_length=200, verbose_name='عنوان')
    message = models.TextField(verbose_name='پیام')
    
    mail = models.ForeignKey(
        Mail,
        on_delete=models.CASCADE,
        null=True,
        blank=True,
        verbose_name='نامه مرتبط'
    )
    
    is_read = models.BooleanField(default=False, verbose_name='خوانده شده')
    read_at = models.DateTimeField(null=True, blank=True, verbose_name='تاریخ خواندن')
    
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='تاریخ ایجاد')
    
    class Meta:
        verbose_name = 'اعلان'
        verbose_name_plural = 'اعلان‌ها'
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['recipient', 'is_read', '-created_at']),
        ]
    
    def __str__(self):
        return f"{self.title} - {self.recipient.full_name}"