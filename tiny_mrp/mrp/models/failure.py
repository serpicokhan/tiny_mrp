from django.db import models

class Failure(models.Model):
    code = models.CharField("کد",max_length=50)
    name = models.CharField("نام",max_length=100)
    is_it_count=models.BooleanField("فعال در محسابات",default=True)

    def __str__(self):
        return f"{self.code} - {self.name}"
    class Meta:
        db_table="failure"
