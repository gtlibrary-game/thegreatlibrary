# Generated by Django 3.2.9 on 2021-11-27 20:05

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('breads', '0005_breadpage_datamine'),
    ]

    operations = [
        migrations.AddField(
            model_name='breadpage',
            name='contactid',
            field=models.TextField(blank=True, help_text='the contact id for this piece'),
        ),
    ]
