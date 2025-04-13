from rest_framework import serializers
from mrp.models import Product,BOMComponent,BillOfMaterials,UnitOfMeasure

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
    components = BOMComponentSerializer(many=True, read_only=True)
    updated_at = serializers.DateTimeField(format="%Y-%m-%dT%H:%M:%SZ")
    
    class Meta:
        model = BillOfMaterials
        fields = ['id', 'reference', 'product', 'operation_time', 'updated_at', 'components']