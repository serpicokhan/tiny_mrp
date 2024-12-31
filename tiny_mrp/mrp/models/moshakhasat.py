from django.db import models
from mrp.models import AssetCategory2
class Color(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name
    
class EntryForm(models.Model):
    color = models.ForeignKey(Color, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    tool = models.IntegerField()
    la = models.IntegerField()

    def __str__(self):
        return f"{self.name} {self.tool}/{self.la} ({self.color.name})"
    
class AssetDetail(models.Model):
    entry = models.ForeignKey(EntryForm, on_delete=models.CASCADE, related_name="asset_details")
    asset_category = models.ForeignKey(AssetCategory2, on_delete=models.CASCADE)
    nomre = models.FloatField()
    speed = models.FloatField()
    