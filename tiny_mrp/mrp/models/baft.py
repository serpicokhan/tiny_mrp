from django.db import models
from mrp.models.daily_tolid import *
class Color(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name
    class Meta:
        db_table="color"

class Tarh(models.Model):
    name = models.CharField(max_length=100)
    code = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return f"{self.name} ({self.code})"

    class Meta:
        db_table="tarh"
class Size(models.Model):
    name = models.CharField(max_length=100)
    area = models.FloatField()

    def __str__(self):
        return f"{self.name} - {self.area} sq units"
    class Meta:
        db_table="size"

class DailySingleRecord(models.Model):
    shomare = models.CharField(max_length=100)
    tarh = models.ForeignKey(Tarh, on_delete=models.CASCADE)
    rang = models.ForeignKey(Color, on_delete=models.CASCADE)
    tarakom = models.IntegerField()
    machine = models.ForeignKey(Asset, on_delete=models.CASCADE)
    sizes = models.ManyToManyField(Size)

    def __str__(self):
        return f"Record {self.shomare}"