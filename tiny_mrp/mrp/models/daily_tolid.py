from django.db import models
from mrp.models.asset import Asset
import jdatetime
import ast

class Shift(models.Model):
    name = models.CharField(max_length=255)
    def __str__(self):
        return f"{self.name}"
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
class ProductionStandard(models.Model):
    machine_name = models.ForeignKey(Asset, on_delete=models.CASCADE)
    good_production_rate = models.IntegerField()
    mean_production_rate = models.IntegerField()
    bad_production_rate = models.IntegerField()


    def __str__(self):
        return f"{self.machine_name} - Good: {self.good_production_rate}, Mean: {self.mean_production_rate}, Bad: {self.bad_production_rate}"
    class Meta:
        db_table="productionstandard"
class DailyProduction(models.Model):
    machine = models.ForeignKey(Asset, on_delete=models.CASCADE,related_name="dailyproduction_machine")
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE,related_name="dailyproduction_shift")
    dayOfIssue = models.DateField()
    timestamp = models.DateTimeField(auto_now_add=True)
    register_user = models.CharField(max_length=100)
    speed=models.IntegerField(default=0)
    nomre = models.FloatField()
    counter = models.FloatField()
    production_value = models.IntegerField(blank=True, null=True)  # Result of the formula
    def eval_max_tolid(self):
        if self.machine:
                formula_obj = SpeedFormula.objects.get(machine=self.machine)
                formula = formula_obj.formula

                # Parameters for the evaluation (counter and nomre)
                parameters = {
                    'Z': self.speed,
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
                    # self.production_value = calculated_value
                    return calculated_value

                except (SyntaxError, ValueError) as e:
                    # Handle exceptions if the formula is incorrect or cannot be evaluated
                    print(f"Error evaluating formula: {e}")
                    return 0
                    # You can set a default value or handle the error as per your requirement



    # def save(self, *args, **kwargs):
    #     # Calculate production value based on the specified formula
    #     if self.machine:
    #         formula_obj = Formula.objects.get(machine=self.machine)
    #         formula = formula_obj.formula
    #
    #         # Parameters for the evaluation (counter and nomre)
    #         parameters = {
    #             'Q': self.counter,
    #             'P': self.nomre
    #         }
    #
    #         # Replace parameters in the formula with actual values
    #         for param, value in parameters.items():
    #             formula = formula.replace(param, str(value))
    #         formula = formula.replace("/", " / ")
    #
    #         # Evaluate the modified formula
    #         try:
    #             # Evaluating the formula string to get the calculated value
    #             # Use ast.literal_eval to evaluate the expression safely
    #             calculated_value = eval(formula)
    #             self.production_value = calculated_value
    #         except (SyntaxError, ValueError) as e:
    #             # Handle exceptions if the formula is incorrect or cannot be evaluated
    #             print(f"Error evaluating formula: {e}")
    #             # You can set a default value or handle the error as per your requirement
    #
    #     super(DailyProduction, self).save(*args, **kwargs)
    class Meta:
        db_table="dailyproduction"

class Zayeat(models.Model):
    name = models.CharField(max_length=100)
    assets = models.ManyToManyField(Asset)

    def __str__(self):
        return self.name
    class Meta:
        db_table="zayeat"

class ZayeatVaz(models.Model):
    zayeat = models.ForeignKey(Zayeat, on_delete=models.CASCADE)
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE)
    vazn = models.FloatField()
    dayOfIssue = models.DateField()



    def __str__(self):
        return f"{self.zayeat.name} - {self.vazn} kg"
    class Meta:
        db_table="zayeatvazn"
