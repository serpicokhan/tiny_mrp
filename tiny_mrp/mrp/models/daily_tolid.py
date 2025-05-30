from django.db import models
from mrp.models.asset import Asset
import jdatetime
import ast


class Shift(models.Model):
    name = models.CharField("نام شیفت",max_length=255)
    def __str__(self):
        return f"{self.name}"
    class Meta:
        db_table="shift"
        ordering=('id',)

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
    production_value = models.FloatField(blank=True, null=True)  # Result of the formula
    daf_num = models.FloatField(null=True, blank=True)
    dook_weight = models.FloatField(null=True, blank=True)
    weight1 = models.FloatField(null=True, blank=True)
    weight2 = models.FloatField(null=True, blank=True)
    weight3 = models.FloatField(null=True, blank=True)
    weight4 = models.FloatField(null=True, blank=True)
    weight5 = models.FloatField(null=True, blank=True)
    net_weight = models.FloatField(null=True, blank=True)
    metrajdaf1 = models.FloatField(null=True, blank=True)
    metrajdaf2 = models.FloatField(null=True, blank=True)
    metrajdaf3 = models.FloatField(null=True, blank=True)
    metrajdaf4 = models.FloatField(null=True, blank=True)
    metrajdaf5 = models.FloatField(null=True, blank=True)
    metrajdaf6 = models.FloatField(null=True, blank=True)
    metrajdaf7 = models.FloatField(null=True, blank=True)
    metrajdaf8 = models.FloatField(null=True, blank=True)
    makhraj_metraj_daf = models.FloatField(null=True, blank=True)
    def __str__(self):
        return f"{self.nomre} , {self.speed} ,{self.counter}"
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
                except (ZeroDivisionError, ValueError):
                    return 0

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
        unique_together = (('machine', 'shift','dayOfIssue'),)

class Zayeat(models.Model):
    name = models.CharField(max_length=100)
    assets = models.ManyToManyField(Asset)

    def __str__(self):
        return self.name
    class Meta:
        db_table="zayeat"

class ZayeatVaz(models.Model):
    zayeat = models.ForeignKey(Zayeat, on_delete=models.CASCADE)
    moshakhase = models.ForeignKey("EntryForm", on_delete=models.SET_NULL,related_name="moshakhase_zayeat",blank=True,null=True)
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE)
    vazn = models.FloatField()
    dayOfIssue = models.DateField()



    def __str__(self):
        return f"{self.zayeat.name} - {self.vazn} kg"
    class Meta:
        db_table="zayeatvazn"
class AssetRandemanInit(models.Model):
    asset_category = models.ForeignKey('AssetCategory', on_delete=models.CASCADE,verbose_name='نوع تجهیز')
    operator_count = models.IntegerField("تعداد اپراتور")
    max_randeman = models.DecimalField("حداکثر راندمان",max_digits=10, decimal_places=0)
    randeman_yek_dastgah = models.DecimalField("راندمان کل یک دستگاه",max_digits=10, decimal_places=0)
    randeman_mazrab_3 = models.DecimalField("مضرب 3 رانمان",max_digits=10, decimal_places=0)
    mablaghe_kole_randeman = models.DecimalField("مبلغ کل راندمان (واقعی)",max_digits=10, decimal_places=0)
    mablaghe_kole_randeman_round = models.DecimalField("مبلغ کل راندمان (واقعی)",max_digits=10, decimal_places=0)
    randeman_tolid = models.DecimalField("راندمان تولید",max_digits=10, decimal_places=0)
    profile = models.ForeignKey('FinancialProfile', on_delete=models.CASCADE,null=True,blank=True)

    class Meta:
        db_table="assetrandemaninit"

    def __str__(self):
        return f"{self.asset_name} - Operator Count: {self.operator_count}, Max Randeman: {self.max_randeman}"
class AssetRandemanList(models.Model):
    mah = models.IntegerField()
    sal = models.IntegerField()
    profile = models.ForeignKey('FinancialProfile', on_delete=models.CASCADE,null=True,blank=True,verbose_name='پروفایل مالی')

    class Meta:
        db_table="assetrandemanlist"
        ordering=('-sal','-mah')
        unique_together = ('mah', 'sal',)

class AssetRandemanPerMonth(models.Model):
    asset_category = models.ForeignKey('AssetCategory', on_delete=models.CASCADE)
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE)
    tolid_value = models.DecimalField(max_digits=15, decimal_places=2)
    asset_randeman_list = models.ForeignKey('AssetRandemanList', on_delete=models.CASCADE,null=True,blank=True)

    class Meta:
        db_table="assetrandemanpermonth"

    def __str__(self):
        return f"{self.asset_category} - Shift: {self.shift}, Tolid Value: {self.tolid_value}, MAH: {self.mah}, SAL: {self.sal}"

