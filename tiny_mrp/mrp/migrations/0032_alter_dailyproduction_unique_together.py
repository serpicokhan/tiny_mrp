# Generated by Django 3.2.6 on 2024-02-05 11:29

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0031_auto_20240129_1627'),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name='dailyproduction',
            unique_together={('machine', 'shift', 'dayOfIssue')},
        ),
    ]
