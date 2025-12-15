from rest_framework import serializers
from mrp.models import Product,BOMComponent,BillOfMaterials,UnitOfMeasure,WorkCenter,Customer
from mrp.models import Machine_3d, Asset, AssetCategory

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

class AssetCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = AssetCategory
        fields = ['id', 'categoryName', 'categoryDescription']
        # بسته به فیلدهای مدل AssetCategory، فیلدها را تنظیم کنید

class AssetLocationSerializer(serializers.ModelSerializer):
    """Serializer مختصر برای مکان دارایی"""
    class Meta:
        model = Asset
        fields = ['id', 'assetName', 'assetCode']

class AssetSerializer(serializers.ModelSerializer):
    """Serializer کامل برای Asset"""
    
    # برای فیلدهای ForeignKey
    assetCategory = AssetCategorySerializer(read_only=True)
    assetIsLocatedAt = AssetLocationSerializer(read_only=True)
    assetIsPartOf = AssetLocationSerializer(read_only=True)
    
    # برای نمایش نام مکان
    location_name = serializers.SerializerMethodField()
    asset_type_display = serializers.CharField(source='get_assetTypes_display', read_only=True)
    
    class Meta:
        model = Asset
        fields = [
            'id',
            'assetName',
            'assetDescription',
            'assetCode',
            'assetTypes',
            'asset_type_display',
            'assetCategory',
            'assetIsLocatedAt',
            'assetIsPartOf',
            'location_name',
            'assetManufacture',
            'assetModel',
            'assetSerialNumber',
            'assetStatus',
            'assetMachineCategory',
            'assetAddress',
            'assetCity',
            'assetState',
            'assetCountry',
            'assetAisel',
            'assetRow',
            'assetBin',
            'assetTavali',
            'assetVahed',
        ]
    
    def get_location_name(self, obj):
        """نمایش نام مکان"""
        if obj.assetIsLocatedAt:
            return obj.assetIsLocatedAt.assetName
        return None

class Machine3dSerializer(serializers.ModelSerializer):
    """Serializer برای Machine_3d با فرمت مشخص و استفاده از AssetCategory"""
    
    id = serializers.SerializerMethodField()
    type = serializers.SerializerMethodField()
    name = serializers.SerializerMethodField()
    position = serializers.SerializerMethodField()
    rotation = serializers.SerializerMethodField()
    status = serializers.SerializerMethodField()
    
    class Meta:
        model = Machine_3d
        fields = ['id', 'type', 'name', 'position', 'rotation', 'status']
    
    def get_id(self, obj):
        if obj.machine and obj.machine.assetCode:
            return obj.machine.assetCode.lower().replace(' ', '_')
        return f"machine_{obj.id}"
    
    def get_type(self, obj):
        """استفاده از AssetCategory برای تعیین نوع"""
        if obj.machine and obj.machine.assetCategory:
            # فرض کنید assetCategory یک مدل ForeignKey به AssetCategory است
            # که فیلدی مثل 'category_key' یا 'name' دارد
            
            # اگر assetCategory مدل جداگانه‌ای است
            category = obj.machine.assetCategory.name
            
            # نقشه‌برداری از نام دسته‌بندی به type
           
            
            # بسته به ساختار مدل AssetCategory، یکی از این‌ها را استفاده کنید
            return category
            
        
        return "unknown"
    
    def get_name(self, obj):
        if obj.machine and obj.machine.assetName:
            return obj.machine.assetName
        return f"ماشین {obj.id}"
    
    def get_position(self, obj):
        return {
            "x": float(obj.pos_x) if obj.pos_x is not None else 0,
            "z": float(obj.pos_z) if obj.pos_z is not None else 0
        }
    
    def get_rotation(self, obj):
        if hasattr(obj, 'rotation'):
            return float(obj.rotation) if obj.rotation is not None else 0
        return 0.0
    
    def get_status(self, obj):
        if obj.machine and obj.machine.assetStatus is not None:
            return "active" if obj.machine.assetStatus else "inactive"
        return "active"

class Machine3dCreateUpdateSerializer(serializers.ModelSerializer):
    """Serializer برای ایجاد و ویرایش Machine_3d"""
    
    # برای ایجاد/ویرایش فقط machine_id را می‌گیریم
    machine_id = serializers.PrimaryKeyRelatedField(
        queryset=Asset.objects.all(),
        source='machine',
        write_only=True,
        required=False
    )
    
    class Meta:
        model = Machine_3d
        fields = [
            'id',
            'machine_id',
            'position_x',
            'position_z',
            'rotation',
        ]
    
    def validate(self, data):
        """اعتبارسنجی داده‌ها"""
        # بررسی اینکه asset از نوع Equipment باشد
        machine = data.get('machine')
        if machine and machine.assetTypes != Asset.Equipment:
            raise serializers.ValidationError(
                "فقط دارایی‌های از نوع 'ماشین آلات' می‌توانند موقعیت 3D داشته باشند"
            )
        return data
    
    def to_representation(self, instance):
        """در نمایش، از Serializer کامل استفاده می‌کنیم"""
        return Machine3dSerializer(instance, context=self.context).data

class Machine3dCompactSerializer(serializers.ModelSerializer):
    """Serializer فشرده برای لیست‌ها"""
    
    asset_info = serializers.SerializerMethodField()
    position = serializers.SerializerMethodField()
    
    class Meta:
        model = Machine_3d
        fields = [
            'id',
            'asset_info',
            'position_x',
            'position_z',
            'rotation',
            'position',
        ]
    
    def get_asset_info(self, obj):
        """اطلاعات فشرده Asset"""
        if obj.machine:
            return {
                "id": obj.machine.id,
                "name": obj.machine.assetName,
                "code": obj.machine.assetCode,
                "status": obj.machine.assetStatus,
                "type": obj.machine.get_assetTypes_display(),
            }
        return None
    
    def get_position(self, obj):
        return {
            "x": obj.position_x,
            "z": obj.position_z
        }