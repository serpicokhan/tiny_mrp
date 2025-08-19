from django.db import models
from mrp.models import AssetCategory2
class Color(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name
    class Meta:
        ordering = ['name']  # Order by name alphabetically
    
    
class EntryForm(models.Model):
    color = models.ForeignKey(Color, on_delete=models.CASCADE,verbose_name="رنگ")
    name = models.CharField("نام",max_length=100, unique=True)  # Added unique=True
    tool = models.IntegerField("طول",null=True, blank=True)     # Made optional
    la = models.IntegerField("لا",null=True, blank=True)       # Made optional

    def __str__(self):
        tool_display = self.tool if self.tool is not None else "?"
        la_display = self.la if self.la is not None else "?"
        return f"{self.name}  ({self.color.name})"
    # class Meta:
    #     db_table="مشخصات"
    
class AssetDetail(models.Model):
    entry = models.ForeignKey(EntryForm, on_delete=models.CASCADE, related_name="asset_details")
    asset_category = models.ForeignKey(AssetCategory2, on_delete=models.CASCADE)
    nomre = models.FloatField()
    speed = models.FloatField()
    tab = models.FloatField(default=1)
    