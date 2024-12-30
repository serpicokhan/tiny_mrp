# Generated by Django 3.2.6 on 2024-12-30 06:12

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0070_dailyproduction_zayeat'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='assetcategory',
            options={'ordering': ('priority',)},
        ),
        migrations.CreateModel(
            name='AssetCategory2',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50, verbose_name='نام')),
                ('code', models.CharField(max_length=50, verbose_name='کد')),
                ('description', models.CharField(max_length=50, verbose_name='توضیحات')),
                ('priority', models.IntegerField(null=True, verbose_name='اولویت')),
                ('isPartOf', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, to='mrp.assetcategory2', verbose_name='زیر مجموعه')),
            ],
            options={
                'db_table': 'assetcategory2',
                'ordering': ('priority',),
            },
        ),
        migrations.AddField(
            model_name='asset',
            name='assetCategory2',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='cat_moshakhase', to='mrp.assetcategory2', verbose_name='دسته بندی'),
        ),
    ]