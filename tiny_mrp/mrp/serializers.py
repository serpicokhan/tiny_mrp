from rest_framework import serializers
from mrp.models import Product,BOMComponent,BillOfMaterials,UnitOfMeasure,WorkCenter

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
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