# Generated by Django 3.2.6 on 2024-10-19 09:40

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0065_asset_assetvahed'),
    ]

    operations = [
        migrations.AddField(
            model_name='dailyproduction',
            name='vahed',
            field=models.FloatField(default=0),
            preserve_default=False,
        ),
    ]