from django.db import models
from .asset import Asset  # Import your Asset model
from .daily_tolid import Shift  # Import your Shift model
from .failure import Failure  # Import your Failure model

class AssetFailure(models.Model):
    asset_name = models.ForeignKey(Asset, on_delete=models.CASCADE)
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE)
    duration = models.TimeField()
    failure_name = models.ForeignKey(Failure, on_delete=models.CASCADE)
    dayOfIssue = models.DateField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.asset_name} - {self.failure_name}"
