# Generated by Django 3.2.6 on 2024-01-10 06:55

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0025_assetrandemanpermonth'),
    ]

    operations = [
        migrations.CreateModel(
            name='AssetRandemanList',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('mah', models.IntegerField()),
                ('sal', models.IntegerField()),
            ],
            options={
                'db_table': 'assetrandemanlist',
            },
        ),
    ]
