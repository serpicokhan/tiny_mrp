from django.db import models
from .asset import Asset  # Import your Asset model
from .daily_tolid import Shift  # Import your Shift model
from .failure import Failure  # Import your Failure model

class AssetFailure(models.Model):
    asset_name = models.ForeignKey(Asset,verbose_name="نام تجهیز", on_delete=models.CASCADE)
    shift = models.ForeignKey(Shift,verbose_name="نام شیفت", on_delete=models.CASCADE)
    duration = models.TimeField("مدت توقف")
    failure_name = models.ForeignKey(Failure,verbose_name="علت توقف", on_delete=models.CASCADE)
    dayOfIssue = models.DateField("تاریخ")
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.asset_name} - {self.failure_name}"
