# Generated by Django 3.2.6 on 2025-01-13 06:27

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0084_alter_purchaserequest_status'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='sysuser',
            options={'ordering': ['title'], 'permissions': [('can_view_dashboard', 'can view dashboard'), ('can_admin_purchase', 'can admin create purchase'), ('view_all_request', 'can view  all purchase request'), ('view_all_request2', 'can view  all purchase request')]},
        ),
    ]
