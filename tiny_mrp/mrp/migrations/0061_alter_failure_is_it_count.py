# Generated by Django 3.2.6 on 2024-04-23 16:51

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0060_failure_is_it_count'),
    ]

    operations = [
        migrations.AlterField(
            model_name='failure',
            name='is_it_count',
            field=models.BooleanField(default=False, verbose_name='فعال در محسابات'),
        ),
    ]