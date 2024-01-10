# Generated by Django 3.2.6 on 2024-01-09 10:24

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0023_auto_20231231_1318'),
    ]

    operations = [
        migrations.AlterField(
            model_name='assetfailure',
            name='asset_name',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.asset', verbose_name='نام تجهیز'),
        ),
        migrations.AlterField(
            model_name='assetfailure',
            name='dayOfIssue',
            field=models.DateField(verbose_name='تاریخ'),
        ),
        migrations.AlterField(
            model_name='assetfailure',
            name='duration',
            field=models.TimeField(verbose_name='مدت توقف'),
        ),
        migrations.AlterField(
            model_name='assetfailure',
            name='failure_name',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.failure', verbose_name='علت توقف'),
        ),
        migrations.AlterField(
            model_name='assetfailure',
            name='shift',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.shift', verbose_name='نام شیفت'),
        ),
        migrations.CreateModel(
            name='AssetRandemanInit',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('operator_count', models.IntegerField()),
                ('max_randeman', models.DecimalField(decimal_places=0, max_digits=10)),
                ('randeman_yek_dastgah', models.DecimalField(decimal_places=0, max_digits=10)),
                ('randeman_mazrab_3', models.DecimalField(decimal_places=0, max_digits=10)),
                ('mablaghe_kole_randeman', models.DecimalField(decimal_places=0, max_digits=10)),
                ('mablaghe_kole_randeman_round', models.DecimalField(decimal_places=0, max_digits=10)),
                ('randeman_tolid', models.DecimalField(decimal_places=0, max_digits=10)),
                ('asset_category', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.assetcategory')),
            ],
            options={
                'db_table': 'assetrandemaninit',
            },
        ),
    ]