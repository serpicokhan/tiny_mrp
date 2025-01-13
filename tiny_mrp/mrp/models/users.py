from django.db import models
from datetime import datetime
import os
from django.contrib.auth.models import User
import jdatetime
from django.utils.timezone import now


class SysUser(models.Model):
    def __str__(self):
        return "{}".format(self.fullName)
    def get_userStatus(self):
                 if(self.userStatus==True):
                     return "<i class='fa fa-play'></i>								"
                 else:
                     return "<i class='fa fa-stop'></i>"
    def getName(self):

        xxxx=UserGroups.objects.filter(userUserGroups=self.id)
        st=[]
        for i in xxxx:
            st.append(i.groupUserGroups)
        # print(''.join(str(e) for e in st))
        return '<br/>'.join(str(e) for e in st)


    Dashboard=1
    WorkOrderAssignedToMe=2
    MessageCenterInbox=3
    WorkOrders=4
    Location=(
        (Dashboard,'داشبورد'),
        (WorkOrderAssignedToMe,'درخواستهای انتسابی به من'),
        (MessageCenterInbox,'صندوق ورودی پیامها'),
        (WorkOrders,'درخواست'),
    )
    userId = models.OneToOneField(User, on_delete=models.CASCADE,null=True,blank=True)
    password=models.CharField(max_length=20)
    token=models.CharField(max_length=20,null=True,blank=True)
    fullName=models.CharField("مشخصات کامل",max_length = 50)
    personalCode=models.CharField("کد پرسنلی",max_length = 50)
    title=models.CharField("عنوان",max_length = 50,null=True,blank=True)
    email=models.EmailField("ایمیل",max_length=70,blank=True, null= True, unique= True)
    tel1=models.CharField("تلفن",max_length = 50,null=True,blank=True)
    tel2=models.CharField("تلفن 2",max_length = 50,null=True,blank=True)
    addr1=models.CharField("آدرس",max_length = 50,null=True,blank=True)
    addr2=models.CharField("آدرس 2",max_length = 50,null=True,blank=True)
    city=models.CharField("شهر",max_length = 50,null=True,blank=True)
    state=models.CharField("استان",max_length = 50,null=True,blank=True)
    country=models.CharField("کشور",max_length = 50,null=True,blank=True)
    postalCode=models.CharField("کدپستی",max_length = 50,null=True,blank=True)
    hourlyRate=models.FloatField("نرخ دستمزد ساعتی",null=True, blank=True,default=0)
    defaultLoginLocation=models.FloatField("صفحه پیش فرض", choices=Location,null=True,blank=True)
    profileImage = models.ImageField(upload_to='images/',default=None,blank=True)

    userStatus=models.BooleanField("وضعیت",default=True)

    class Meta:
        db_table="sysusers"
        ordering = ['title']
        permissions = [
            ("can_view_dashboard", "can view dashboard"),
            ("can_admin_purchase", "can admin create purchase"),
            ("view_all_request", "can view  all purchase request"),
            ("can_confirm_request", "can confirm request"),

        ]
