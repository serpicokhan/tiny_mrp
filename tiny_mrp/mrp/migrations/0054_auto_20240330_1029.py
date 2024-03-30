# Generated by Django 3.2.6 on 2024-03-30 06:59

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0053_auto_20240329_2326'),
    ]

    operations = [
        migrations.AlterField(
            model_name='assetrandemaninit',
            name='asset_category',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.assetcategory', verbose_name='نوع تجهیز'),
        ),
        migrations.AlterField(
            model_name='assetrandemanlist',
            name='profile',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='mrp.financialprofile', verbose_name='پروفایل مالی'),
        ),
        migrations.AlterField(
            model_name='nezafatpadash',
            name='rank',
            field=models.IntegerField(choices=[(1, 'رتبه اول'), (2, 'رتبه دوم'), (3, 'رتبه سوم')]),
        ),
        migrations.AlterField(
            model_name='tolidranking',
            name='rank',
            field=models.IntegerField(choices=[(1, 'رتبه اول'), (2, 'رتبه دوم'), (3, 'رتبه سوم')]),
        ),
    ]