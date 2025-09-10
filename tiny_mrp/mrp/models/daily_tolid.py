from django.db import models
from mrp.models.asset import Asset
import jdatetime
import ast
from django.core.exceptions import ValidationError
import json
from mrp.models.operators import *
from mrp.models.moshakhase import *
import math

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
    moshakhase = models.ForeignKey(EntryForm, on_delete=models.CASCADE,related_name="dailyproduction_moshakhase",blank=True,null=True)
    dayOfIssue = models.DateField()
    timestamp = models.DateTimeField(auto_now_add=True)
    register_user = models.CharField(max_length=100)
    speed=models.FloatField(default=0)
    nomre = models.FloatField()
    counter1 = models.CharField(max_length=200,null=True,blank=True)
    counter2 = models.CharField(max_length=200,null=True,blank=True)
    vahed = models.FloatField()
    production_value = models.FloatField(blank=True, null=True)  # Result of the formula
    wastage_value = models.FloatField(blank=True, null=True)  # wastage foreach machine
    enzebat_value = models.FloatField(blank=True, null=True)  # wastage foreach machine
    qc_value = models.FloatField(blank=True, null=True)  # wastage foreach machine
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
    # NEW OPERATOR FIELDS
    # Store operator data as JSON for multiple operators
    # operators_data = models.JSONField(null=True, blank=True, help_text="JSON data containing multiple operators")
    # operators_data = models.TextField(null=True, blank=True, help_text="JSON data containing multiple operators")  # keep original
    operators_data = models.JSONField(null=True, blank=True)  # new field
    
    def __str__(self):
        return f"{self.nomre} , {self.speed} ,{self.counter2}, {self.machine}"
    def eval_max_tolid(self):
        if self.machine:
                formula_obj = SpeedFormula.objects.get(machine=self.machine)
                formula = formula_obj.formula

                # Parameters for the evaluation (counter and nomre)
                parameters = {
                    'Q': self.speed,
                    'P': self.nomre,
                    'Z':self.vahed
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
                    return int(calculated_value)
                except (ZeroDivisionError, ValueError):
                    return 0

                except (SyntaxError, ValueError) as e:
                    # Handle exceptions if the formula is incorrect or cannot be evaluated
                    print(f"Error evaluating formula: {e}")
                    return 0
                    # You can set a default value or handle the error as per your requirement
    def get_randeman_production(self):
        # Initialize values, defaulting to 0 if None
        enzebat = self.enzebat_value if self.enzebat_value is not None else 0
        wastage = self.wastage_value if self.wastage_value is not None else 0
        qc = self.qc_value if self.qc_value is not None else 0
        production = self.production_value if self.production_value is not None else 0

        # Get the number of operators from operators_data JSON
        operator_count = 1  # Default to 1 to avoid division by zero
        if self.operators_data:
            try:
                # Parse JSON to count operators
                operators = self.operators_data
                if isinstance(operators, str):
                    operators = json.loads(operators)
                operator_count = len(operators) if isinstance(operators, list) and operators else 1
            except (json.JSONDecodeError, TypeError) as e:
                print(f"Error parsing operators_data JSON: {e}")
                operator_count = 1  # Fallback to 1 on error

        # Calculate formula: (production - wastage - qc) * (enzebat / 100) / operator_count
        result = ((production - wastage - qc) * (enzebat / 100)) / operator_count

        # Round to 2 decimal places and handle NaN
        return round(result, 2) if not math.isnan(result) else 0
    # NEW METHODS FOR OPERATOR MANAGEMENT
    def set_moshakhase(self,moshakhase):
         if isinstance(moshakhase, str):

            try:
                # print(operators_list)


                moshakhase = json.loads(moshakhase)
                
                

                if not moshakhase:

                    self.moshakhase = None
                    return
                else:
                    self.moshakhase=EntryForm.objects.get(id=int(moshakhase["id"]))
                    return 
                
                    

            except json.JSONDecodeError:
                self.operators_data = None

                return

    def set_operators(self, operators_list):

        """
        Set operators from a list of operator dictionaries or IDs
        
        Args:
            operators_list: List of operator data dictionaries or operator IDs
        """
        # Handle None, empty list, or empty string
        if not operators_list or (isinstance(operators_list, (list, tuple)) and len(operators_list) == 0):
            # print(json.load(operators_list))


            self.operators_data = None
            return
        
        # Handle string input (JSON string)
        if isinstance(operators_list, str):

            try:
                # print(operators_list)
                # print(json.load(operators_list))



                operators_list = operators_list
                
                

                if not operators_list:

                    self.operators_data = None
                    return
                elif operators_list!=None:
                    self.operators_data=operators_list
                
                    

            except json.JSONDecodeError:
                self.operators_data = None

                return
        
        # # Ensure we have a list
        # if not isinstance(operators_list, (list, tuple)):
        #     print(1)
        #     self.operators_data = None

            return
        # Check if list is empty after conversion
        if len(operators_list) == 0:
            print("len0")
            self.operators_data = None
            return
            
        # If list contains dictionaries (from frontend)
        if isinstance(operators_list[0], dict):


            # Validate that dictionaries have required fields
            valid_operators = []
            for op_dict in operators_list:
                if isinstance(op_dict, dict) and 'id' in op_dict:
                    valid_operators.append(op_dict)
                else:
                    print("1")

            print("1")

            
            self.operators_data = json.dumps(valid_operators) if valid_operators else None
            
        # If list contains operator IDs
        elif isinstance(operators_list[0], (int, str)):




            operators_data = []
            for op_id in operators_list:
                try:
                    # Convert to int if string
                    if isinstance(op_id, str):
                        if not op_id.strip().isdigit():
                            continue
                        op_id = int(op_id.strip())
                    
                    operator = Operator.objects.get(id=op_id)
                    operators_data.append({
                        'id': operator.id,
                        'name': f"{operator.FName} {operator.LName}",
                        'personnel_number': operator.PNumber,
                        'pid': operator.Pid,
                        'cp_code': operator.CpCode,
                        'card_no': operator.CardNo,
                    })
                    print("1")

                except (Operator.DoesNotExist, ValueError, TypeError):

                    continue
                    
            self.operators_data = json.dumps(operators_data) if operators_data else None
        else:
            print("1")

            # Unknown format, clear the data
            self.operators_data = None


    def get_operators(self):
        """
        Get operators as a list of dictionaries
        
        Returns:
            List of operator dictionaries
        """
       
        
        if not self.operators_data:
            return 'نامشخص'
        
        try:
            operators=''
            for i in json.loads(self.operators_data):
                
              
                operators+=f"({i['id']}):{i['name']}"+"</br>"
            return operators
            

        except (json.JSONDecodeError, TypeError):
            return 'نامشخص'
        except:
            return 'نامشخص'

    def get_operator_names(self):
        """
        Get comma-separated list of operator names
        
        Returns:
            String of operator names separated by commas
        """
        operators = self.get_operators()
        if not operators:
            return "No operators assigned"
        
        names = [op.get('name', 'Unknown') for op in operators]
        return ', '.join(names)

    def get_operator_ids(self):
        """
        Get list of operator IDs
        
        Returns:
            List of operator IDs
        """
        operators = self.get_operators()
        return [op.get('id') for op in operators if op.get('id')]

    def add_operator(self, operator_id):
        """
        Add an operator to existing operators
        
        Args:
            operator_id: ID of the operator to add
        """
        current_operators = self.get_operators()
        
        # Check if operator already exists
        existing_ids = [op.get('id') for op in current_operators]
        if operator_id in existing_ids:
            return  # Operator already exists
            
        try:
            operator = Operator.objects.get(id=operator_id)
            new_operator = {
                'id': operator.id,
                'name': f"{operator.FName} {operator.LName}",
                'personnel_number': operator.PNumber,
                'pid': operator.Pid,
                'cp_code': operator.CpCode,
                'card_no': operator.CardNo,
            }
            current_operators.append(new_operator)
            self.operators_data = json.dumps(current_operators)
        except Operator.DoesNotExist:
            pass

    def remove_operator(self, operator_id):
        """
        Remove an operator from the list
        
        Args:
            operator_id: ID of the operator to remove
        """
        current_operators = self.get_operators()
        updated_operators = [op for op in current_operators if op.get('id') != operator_id]
        self.operators_data = json.dumps(updated_operators) if updated_operators else None

    def clean(self):
        """
        Validate operators_data JSON format
        """
        if self.operators_data:
            try:
                json.loads(self.operators_data)
            except json.JSONDecodeError:
                raise ValidationError({'operators_data': 'Invalid JSON format for operators data'})




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
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE)
    vazn = models.FloatField()
    dayOfIssue = models.DateField()
    makan=models.ForeignKey(Asset, on_delete=models.CASCADE,related_name="zayeat_makan",null=True,blank=True)



    def __str__(self):
        return f"{self.zayeat.name} - {self.vazn} kg"
    class Meta:
        db_table="zayeatvazn"
