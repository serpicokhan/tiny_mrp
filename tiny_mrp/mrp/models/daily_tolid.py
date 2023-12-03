from django.db import models
from mrp.models.asset import Asset
import jdatetime
import ast

class Shift(models.Model):
    name = models.CharField(max_length=255)
    class Meta:
        db_table="shift"

class Formula(models.Model):
    machine = models.OneToOneField(Asset, on_delete=models.CASCADE)
    formula = models.CharField(max_length=255)

    def __str__(self):
        return f"Formula for {self.formula}"
    class Meta:
        db_table="formula"
class SpeedFormula(models.Model):
    machine = models.OneToOneField(Asset, on_delete=models.CASCADE)
    formula = models.CharField(max_length=255)

    def __str__(self):
        return f"Formula for {self.formula}"
    class Meta:
        db_table="speedformula"
class DailyProduction(models.Model):
    machine = models.ForeignKey(Asset, on_delete=models.CASCADE,related_name="dailyproduction_machine")
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE,related_name="dailyproduction_shift")
    dayOfIssue = models.DateField()
    timestamp = models.DateTimeField(auto_now_add=True)
    register_user = models.CharField(max_length=100)
    speed=models.IntegerField(default=0)
    nomre = models.FloatField()
    counter = models.IntegerField()
    production_value = models.IntegerField(blank=True, null=True)  # Result of the formula
    def save(self, *args, **kwargs):
        # Calculate production value based on the specified formula
        if self.machine:
            formula_obj = Formula.objects.get(machine=self.machine)
            formula = formula_obj.formula

            # Parameters for the evaluation (counter and nomre)
            parameters = {
                'Q': self.counter,
                'P': self.nomre
            }

            # Replace parameters in the formula with actual values
            for param, value in parameters.items():
                formula = formula.replace(param, str(value))
            formula = formula.replace("/", " / ")

            # Evaluate the modified formula
            try:
                # Evaluating the formula string to get the calculated value
                # Use ast.literal_eval to evaluate the expression safely
                calculated_value = eval(formula)
                self.production_value = calculated_value
            except (SyntaxError, ValueError) as e:
                # Handle exceptions if the formula is incorrect or cannot be evaluated
                print(f"Error evaluating formula: {e}")
                # You can set a default value or handle the error as per your requirement

        super(DailyProduction, self).save(*args, **kwargs)
    class Meta:
        db_table="dailyproduction"
