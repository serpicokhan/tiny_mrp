# Generated by Django 3.2.6 on 2023-12-02 16:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0003_dailyproduction_formula'),
    ]

    operations = [
        migrations.AddField(
            model_name='dailyproduction',
            name='speed',
            field=models.IntegerField(default=0),
        ),
    ]