# Generated by Django 3.2.6 on 2024-04-20 06:16

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0058_financialprofile_tolid_randeman_mazrab_3'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='sysuser',
            options={'ordering': ['title'], 'permissions': [('can_view_dashboard', 'can view dashboard')]},
        ),
    ]