# Generated by Django 3.2.6 on 2023-12-05 06:56

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0016_auto_20231205_0937'),
    ]

    operations = [
        migrations.CreateModel(
            name='ProductionStandard',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('good_production_rate', models.IntegerField()),
                ('mean_production_rate', models.IntegerField()),
                ('bad_production_rate', models.IntegerField()),
                ('machine_name', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.asset')),
            ],
            options={
                'db_table': 'productionstandard',
            },
        ),
    ]
