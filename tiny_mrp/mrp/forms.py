from django import forms
from mrp.models import *
class ZayeatVaznForm(forms.ModelForm):
    class Meta:
         model = ZayeatVaz
         fields = '__all__'

class AssetFailureForm(forms.ModelForm):
    asset_name= forms.ModelChoiceField(label="نام مکان",queryset=Asset.objects.filter(assetIsLocatedAt__isnull=False,assetTypes=2),
    widget=forms.Select(attrs={'class':'selectpicker','data-live-search':'true'}),required=False)
    class Meta:
         model = AssetFailure
         fields = '__all__'

class FailureForm(forms.ModelForm):
    class Meta:
         model = Failure
         fields = '__all__'
class HeatsetMetrajForm(forms.Form):
    metrajdaf1 = forms.IntegerField(initial=0)
    metrajdaf2 = forms.IntegerField(initial=0)
    metrajdaf3 = forms.IntegerField(initial=0)
    metrajdaf4 = forms.IntegerField(initial=0)
    metrajdaf5 = forms.IntegerField(initial=0)
    metrajdaf6 = forms.IntegerField(initial=0)
    metrajdaf7 = forms.IntegerField(initial=0)
    metrajdaf8 = forms.IntegerField(initial=0)
    makhraj_metraj_daf = forms.IntegerField(initial=0)

class AssetRandemanForm(forms.ModelForm):
    SAL_CHOICES = (
        (1402, '1402'),
        (1403, '1403'),
        (1404, '1404'),
    )

    MAH_CHOICES = (
         (1, "فروردین"),
        (2, "اردیبهشت"),
        (3, "خرداد"),
        (4, "تیر"),
        (5, "مرداد"),
        (6, "شهریور"),
        (7, "مهر"),
        (8, "آبان"),
        (9, "آذر"),
        (10, "دی"),
        (11, "بهمن"),
        (12, "اسفند")
        # Add other months here based on Hijri Shamsi calendar
    )

    sal = forms.ChoiceField(choices=SAL_CHOICES, label='سال')
    mah = forms.ChoiceField(choices=MAH_CHOICES, label='ماه')
    class Meta:
         model = AssetRandemanList
         fields = '__all__'
