from rest_framework import serializers
from mrp.models import Product,BOMComponent,BillOfMaterials,UnitOfMeasure,WorkCenter,Customer

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'
class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer
        fields = '__all__'
class BOMComponentSerializer(serializers.ModelSerializer):
    product = ProductSerializer()
    uom = serializers.CharField(source='uom.abbreviation')

    class Meta:
        model = BOMComponent
        fields = ['id', 'product', 'quantity', 'uom']

class BillOfMaterialsSerializer(serializers.ModelSerializer):
    product = ProductSerializer()
    components = BOMComponentSerializer(many=True, source='bomcomponent_set')
    updated_at = serializers.DateTimeField(format="%Y-%m-%dT%H:%M:%SZ")

    class Meta:
        model = BillOfMaterials
        fields = ['id', 'reference', 'product', 'operation_time', 'updated_at', 'components']

class WorkCenterSerializer(serializers.ModelSerializer):
    class Meta:
        model = WorkCenter
        fields = ['id', 'code', 'name', 'capacity_per_hour', 'active', 'updated_at']
        read_only_fields = ['id', 'updated']


def serialize_daily_production(instance):
    """تبدیل مدل به دیکشنری برای ذخیره در JSON"""
    return {
        'machine': instance.machine.assetName if instance.machine else None,
        'shift': instance.shift.name if instance.shift else None,
        'moshakhase': str(instance.moshakhase) if instance.moshakhase else None,
        'dayOfIssue': instance.dayOfIssue.isoformat() if instance.dayOfIssue else None,
        'register_user': instance.register_user,
        'speed': instance.speed,
        'nomre': instance.nomre,
        'counter1': instance.counter1,
        'counter2': instance.counter2,
        'vahed': instance.vahed,
        'production_value': instance.production_value,
        'wastage_value': instance.wastage_value,
        'enzebat_value': instance.enzebat_value,
        'qc_value': instance.qc_value,
        'timestamp': instance.timestamp.isoformat() if instance.timestamp else None,
    }