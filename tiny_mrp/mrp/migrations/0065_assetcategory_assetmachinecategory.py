# Generated by Django 3.2.6 on 2024-11-23 16:13

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0064_alter_assetrandemanpermonth_tolid_value'),
    ]

    operations = [
        migrations.AddField(
            model_name='assetcategory',
            name='assetMachineCategory',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='mrp.machinecategory', verbose_name='نوع دستگاه'),
        ),
    ]
