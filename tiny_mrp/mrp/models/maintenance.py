from django.db import models
from django.utils import timezone

# مدل تجهیزات
class Equipment(models.Model):
    name = models.CharField(max_length=100, verbose_name="نام تجهیزات")
    code = models.CharField(max_length=50, unique=True, verbose_name="کد تجهیزات")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "تجهیزات"
        verbose_name_plural = "تجهیزات"

# مدل تکنسین
class Technician(models.Model):
    name = models.CharField(max_length=100, verbose_name="نام تکنسین")
    employee_id = models.CharField(max_length=50, unique=True, verbose_name="کد پرسنلی")
    email = models.EmailField(blank=True, verbose_name="ایمیل")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "تکنسین"
        verbose_name_plural = "تکنسین‌ها"

# مدل نگهداری (دستور کار و برنامه دوره‌ای)
class Maintenance(models.Model):
    MAINTENANCE_TYPES = [
        ('manual', 'دستی'),
        ('recurring', 'دوره‌ای'),
        ('emergency', 'اضطراری'),
    ]

    OPERATION_TYPES = [
        ('preventive', 'نگهداری پیشگیرانه'),
        ('corrective', 'اصلاحی'),
        ('inspection', 'بازرسی'),
        ('breakdown', 'خرابی'),
        ('calibration', 'کالیبراسیون'),
        ('lubrication', 'روغن‌کاری'),
        ('safety_check', 'بررسی ایمنی'),
    ]

    PRIORITY_CHOICES = [
        ('High', 'بالا'),
        ('Medium', 'متوسط'),
        ('Low', 'پایین'),
    ]

    RECURRENCE_CHOICES = [
        ('daily', 'روزانه'),
        ('weekly', 'هفتگی'),
        ('monthly', 'ماهانه'),
        ('quarterly', 'فصلی'),
        ('yearly', 'سالانه'),
    ]

    title = models.CharField(max_length=200, verbose_name="عنوان")
    maintenance_type = models.CharField(max_length=20, choices=MAINTENANCE_TYPES, verbose_name="نوع نگهداری")
    operation_type = models.CharField(max_length=50, choices=OPERATION_TYPES, verbose_name="نوع عملیات")
    equipment = models.ForeignKey(Equipment, on_delete=models.CASCADE, verbose_name="تجهیزات")
    assigned_to = models.ForeignKey(Technician, on_delete=models.SET_NULL, null=True, blank=True, verbose_name="اختصاص به")
    priority = models.CharField(max_length=20, choices=PRIORITY_CHOICES, default='Medium', verbose_name="اولویت")
    created_date = models.DateField(default=timezone.now, verbose_name="تاریخ ایجاد")
    due_date = models.DateField(null=True, blank=True, verbose_name="تاریخ سررسید")  # برای دستور کارها
    start_date = models.DateField(null=True, blank=True, verbose_name="تاریخ شروع")  # برای دوره‌ای
    end_date = models.DateField(null=True, blank=True, verbose_name="تاریخ پایان")  # برای دوره‌ای
    recurrence = models.CharField(max_length=20, choices=RECURRENCE_CHOICES, null=True, blank=True, verbose_name="دوره تکرار")
    last_work_order_date = models.DateField(null=True, blank=True, verbose_name="آخرین تاریخ تولید دستور کار")
    is_active = models.BooleanField(default=True, verbose_name="فعال")  # برای دوره‌ای
    problem_description = models.TextField(blank=True, verbose_name="شرح مشکل")  # برای اضطراری
    reported_by = models.CharField(max_length=100, blank=True, verbose_name="گزارش‌دهنده")  # برای اضطراری
    description = models.TextField(blank=True, verbose_name="توضیحات")
    safety_instructions = models.TextField(blank=True, verbose_name="دستورالعمل‌های ایمنی")
    completion_notes = models.TextField(blank=True, verbose_name="یادداشت‌های تکمیل")
    approval_required = models.BooleanField(default=True, verbose_name="نیاز به تأیید")
    approval_role = models.CharField(max_length=50, choices=[
        ('supervisor', 'سرپرست نگهداری'),
        ('manager', 'مدیر نگهداری'),
        ('engineer', 'مهندس نگهداری'),
        ('custom', 'نقش سفارشی'),
    ], default='supervisor', verbose_name="نقش تأییدکننده")
    status = models.CharField(max_length=20, choices=[
        ('pending', 'در انتظار'),
        ('in_progress', 'در حال انجام'),
        ('completed', 'تکمیل شده'),
        ('approved', 'تأیید شده'),
    ], default='pending', verbose_name="وضعیت")
    is_visible = models.BooleanField(default=True, verbose_name="قابل مشاهده")
    visible_from = models.DateField(null=True, blank=True, verbose_name="قابل مشاهده از تاریخ")
    created_at = models.DateTimeField(auto_now_add=True, verbose_name="تاریخ ثبت")

    def __str__(self):
        return f"{self.title} ({self.get_maintenance_type_display()})"

    def check_visibility(self):
        """بررسی و به‌روزرسانی وضعیت نمایش"""
        today = timezone.now().date()
        if self.visible_from and today >= self.visible_from:
            self.is_visible = True
        else:
            self.is_visible = False
        self.save()

    class Meta:
        verbose_name = "نگهداری"
        verbose_name_plural = "نگهداری‌ها"
        indexes = [
            models.Index(fields=['maintenance_type', 'is_visible', 'due_date']),
            models.Index(fields=['is_active', 'recurrence']),
        ]

