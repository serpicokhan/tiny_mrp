from django.db import models
from .asset import Asset  # Import your Asset model
from .daily_tolid import Shift  # Import your Shift model
from .failure import Failure  # Import your Failure model
from django.core.exceptions import ValidationError
from datetime import timedelta

class AssetFailure(models.Model):
    asset_name = models.ForeignKey(Asset,verbose_name="نام تجهیز", on_delete=models.CASCADE)
    shift = models.ForeignKey(Shift,verbose_name="نام شیفت", on_delete=models.CASCADE)
    duration = models.TimeField("مدت توقف")
    failure_name = models.ForeignKey(Failure,verbose_name="علت توقف", on_delete=models.CASCADE)
    dayOfIssue = models.DateField("تاریخ")
    timestamp = models.DateTimeField(auto_now_add=True)
    class Meta:
        unique_together = (('asset_name', 'shift', 'failure_name', 'dayOfIssue'),)
        ordering=('shift','asset_name','-duration',)

    def __str__(self):
        return f"{self.asset_name} - {self.failure_name}"

    def save(self, *args, **kwargs):
        # Calculate total duration for the given asset, shift, and date
        existing_failures = AssetFailure.objects.filter(
            asset_name=self.asset_name,
            shift=self.shift,
            dayOfIssue=self.dayOfIssue
        )

        total_duration = timedelta()
        for failure in existing_failures:
            # Convert TimeField to timedelta for addition
            duration_timedelta = timedelta(hours=failure.duration.hour, minutes=failure.duration.minute)
            total_duration += duration_timedelta

        # Add the duration of the current instance
        current_duration = timedelta(hours=self.duration.hour, minutes=self.duration.minute)
        total_duration += current_duration

        # Check if total duration exceeds 8 hours
        if total_duration > timedelta(hours=8):
            raise ValidationError("مدت زمان توقف این تجهیز نمی تواند از 8 ساعت تجاوز کند!")

        super().save(*args, **kwargs)