class AssetRandemanInit(models.Model):
    asset_category = models.ForeignKey('AssetCategory', on_delete=models.CASCADE,verbose_name='نوع تجهیز')
    operator_count = models.IntegerField("تعداد اپراتور",default=0)
    max_randeman = models.DecimalField("حداکثر راندمان",max_digits=10, decimal_places=0,default=0)
    randeman_yek_dastgah = models.DecimalField("راندمان کل یک دستگاه",max_digits=10, decimal_places=0,default=0)
    randeman_mazrab_3 = models.DecimalField("مضرب 3 رانمان",max_digits=10, decimal_places=0,default=0)
    mablaghe_kole_randeman = models.DecimalField("مبلغ کل راندمان (واقعی)",max_digits=10, decimal_places=0,default=0)
    mablaghe_kole_randeman_round = models.DecimalField("مبلغ کل راندمان (واقعی)",max_digits=10, decimal_places=0,default=0)
    randeman_tolid = models.DecimalField("راندمان تولید",max_digits=10, decimal_places=0,default=0)
    profile = models.ForeignKey('FinancialProfile', on_delete=models.CASCADE,null=True,blank=True)
    production_line=models.ForeignKey('Asset', on_delete=models.CASCADE,null=True,blank=True,related_name="ranemna_productionn_line")

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
class OperatorProduction(models.Model):
    assetrandeman = models.ForeignKey('AssetRandemanList', on_delete=models.CASCADE, related_name='productions')
    operator = models.ForeignKey('Operator', on_delete=models.CASCADE, related_name='operator_productions')
    machine = models.ForeignKey('Asset', on_delete=models.CASCADE, related_name='asset_operator_productions')
    tolid = models.FloatField()
    price = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return f"Production {self.id} - {self.assetrandeman}"

    class Meta:
        verbose_name = 'OperatorProduction'
        verbose_name_plural = 'OperatorProductions'

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
