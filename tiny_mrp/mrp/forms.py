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