# مدل قطعات یدکی
class SparePart(models.Model):
    maintenance = models.ForeignKey(
        Maintenance,
        related_name='spare_parts',
        on_delete=models.CASCADE,
        verbose_name="نگهداری"
    )
    name = models.CharField(max_length=100, verbose_name="نام قطعه")
    part_code = models.CharField(max_length=50, unique=True, verbose_name="کد قطعه")
    quantity = models.PositiveIntegerField(default=1, verbose_name="تعداد")

    def __str__(self):
        return f"{self.name} ({self.part_code})"

    class Meta:
        verbose_name = "قطعه یدکی"
        verbose_name_plural = "قطعات یدکی"

# مدل ابزارها
class Tool(models.Model):
    maintenance = models.ForeignKey(
        Maintenance,
        related_name='tools',
        on_delete=models.CASCADE,
        verbose_name="نگهداری"
    )
    name = models.CharField(max_length=100, verbose_name="نام ابزار")

    def __str__(self):
        return self.name

    class Meta:
        verbose_name = "ابزار"
        verbose_name_plural = "ابزارها"

# مدل وظایف
class Task(models.Model):
    TASK_TYPES = [
        ('single', 'وظیفه تک‌گزینه‌ای'),
        ('checklist', 'چک لیست'),
        ('group', 'گروه وظایف'),
    ]

    maintenance = models.ForeignKey(
        Maintenance,
        related_name='tasks',
        on_delete=models.CASCADE,
        verbose_name="نگهداری"
    )
    task_type = models.CharField(max_length=20, choices=TASK_TYPES, verbose_name="نوع وظیفه")
    title = models.CharField(max_length=200, verbose_name="عنوان")
    description = models.TextField(blank=True, verbose_name="توضیحات")
    order = models.PositiveIntegerField(default=0, verbose_name="ترتیب")

    def __str__(self):
        return f"{self.title} ({self.get_task_type_display()})"

    class Meta:
        verbose_name = "وظیفه"
        verbose_name_plural = "وظایف"
        ordering = ['order']

# مدل آیتم‌های چک‌لیست
class ChecklistItem(models.Model):
    task = models.ForeignKey(Task, related_name='checklist_items', on_delete=models.CASCADE, verbose_name="وظیفه")
    description = models.CharField(max_length=200, verbose_name="توضیحات آیتم")
    order = models.PositiveIntegerField(default=0, verbose_name="ترتیب")

    def __str__(self):
        return self.description

    class Meta:
        verbose_name = "آیتم چک‌لیست"
        verbose_name_plural = "آیتم‌های چک‌لیست"
        ordering = ['order']

# مدل زیروظایف گروه
class GroupTask(models.Model):
    SUBTASK_TYPES = [
        ('checkbox', 'چک باکس ساده'),
        ('checklist', 'چک لیست'),
        ('measurement', 'اندازه‌گیری'),
    ]

    task = models.ForeignKey(Task, related_name='group_tasks', on_delete=models.CASCADE, verbose_name="وظیفه")
    description = models.CharField(max_length=200, verbose_name="توضیحات زیروظیفه")
    subtask_type = models.CharField(max_length=20, choices=SUBTASK_TYPES, verbose_name="نوع زیروظیفه")
    order = models.PositiveIntegerField(default=0, verbose_name="ترتیب")

    def __str__(self):
        return f"{self.description} ({self.get_subtask_type_display()})"

    class Meta:
        verbose_name = "زیروظیفه گروه"
        verbose_name_plural = "زیروظایف گروه"
        ordering = ['order']

# مدل مستندات
class Documentation(models.Model):
    maintenance = models.ForeignKey(
        Maintenance,
        related_name='documentation',
        on_delete=models.CASCADE,
        verbose_name="نگهداری"
    )
    type = models.CharField(max_length=50, choices=[
        ('photos', 'عکس‌های قبل/بعد'),
        ('readings', 'قرائت‌های تجهیزات'),
        ('measurements', 'اندازه‌گیری‌ها'),
        ('signature', 'امضای تکنسین'),
    ], verbose_name="نوع مستند")

    def __str__(self):
        return self.get_type_display()

    class Meta:
        verbose_name = "مستند"
        verbose_name_plural = "مستندات"