from django.db import models

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
    
    