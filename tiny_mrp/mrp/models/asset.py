from django.db import models

class AssetCategory(models.Model):
    name=models.CharField("نام",max_length = 50)
    code=models.CharField("کد",max_length = 50)
    description=models.CharField("توضیحات",max_length = 50)
    priority=models.IntegerField("اولویت", null=True)
    isPartOf = models.ForeignKey('self',on_delete=models.CASCADE,verbose_name="زیر مجموعه",null=True,blank=True)
    def __str__(self):
        return self.name
    def get_all_child_categories(self):
        def _get_child_categories(category):
            children = AssetCategory.objects.filter(isPartOf=category)
            for child in children:
                yield child
                yield from _get_child_categories(child)

        child_categories = list(_get_child_categories(self))
        return child_categories

    class Meta:
       db_table = "assetcategory"
       ordering = ('priority',)
#used for moshakhase definition "entryform"
class AssetCategory2(models.Model):
    name=models.CharField("نام",max_length = 50)
    code=models.CharField("کد",max_length = 50)
    description=models.CharField("توضیحات",max_length = 50)
    priority=models.IntegerField("اولویت", null=True)
    isPartOf = models.ForeignKey('self',on_delete=models.CASCADE,verbose_name="زیر مجموعه",null=True,blank=True)
    def __str__(self):
        return self.name
    def get_all_child_categories(self):
        def _get_child_categories(category):
            children = AssetCategory.objects.filter(isPartOf=category)
            for child in children:
                yield child
                yield from _get_child_categories(child)

        child_categories = list(_get_child_categories(self))
        return child_categories

    class Meta:
       db_table = "assetcategory2"
       ordering = ('priority',)

class MachineCategory(models.Model):
    name=models.CharField("نام",max_length = 50)
    description=models.CharField("توضیحات",max_length = 50)

    isPartOf = models.ForeignKey('self',on_delete=models.CASCADE,verbose_name="زیر مجموعه",null=True,blank=True)
    def __str__(self):
        return self.name

    class Meta:
       db_table = "machinecategory"

