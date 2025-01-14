# Generated by Django 3.2.6 on 2025-01-14 06:55

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0090_alter_purchaserequest_status'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='sysuser',
            options={'ordering': ['title'], 'permissions': [('can_view_dashboard', 'can view dashboard'), ('can_admin_purchase', 'can admin create purchase'), ('view_all_request', 'can view  all purchase request'), ('can_confirm_request', 'can confirm request'), ('can_operator_mrp', 'mrp user operator')]},
        ),
        migrations.AlterField(
            model_name='purchaserequest',
            name='status',
            field=models.CharField(choices=[('Pending', 'درخواست شده'), ('Approved', 'تایید انبار'), ('Rejected', 'رد شده'), ('Ordered', 'سفارش '), ('Approve2', 'تایید مهندس اعزامی'), ('Approve3', 'تایید مهندس ارزنده')], default='Pending', max_length=20),
        ),
    ]
