# Generated by Django 3.2.6 on 2023-12-05 06:07

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0015_speedformula'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='asset',
            options={'ordering': ('assetTavali', 'assetName')},
        ),
        migrations.AlterField(
            model_name='dailyproduction',
            name='counter',
            field=models.FloatField(),
        ),
    ]
