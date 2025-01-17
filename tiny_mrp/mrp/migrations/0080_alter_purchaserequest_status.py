# Generated by Django 3.2.6 on 2025-01-17 10:02

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0079_alter_purchaserequest_status'),
    ]

    operations = [
        migrations.AlterField(
            model_name='purchaserequest',
            name='status',
            field=models.CharField(choices=[('Pending', 'درخواست شده'), ('Approved', 'تایید انبار'), ('Rejected', 'رد شده'), ('Ordered', 'تحویل داده شده'), ('Approve2', 'تایید مهندس فرهادی'), ('Approve3', 'تایید مدیریت')], default='Pending', max_length=20),
        ),
    ]