class Asset(models.Model):
    def __str__(self):
        return self.assetName
        # if(self.assetIsLocatedAt):
        #     return "{}-{}-{}".format(self.assetName,self.assetCode if (self.assetCode != None) else 'فاقد کد',self.assetIsLocatedAt.assetName)
        # return "{}-{}-{}".format(self.assetName,self.assetCode if (self.assetCode != None) else 'فاقد کد',"بدون مکان")
    def get_location(self):
        if(self.assetIsLocatedAt):

            return "{}".format(self.assetIsLocatedAt)
        else:
            return "-"
    def get_child(self):
        return Asset.objects.filter(Q(assetIsLocatedAt=self.id)|Q(assetIsPartOf=self.id)).filter(assetTypes=1)
    def get_asset_loc_code(self):

        if(self.assetTypes==1):
            if(self.assetCode):
                return "{}".format(self.assetCode)

            elif(self.assetIsLocatedAt):
                return "{}".format(self.assetIsLocatedAt.assetCode)

            else:
                    return 'NoLoc' #for location
        else:
            if(self.assetIsLocatedAt):
                return "{}".format(self.assetIsLocatedAt.assetCode)
            else:
                return 'NoLoc'
    def get_name(self):
        if(self.assetName):
            return "{}".format(self.assetName)
        return "مشخص نشده"
    def get_assetStatus(self):
                 if(self.assetStatus==True):
                     return "<i class='fa fa-play'></i>								"
                 else:
                     return "<i class='fa fa-stop'></i>"
    def get_assetStatusIcon(self):

        # books = self.workorder_set.all().count()
        if(self.assetStatus==True):
                     return "<i class='fa fa-play'></i>								"
        else:
                     return "<i class='fa fa-wrench'></i>"
    def get_assetStatusColor(self):
                 if(self.assetStatus==True):
                     return "success"
                 else:
                     return "danger"
    def get_assetid(self):

                 return self.assetIsLocatedAt.id

    Location=1
    Equipment=2
    Tool=3


    AssetType=(

        (Location,'مکان'),
        (Equipment ,'ماشین  آلات'),
        (Tool,'ابزارآلات'),

    )

    assetTypes=models.IntegerField("نوع دارایی", choices=AssetType,null=True,blank=True)
    assetName=models.CharField("مشخصات",max_length = 100)
    assetDescription=models.CharField("توضیحات",max_length = 100,null=True,blank=True)
    assetCode=models.CharField("کد",max_length = 50,null=True,blank=True)
    assetIsPartOf = models.ForeignKey('self',on_delete=models.SET_NULL,verbose_name="زیر مجموعه",null=True,blank=True)
    assetIsLocatedAt = models.ForeignKey('self',on_delete=models.SET_NULL,verbose_name="مکان",null=True,blank=True,related_name="location")
    assetCategory=models.ForeignKey(AssetCategory,on_delete=models.SET_NULL,verbose_name="دسته بندی",null=True,blank=True)
    #used for  moshakhase
    assetCategory2=models.ForeignKey(AssetCategory2,on_delete=models.SET_NULL,verbose_name="دسته بندی",null=True,blank=True,related_name="cat_moshakhase")
    #result related to asset and measured according to Asset

    assetAddress=models.CharField("آدرس",max_length = 100,null=True,blank=True)
    assetCity=models.CharField("شهر",max_length = 50,null=True,blank=True)
    assetState=models.CharField("استان",max_length = 50,null=True,blank=True)
    assetZipcode=models.CharField("کد پستی",max_length = 50,null=True,blank=True)
    assetCountry=models.CharField("کشور",max_length = 100,null=True,blank=True)
    assetAccount=models.CharField("حساب",max_length = 100,null=True,blank=True)
    assetChargeDepartment=models.CharField("دپارتمان مسوول",max_length = 100,null=True,blank=True)
    assetNotes=models.CharField("یادداشت",max_length = 100,null=True,blank=True)
    assetBarcode=models.IntegerField("بارکد",null=True,blank=True)
    assetHasPartOf=models.BooleanField(default=False)
    assetAisel=models.IntegerField("راهرو",null=True,blank=True)
    assetRow=models.IntegerField("ردیف",null=True,blank=True)
    assetBin=models.IntegerField("Bin",null=True,blank=True)
    assetManufacture=models.CharField("سازنده",max_length = 50,null=True,blank=True)
    assetModel=models.CharField("مدل",max_length = 50,null=True,blank=True)
    assetSerialNumber=models.CharField("شماره سریال",max_length = 50,null=True,blank=True)
    assetStatus=models.BooleanField("وضعیت",default=True)
    assetMachineCategory=models.ForeignKey(MachineCategory,on_delete=models.CASCADE,null=True,blank=True,verbose_name="نوع دستگاه")
    assetIsStock=models.BooleanField("انبار",default=False)
    assetTavali=models.IntegerField("شماره توالی",null=True,blank=True)
    assetVahed=models.IntegerField("تعداد واحد",null=True,blank=True)





    class Meta:
      db_table = "assets"
      ordering = ('assetTavali','assetName' )

