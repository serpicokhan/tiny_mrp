# Generated by Django 3.2.6 on 2025-01-10 05:54

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0077_purchaserequestfile'),
    ]

    operations = [
        migrations.AddField(
            model_name='purchaserequest',
            name='is_emergency',
            field=models.BooleanField(default=False),
        ),
    ]
