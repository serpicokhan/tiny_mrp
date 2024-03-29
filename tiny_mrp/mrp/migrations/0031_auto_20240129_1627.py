# Generated by Django 3.2.6 on 2024-01-29 12:57

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0030_auto_20240122_1142'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='nezafatpadash',
            options={'ordering': ('rank',)},
        ),
        migrations.AlterModelOptions(
            name='shift',
            options={'ordering': ('id',)},
        ),
        migrations.AlterModelOptions(
            name='tolidpadash',
            options={'ordering': ('rank',)},
        ),
        migrations.AlterField(
            model_name='dailyproduction',
            name='production_value',
            field=models.FloatField(blank=True, null=True),
        ),
    ]
