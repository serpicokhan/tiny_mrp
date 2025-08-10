from django.db import models
class Operator(models.Model):
    Pid = models.CharField(max_length=20)
    PNumber = models.CharField(max_length=20)
    CpCode = models.CharField(max_length=100)
    CardNo = models.CharField(max_length=100)
    FName = models.CharField(max_length=100)  # First name
    LName = models.CharField(max_length=100)  # Last name

    class Meta:
        db_table = 'operator'  # This matches your table name
        verbose_name_plural = 'Operators'

    def __str__(self):
        return f"{self.FName} {self.LName}"