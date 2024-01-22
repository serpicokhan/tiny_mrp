# Generated by Django 3.2.6 on 2024-01-22 07:51

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0028_auto_20240117_1052'),
    ]

    operations = [
        migrations.CreateModel(
            name='NezafatPadash',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('rank', models.IntegerField()),
                ('price', models.DecimalField(decimal_places=2, max_digits=10)),
            ],
            options={
                'db_table': 'nezafatpadash',
            },
        ),
        migrations.AlterModelOptions(
            name='assetrandemanlist',
            options={'ordering': ('-sal', '-mah')},
        ),
        migrations.CreateModel(
            name='NezafatRanking',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('rank', models.IntegerField()),
                ('asset_randeman_list', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.assetrandemanlist')),
                ('shift', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.shift')),
            ],
            options={
                'db_table': 'nezafatranking',
            },
        ),
    ]