class Asset2(models.Model):
    def __str__(self):
        return self.assetName
        # if(self.assetIsLocatedAt):
        #     return "{}-{}-{}".format(self.assetName,self.assetCode if (self.assetCode != None) else 'فاقد کد',self.assetIsLocatedAt.assetName)
        # return "{}-{}-{}".format(self.assetName,self.assetCode if (self.assetCode != None) else 'فاقد کد',"بدون مکان")
    def get_location(self):
        if(self.assetIsLocatedAt):

            return "{}".format(self.assetIsLocatedAt)
        else:
            return "-"
    def get_child(self):
        return Asset.objects.filter(Q(assetIsLocatedAt=self.id)|Q(assetIsPartOf=self.id)).filter(assetTypes=1)
    def get_asset_loc_code(self):

        if(self.assetTypes==1):
            if(self.assetCode):
                return "{}".format(self.assetCode)

            elif(self.assetIsLocatedAt):
                return "{}".format(self.assetIsLocatedAt.assetCode)

            else:
                    return 'NoLoc' #for location
        else:
            if(self.assetIsLocatedAt):
                return "{}".format(self.assetIsLocatedAt.assetCode)
            else:
                return 'NoLoc'
    def get_name(self):
        if(self.assetName):
            return "{}".format(self.assetName)
        return "مشخص نشده"
    def get_assetStatus(self):
                 if(self.assetStatus==True):
                     return "<i class='fa fa-play'></i>								"
                 else:
                     return "<i class='fa fa-stop'></i>"
    def get_assetStatusIcon(self):

        # books = self.workorder_set.all().count()
        if(self.assetStatus==True):
                     return "<i class='fa fa-play'></i>								"
        else:
                     return "<i class='fa fa-wrench'></i>"
    def get_assetStatusColor(self):
                 if(self.assetStatus==True):
                     return "success"
                 else:
                     return "danger"
    def get_assetid(self):

                 return self.assetIsLocatedAt.id

    Location=1
    Equipment=2
    Tool=3


    AssetType=(

        (Location,'مکان'),
        (Equipment ,'ماشین  آلات'),
        (Tool,'ابزارآلات'),

    )

    assetTypes=models.IntegerField("نوع دارایی", choices=AssetType,null=True,blank=True)
    assetName=models.CharField("مشخصات",max_length = 100)
    assetDescription=models.CharField("توضیحات",max_length = 100,null=True,blank=True)
    assetCode=models.CharField("کد",max_length = 50,null=True,blank=True)
    assetIsPartOf = models.ForeignKey('self',on_delete=models.SET_NULL,verbose_name="زیر مجموعه",null=True,blank=True)
    assetIsLocatedAt = models.ForeignKey('self',on_delete=models.SET_NULL,verbose_name="مکان",null=True,blank=True,related_name="location")
    assetCategory=models.ForeignKey(AssetCategory,on_delete=models.SET_NULL,verbose_name="دسته بندی",null=True,blank=True)
    #result related to asset and measured according to Asset

    assetAddress=models.CharField("آدرس",max_length = 100,null=True,blank=True)
    assetCity=models.CharField("شهر",max_length = 50,null=True,blank=True)
    assetState=models.CharField("استان",max_length = 50,null=True,blank=True)
    assetZipcode=models.CharField("کد پستی",max_length = 50,null=True,blank=True)
    assetCountry=models.CharField("کشور",max_length = 100,null=True,blank=True)
    assetAccount=models.CharField("حساب",max_length = 100,null=True,blank=True)
    assetChargeDepartment=models.CharField("دپارتمان مسوول",max_length = 100,null=True,blank=True)
    assetNotes=models.CharField("یادداشت",max_length = 100,null=True,blank=True)
    assetBarcode=models.IntegerField("بارکد",null=True,blank=True)
    assetHasPartOf=models.BooleanField(default=False)
    assetAisel=models.IntegerField("راهرو",null=True,blank=True)
    assetRow=models.IntegerField("ردیف",null=True,blank=True)
    assetBin=models.IntegerField("Bin",null=True,blank=True)
    assetManufacture=models.CharField("سازنده",max_length = 50,null=True,blank=True)
    assetModel=models.CharField("مدل",max_length = 50,null=True,blank=True)
    assetSerialNumber=models.CharField("شماره سریال",max_length = 50,null=True,blank=True)
    assetStatus=models.BooleanField("وضعیت",default=True)
    assetMachineCategory=models.ForeignKey(MachineCategory,on_delete=models.CASCADE,null=True,blank=True,verbose_name="نوع دستگاه")
    assetIsStock=models.BooleanField("انبار",default=False)
    assetTavali=models.IntegerField("شماره توالی",null=True,blank=True)
    assetVahed=models.IntegerField("تعداد واحد",null=True,blank=True)





    class Meta:
      db_table = "assets2"
      ordering = ('assetTavali','assetName' )

