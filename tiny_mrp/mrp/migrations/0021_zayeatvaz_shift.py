# Generated by Django 3.2.6 on 2023-12-19 04:54

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0020_zayeatvaz_dayofissue'),
    ]

    operations = [
        migrations.AddField(
            model_name='zayeatvaz',
            name='shift',
            field=models.ForeignKey(default=None, on_delete=django.db.models.deletion.CASCADE, to='mrp.shift'),
            preserve_default=False,
        ),
    ]