class NezafatRanking(models.Model):
    # Your model fields go here
    # For example:
    rank = models.IntegerField()
    asset_randeman_list = models.ForeignKey(AssetRandemanList, on_delete=models.CASCADE)
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE)
    price_sarshift = models.DecimalField(max_digits=10, decimal_places=0)
    price_personnel = models.DecimalField(max_digits=10, decimal_places=0)
    class Meta:
        db_table='nezafatranking'
    def __str__(self):
        return f'{self.id} {self.rank} {self.price_sarshift} {self.price_personel}'
class TolidRanking(models.Model):
    # Your model fields go here
    # For example:
    RANK_CHOICES = (
        (1, 'رتبه اول'),
        (2, 'رتبه دوم'),
        (3, 'رتبه سوم'),
    )
    rank = models.IntegerField(choices=RANK_CHOICES)
    asset_randeman_list = models.ForeignKey(AssetRandemanList, on_delete=models.CASCADE)
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE)
    price_sarshift = models.DecimalField(max_digits=10, decimal_places=0)
    price_personnel = models.DecimalField(max_digits=10, decimal_places=0)
    class Meta:
        db_table='tolidranking'
    def __str__(self):
        return self.description
class TolidRanking_V2(models.Model):
    # Your model fields go here
    # For example:
    RANK_CHOICES = (
        (1, 'رتبه اول'),
        (2, 'رتبه دوم'),
        (3, 'رتبه سوم'),
    )
    rank = models.IntegerField(choices=RANK_CHOICES)
    asset_randeman_list = models.ForeignKey(AssetRandemanList, on_delete=models.CASCADE)
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE)
    price_sarshift = models.DecimalField(max_digits=10, decimal_places=0)
    price_personnel = models.DecimalField(max_digits=10, decimal_places=0)
    assetMachineCategory=models.ForeignKey("MachineCategory",on_delete=models.CASCADE,null=True,blank=True,verbose_name="نوع دستگاه")
    
    class Meta:
        db_table='tolidranking_v2'
    def __str__(self):
        return self.description

class NezafatPadash(models.Model):
    RANK_CHOICES = (
        (1, 'رتبه اول'),
        (2, 'رتبه دوم'),
        (3, 'رتبه سوم'),
    )
    rank = models.IntegerField(choices=RANK_CHOICES)
    description = models.TextField("َشرح")
    price_sarshift = models.DecimalField("پاداش سرشیفت",max_digits=10, decimal_places=0)
    price_personnel = models.DecimalField("پاداش پرسنل",max_digits=10, decimal_places=0)
    profile = models.ForeignKey('FinancialProfile', on_delete=models.CASCADE,null=True,blank=True)


    class Meta:
        db_table='nezafatpadash'
        ordering=('rank',)
    def __str__(self):
        return f"Rank: {self.rank}, Price: {self.price_personnel}"
class TolidPadash(models.Model):

    description = models.TextField("شرح")
    rank = models.IntegerField("رتبه")
    price_sarshift = models.DecimalField("پاداش سرشیفت",max_digits=10, decimal_places=0)
    price_personnel = models.DecimalField("پاداش پرسنل",max_digits=10, decimal_places=0)
  
    profile = models.ForeignKey('FinancialProfile', on_delete=models.CASCADE,null=True,blank=True)

    class Meta:
        db_table='tolidpadash'
        ordering=('rank',)
    def __str__(self):
        return f"Rank: {self.rank}, Price: {self.price_sarshift}"

class TolidPadash_V2(models.Model):

    description = models.TextField("شرح")
    rank = models.IntegerField("رتبه")
    price_personnel = models.DecimalField("پاداش پرسنل",max_digits=10, decimal_places=0)
  
    profile = models.ForeignKey('FinancialProfile', on_delete=models.CASCADE,null=True,blank=True)
    assetMachineCategory = models.ForeignKey('MachineCategory', on_delete=models.CASCADE,null=True,blank=True)

    class Meta:
        db_table='tolidpadash_v2'
        ordering=('rank',)
    def __str__(self):
        return f"Rank: {self.rank}, Price: {self.price_sarshift}"
class FinancialProfile(models.Model):
    def get_jalali_time_created(self):
        return jdatetime.date.fromgregorian(date=self.time_created)
    description = models.TextField("شرح")
    mablagh_kol_randeman = models.DecimalField("مبلغ کل راندمان",max_digits=10, decimal_places=0)
    tolid_randeman = models.DecimalField("راندمان تولید",max_digits=10, decimal_places=0)
    tolid_randeman_mazrab_3 = models.DecimalField("مضرب 3 راندمان",max_digits=10, decimal_places=0)
    time_created = models.DateTimeField(auto_now_add=True)
    class Meta:
        db_table='financialprofile'

    def __str__(self):
        return f"{self.description}"
