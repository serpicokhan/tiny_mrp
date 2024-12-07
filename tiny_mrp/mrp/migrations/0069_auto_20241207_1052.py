# Generated by Django 3.2.6 on 2024-12-07 07:22

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('mrp', '0068_zayeatvaz_makan'),
    ]

    operations = [
        migrations.CreateModel(
            name='Part',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('partName', models.CharField(max_length=100, verbose_name='مشخصات')),
                ('partDescription', models.CharField(max_length=100, verbose_name='توضیحات')),
                ('partCode', models.CharField(max_length=50, verbose_name='کد')),
                ('partMake', models.CharField(blank=True, max_length=100, null=True, verbose_name='ساخته شده توسط')),
                ('partModel', models.CharField(blank=True, max_length=50, null=True, verbose_name='مدل')),
                ('partLastPrice', models.FloatField(blank=True, default=0, null=True, verbose_name='آخرین قیمت')),
                ('partAccount', models.CharField(blank=True, max_length=100, null=True, verbose_name='حساب')),
                ('partChargeDepartment', models.CharField(blank=True, max_length=100, null=True, verbose_name='دپارتمان مسوول')),
                ('partNotes', models.CharField(blank=True, max_length=100, null=True, verbose_name='یادداشت')),
                ('partBarcode', models.IntegerField(blank=True, null=True, verbose_name='بارکد')),
                ('partInventoryCode', models.CharField(blank=True, max_length=50, null=True, verbose_name='کد قفسه')),
            ],
            options={
                'db_table': 'parts',
                'ordering': ('partName',),
            },
        ),
        migrations.CreateModel(
            name='PartCsvFile',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('msgFile', models.FileField(max_length=200, upload_to='documents/%Y/%m/%d')),
                ('msgFiledateAdded', models.DateTimeField(auto_now_add=True)),
            ],
            options={
                'db_table': 'partcsvfile',
            },
        ),
        migrations.CreateModel(
            name='PurchaseRequest',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('status', models.CharField(choices=[('Pending', 'Pending'), ('Approved', 'Approved'), ('Rejected', 'Rejected'), ('Ordered', 'Ordered')], default='Pending', max_length=20)),
                ('description', models.TextField(blank=True, null=True)),
                ('consume_place', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='consume_place', to='mrp.asset')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='purchase_requests', to='mrp.sysuser')),
            ],
        ),
        migrations.CreateModel(
            name='RequestItem',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('quantity', models.PositiveIntegerField()),
                ('item_name', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='consume_place', to='mrp.part')),
                ('purchase_request', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='items', to='mrp.purchaserequest')),
            ],
        ),
        migrations.CreateModel(
            name='RFQ',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('issued_at', models.DateTimeField(auto_now_add=True)),
                ('issued_by', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='rfqs', to=settings.AUTH_USER_MODEL)),
                ('items', models.ManyToManyField(related_name='rfqs', to='mrp.RequestItem')),
            ],
        ),
        migrations.CreateModel(
            name='Supplier',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('email', models.EmailField(max_length=254)),
                ('phone', models.CharField(blank=True, max_length=15, null=True)),
                ('address', models.TextField(blank=True, null=True)),
                ('provided_items', models.ManyToManyField(blank=True, help_text='Items that this supplier can provide', related_name='potential_suppliers', to='mrp.RequestItem')),
            ],
        ),
        migrations.CreateModel(
            name='SupplierResponse',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('total_price', models.DecimalField(decimal_places=2, max_digits=10)),
                ('payment_terms', models.TextField()),
                ('arrival_date', models.DateField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('rfq', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='responses', to='mrp.rfq')),
                ('supplier', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='responses', to='mrp.supplier')),
            ],
        ),
        migrations.AddField(
            model_name='rfq',
            name='supplier',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='rfqs', to='mrp.supplier'),
        ),
        migrations.AddField(
            model_name='requestitem',
            name='supplier_assigned',
            field=models.ForeignKey(blank=True, help_text='Supplier who can provide this item', null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='assigned_items', to='mrp.supplier'),
        ),
        migrations.CreateModel(
            name='PartUser',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('PartUserPartId', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='mrp.part', verbose_name='قطعه')),
                ('PartUserUserId', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='mrp.sysuser', verbose_name='کاربر ')),
            ],
            options={
                'db_table': 'partuser',
            },
        ),
        migrations.CreateModel(
            name='PartFile',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('partFile', models.FileField(max_length=200, upload_to='documents/')),
                ('partFiledateAdded', models.DateTimeField(auto_now_add=True)),
                ('partFilePartId', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='mrp.part')),
            ],
            options={
                'db_table': 'partfile',
            },
        ),
        migrations.CreateModel(
            name='PartCategory',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('name', models.CharField(max_length=50, verbose_name='نام')),
                ('code', models.CharField(max_length=50, unique=True, verbose_name='کد')),
                ('description', models.CharField(max_length=50, verbose_name='توضیحات')),
                ('priority', models.IntegerField(null=True, verbose_name='اولویت')),
                ('isPartOf', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='mrp.partcategory', verbose_name='زیر مجموعه')),
            ],
            options={
                'db_table': 'partcategory',
            },
        ),
        migrations.AddField(
            model_name='part',
            name='partCategory',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='dasdadassa', to='mrp.partcategory', verbose_name='دسته بندی'),
        ),
        migrations.CreateModel(
            name='Order',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('total_price', models.DecimalField(decimal_places=2, max_digits=10)),
                ('payment_terms', models.TextField()),
                ('arrival_date', models.DateField()),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('items', models.ManyToManyField(related_name='orders', to='mrp.RequestItem')),
                ('supplier', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='orders', to='mrp.supplier')),
            ],
        ),
    ]
