# Generated by Django 3.2.6 on 2024-01-22 08:12

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('mrp', '0029_auto_20240122_1121'),
    ]

    operations = [
        migrations.CreateModel(
            name='TolidPadash',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('description', models.TextField()),
                ('rank', models.IntegerField()),
                ('price_sarshift', models.DecimalField(decimal_places=2, max_digits=10)),
                ('price_personnel', models.DecimalField(decimal_places=2, max_digits=10)),
            ],
            options={
                'db_table': 'tolidpadash',
            },
        ),
        migrations.RenameField(
            model_name='nezafatpadash',
            old_name='price',
            new_name='price_personnel',
        ),
        migrations.AddField(
            model_name='nezafatpadash',
            name='description',
            field=models.TextField(default=0),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='nezafatpadash',
            name='price_sarshift',
            field=models.DecimalField(decimal_places=2, default=0, max_digits=10),
            preserve_default=False,
        ),
        migrations.CreateModel(
            name='TolidRanking',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('rank', models.IntegerField()),
                ('asset_randeman_list', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.assetrandemanlist')),
                ('shift', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='mrp.shift')),
            ],
            options={
                'db_table': 'tolidranking',
            },
        ),
    ]
