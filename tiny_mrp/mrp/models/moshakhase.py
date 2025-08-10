from django.db import models
from mrp.models import AssetCategory2
class Color(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name
    
class EntryForm(models.Model):
    color = models.ForeignKey(Color, on_delete=models.CASCADE)
    name = models.CharField(max_length=100, unique=True)  # Added unique=True
    tool = models.IntegerField(null=True, blank=True)     # Made optional
    la = models.IntegerField(null=True, blank=True)       # Made optional

    def __str__(self):
        tool_display = self.tool if self.tool is not None else "?"
        la_display = self.la if self.la is not None else "?"
        return f"{self.name} {tool_display}/{la_display} ({self.color.name})"
    # class Meta:
    #     db_table="مشخصات"
    
class AssetDetail(models.Model):
    entry = models.ForeignKey(EntryForm, on_delete=models.CASCADE, related_name="asset_details")
    asset_category = models.ForeignKey(AssetCategory2, on_delete=models.CASCADE)
    nomre = models.FloatField()
    speed = models.FloatField()
    tab = models.FloatField(default=1)
    