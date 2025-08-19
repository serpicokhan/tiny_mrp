from django.db import models
class Operator(models.Model):
    Pid = models.CharField(max_length=20,blank=True,null=True)
    PNumber = models.CharField(max_length=20,blank=True,null=True)
    CpCode = models.CharField(max_length=100,blank=True,null=True)
    CardNo = models.CharField(max_length=100,blank=True,null=True)
    FName = models.CharField(max_length=200,blank=True,null=True)  # First name
    LName = models.CharField(max_length=200,blank=True,null=True)  # Last name

    class Meta:
        db_table = 'operator'  # This matches your table name
        verbose_name_plural = 'Operators'

    def __str__(self):
        return f"{self.FName} {self.LName}"
