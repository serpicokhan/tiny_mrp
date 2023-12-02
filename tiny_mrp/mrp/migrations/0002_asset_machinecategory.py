# Generated by Django 3.2.6 on 2023-12-02 06:26

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='MachineCategory',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50, verbose_name='نام')),
                ('description', models.CharField(max_length=50, verbose_name='توضیحات')),
                ('isPartOf', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='mrp.machinecategory', verbose_name='زیر مجموعه')),
            ],
            options={
                'db_table': 'machinecategory',
            },
        ),
        migrations.CreateModel(
            name='Asset',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('assetTypes', models.IntegerField(blank=True, choices=[(1, 'مکان'), (2, 'ماشین  آلات'), (3, 'ابزارآلات')], null=True, verbose_name='نوع دارایی')),
                ('assetName', models.CharField(max_length=100, verbose_name='مشخصات')),
                ('assetDescription', models.CharField(blank=True, max_length=100, null=True, verbose_name='توضیحات')),
                ('assetCode', models.CharField(blank=True, max_length=50, null=True, verbose_name='کد')),
                ('assetAddress', models.CharField(blank=True, max_length=100, null=True, verbose_name='آدرس')),
                ('assetCity', models.CharField(blank=True, max_length=50, null=True, verbose_name='شهر')),
                ('assetState', models.CharField(blank=True, max_length=50, null=True, verbose_name='استان')),
                ('assetZipcode', models.CharField(blank=True, max_length=50, null=True, verbose_name='کد پستی')),
                ('assetCountry', models.CharField(blank=True, max_length=100, null=True, verbose_name='کشور')),
                ('assetAccount', models.CharField(blank=True, max_length=100, null=True, verbose_name='حساب')),
                ('assetChargeDepartment', models.CharField(blank=True, max_length=100, null=True, verbose_name='دپارتمان مسوول')),
                ('assetNotes', models.CharField(blank=True, max_length=100, null=True, verbose_name='یادداشت')),
                ('assetBarcode', models.IntegerField(blank=True, null=True, verbose_name='بارکد')),
                ('assetHasPartOf', models.BooleanField(default=False)),
                ('assetAisel', models.IntegerField(blank=True, null=True, verbose_name='راهرو')),
                ('assetRow', models.IntegerField(blank=True, null=True, verbose_name='ردیف')),
                ('assetBin', models.IntegerField(blank=True, null=True, verbose_name='Bin')),
                ('assetManufacture', models.CharField(blank=True, max_length=50, null=True, verbose_name='سازنده')),
                ('assetModel', models.CharField(blank=True, max_length=50, null=True, verbose_name='مدل')),
                ('assetSerialNumber', models.CharField(blank=True, max_length=50, null=True, verbose_name='شماره سریال')),
                ('assetStatus', models.BooleanField(default=True, verbose_name='وضعیت')),
                ('assetIsStock', models.BooleanField(default=False, verbose_name='انبار')),
                ('assetTavali', models.IntegerField(blank=True, null=True, verbose_name='شماره توالی')),
                ('assetCategory', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='mrp.assetcategory', verbose_name='دسته بندی')),
                ('assetIsLocatedAt', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='location', to='mrp.asset', verbose_name='مکان')),
                ('assetIsPartOf', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='mrp.asset', verbose_name='زیر مجموعه')),
                ('assetMachineCategory', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='mrp.machinecategory', verbose_name='نوع دستگاه')),
            ],
            options={
                'db_table': 'assets',
                'ordering': ('assetName',),
            },
        ),
    ]
