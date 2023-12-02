# Generated by Django 3.2.6 on 2023-12-02 17:33

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0007_remove_dailyproduction_shift'),
    ]

    operations = [
        migrations.AddField(
            model_name='dailyproduction',
            name='shift',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, related_name='dailyproduction_shift', to='mrp.shift'),
            preserve_default=False,
        ),
    ]
