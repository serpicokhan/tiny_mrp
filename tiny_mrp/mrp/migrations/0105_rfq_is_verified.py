# Generated by Django 3.2.6 on 2025-02-23 07:23

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0104_alter_sysuser_options'),
    ]

    operations = [
        migrations.AddField(
            model_name='rfq',
            name='is_verified',
            field=models.BooleanField(default=False),
        ),
    ]
