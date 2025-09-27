# mrp/management/commands/seed_mrp.py
from django.core.management.base import BaseCommand
from django.contrib.auth.models import User
from mrp.models import *
from datetime import datetime, timedelta
import random

class Command(BaseCommand):
    help = 'Seed MRP database with sample data'

    def handle(self, *args, **options):
        self.stdout.write('Seeding MRP data...')
        
        # ایجاد کاربران
        # users = self.create_users()
        
        # ایجاد واحدهای اندازه‌گیری
        uoms = self.create_uoms()
        
        # ایجاد محصولات
        products = self.create_products(uoms)
        
        # ایجاد BOMها
        boms = self.create_boms(products, uoms)
        
        # ایجاد مراکز کاری
        work_centers = self.create_work_centers()
        
        # ایجاد تمپلیت‌های دستور کار
        templates = self.create_work_order_templates(boms)
        
        # ایجاد عملیات‌ها
        operations = self.create_operations(templates, work_centers)
        
        # ایجاد دستورات تولید
        manufacturing_orders = self.create_manufacturing_orders(products, boms, templates, users)
        
        self.stdout.write(self.style.SUCCESS('Successfully seeded MRP data!'))

    def create_users(self):
        users = []
        user_data = [
            {'username': 'admin', 'email': 'admin@company.com', 'first_name': 'مدیر', 'last_name': 'سیستم'},
            {'username': 'supervisor1', 'email': 'supervisor1@company.com', 'first_name': 'ناظر', 'last_name': 'تولید'},
            {'username': 'operator1', 'email': 'operator1@company.com', 'first_name': 'اپراتور', 'last_name': 'یک'},
        ]
        
        for data in user_data:
            user, created = User.objects.get_or_create(
                username=data['username'],
                defaults=data
            )
            if created:
                user.set_password('123456')
                user.save()
            users.append(user)
        
        return users

    def create_uoms(self):
        uoms_data = [
            {'name': 'Units', 'abbreviation': 'pcs'},
            {'name': 'Kilograms', 'abbreviation': 'kg'},
            {'name': 'Grams', 'abbreviation': 'g'},
            {'name': 'Liters', 'abbreviation': 'l'},
            {'name': 'Meters', 'abbreviation': 'm'},
        ]
        
        uoms = []
        for data in uoms_data:
            try:
                uom, created = UnitOfMeasure.objects.get_or_create(**data)
                uoms.append(uom)
            except:
                pass
        
        return uoms

    def create_products(self, uoms):
        products_data = [
            # مواد اولیه
            {'name': 'پلاستیک خام', 'code': 'RAW-001', 'product_type': 'raw', 
             'unit_of_measure': 'kg', 'cost_price': 15.5, 'sale_price': 20.0, 'available_quantity': 500},
            {'name': 'فلز آهن', 'code': 'RAW-002', 'product_type': 'raw', 
             'unit_of_measure': 'kg', 'cost_price': 25.0, 'sale_price': 32.0, 'available_quantity': 300},
            {'name': 'سیم مسی', 'code': 'RAW-003', 'product_type': 'raw', 
             'unit_of_measure': 'm', 'cost_price': 8.0, 'sale_price': 12.0, 'available_quantity': 1000},
            
            # کامپوننت‌ها
            {'name': 'برد الکترونیکی', 'code': 'COMP-001', 'product_type': 'component', 
             'unit_of_measure': 'pcs', 'cost_price': 45.0, 'sale_price': 60.0, 'available_quantity': 200},
            {'name': 'موتور DC', 'code': 'COMP-002', 'product_type': 'component', 
             'unit_of_measure': 'pcs', 'cost_price': 80.0, 'sale_price': 110.0, 'available_quantity': 150},
            {'name': 'سنسور دما', 'code': 'COMP-003', 'product_type': 'component', 
             'unit_of_measure': 'pcs', 'cost_price': 25.0, 'sale_price': 35.0, 'available_quantity': 300},
            
            # محصولات نهایی
            {'name': 'پنکه صنعتی', 'code': 'FG-001', 'product_type': 'finished', 
             'unit_of_measure': 'pcs', 'cost_price': 200.0, 'sale_price': 280.0, 'available_quantity': 50},
            {'name': 'کنترلر دما', 'code': 'FG-002', 'product_type': 'finished', 
             'unit_of_measure': 'pcs', 'cost_price': 150.0, 'sale_price': 210.0, 'available_quantity': 30},
            {'name': 'سیستم تهویه', 'code': 'FG-003', 'product_type': 'finished', 
             'unit_of_measure': 'pcs', 'cost_price': 450.0, 'sale_price': 620.0, 'available_quantity': 20},
        ]
        
        products = []
        for data in products_data:
            # تبدیل unit_of_measure رشته‌ای به شیء UnitOfMeasure
            uom_obj = UnitOfMeasure.objects.filter(abbreviation=data['unit_of_measure'])[0]
            product_data = data.copy()
            del product_data['unit_of_measure']
            
            product, created = Product.objects.get_or_create(
                code=product_data['code'],
                defaults={**product_data, 'unit_of_measure': uom_obj}
            )
            products.append(product)
        
        return products

    def create_boms(self, products, uoms):
        boms_data = [
            {
                'reference': 'BOM-001',
                'product': 'FG-001',  # پنکه صنعتی
                'components': [
                    {'product': 'COMP-001', 'quantity': 1, 'uom': 'pcs'},  # برد الکترونیکی
                    {'product': 'COMP-002', 'quantity': 1, 'uom': 'pcs'},  # موتور DC
                    {'product': 'RAW-001', 'quantity': 2.5, 'uom': 'kg'},  # پلاستیک خام
                ],
                'operation_time': 45.0
            },
            {
                'reference': 'BOM-002',
                'product': 'FG-002',  # کنترلر دما
                'components': [
                    {'product': 'COMP-001', 'quantity': 1, 'uom': 'pcs'},  # برد الکترونیکی
                    {'product': 'COMP-003', 'quantity': 2, 'uom': 'pcs'},  # سنسور دما
                    {'product': 'RAW-003', 'quantity': 3.0, 'uom': 'm'},   # سیم مسی
                ],
                'operation_time': 30.0
            },
        ]
        
        boms = []
        for bom_data in boms_data:
            product = Product.objects.get(code=bom_data['product'])
            
            bom, created = BillOfMaterials.objects.get_or_create(
                reference=bom_data['reference'],
                defaults={
                    'product': product,
                    'operation_time': bom_data['operation_time']
                }
            )
            
            # اضافه کردن کامپوننت‌ها
            for comp_data in bom_data['components']:
                comp_product = Product.objects.get(code=comp_data['product'])
                uom_obj = UnitOfMeasure.objects.filter(abbreviation=comp_data['uom'])[0]
                
                BOMComponent.objects.get_or_create(
                    bom=bom,
                    product=comp_product,
                    defaults={
                        'quantity': comp_data['quantity'],
                        'uom': uom_obj
                    }
                )
            
            boms.append(bom)
        
        return boms

    def create_work_centers(self):
        work_centers_data = [
            {'name': 'مونتاژ نهایی', 'code': 'WC-001', 'capacity_per_hour': 20},
            {'name': 'تست کیفیت', 'code': 'WC-002', 'capacity_per_hour': 30},
            {'name': 'بسته‌بندی', 'code': 'WC-003', 'capacity_per_hour': 50},
            {'name': 'ماشین‌کاری', 'code': 'WC-004', 'capacity_per_hour': 15},
        ]
        
        work_centers = []
        for data in work_centers_data:
            wc, created = WorkCenter.objects.get_or_create(**data)
            work_centers.append(wc)
        
        return work_centers

    def create_work_order_templates(self, boms):
        templates_data = [
            {'name': 'تمپلیت تولید پنکه', 'code': 'TEMP-001', 'bom': 'BOM-001'},
            {'name': 'تمپلیت تولید کنترلر', 'code': 'TEMP-002', 'bom': 'BOM-002'},
        ]
        
        templates = []
        for data in templates_data:
            bom = BillOfMaterials.objects.get(reference=data['bom'])
            template, created = WorkOrderTemplate.objects.get_or_create(
                code=data['code'],
                defaults={
                    'name': data['name'],
                    'bom': bom
                }
            )
            templates.append(template)
        
        return templates

    def create_operations(self, templates, work_centers):
        operations_data = [
            {
                'template': 'TEMP-001',
                'operations': [
                    {'sequence': 1, 'name': 'مونتاژ بدنه', 'work_center': 'WC-001', 'duration': 2.0},
                    {'sequence': 2, 'name': 'نصب موتور', 'work_center': 'WC-001', 'duration': 1.5},
                    {'sequence': 3, 'name': 'تست عملکرد', 'work_center': 'WC-002', 'duration': 0.5},
                    {'sequence': 4, 'name': 'بسته‌بندی', 'work_center': 'WC-003', 'duration': 0.5},
                ]
            },
            {
                'template': 'TEMP-002',
                'operations': [
                    {'sequence': 1, 'name': 'مونتاژ برد', 'work_center': 'WC-001', 'duration': 1.5},
                    {'sequence': 2, 'name': 'نصب سنسورها', 'work_center': 'WC-001', 'duration': 1.0},
                    {'sequence': 3, 'name': 'کالیبراسیون', 'work_center': 'WC-002', 'duration': 1.0},
                    {'sequence': 4, 'name': 'بسته‌بندی', 'work_center': 'WC-003', 'duration': 0.3},
                ]
            },
        ]
        
        operations = []
        for template_data in operations_data:
            template = WorkOrderTemplate.objects.get(code=template_data['template'])
            
            for op_data in template_data['operations']:
                work_center = WorkCenter.objects.get(code=op_data['work_center'])
                
                operation, created = Operation.objects.get_or_create(
                    work_order_template=template,
                    sequence=op_data['sequence'],
                    defaults={
                        'work_center': work_center,
                        'name': op_data['name'],
                        'duration': op_data['duration'],
                        'instructions': f'دستورالعمل برای {op_data["name"]}'
                    }
                )
                operations.append(operation)
        
        return operations

    def create_manufacturing_orders(self, products, boms, templates, users):
        mo_data = [
            {
                'reference': 'MO-2024-001',
                'product': 'FG-001',
                'bom': 'BOM-001',
                'template': 'TEMP-001',
                'quantity': 100,
                'status': 'confirmed',
                'days_from_now': 5
            },
            {
                'reference': 'MO-2024-002',
                'product': 'FG-002',
                'bom': 'BOM-002',
                'template': 'TEMP-002',
                'quantity': 50,
                'status': 'in_progress',
                'days_from_now': -2
            },
            {
                'reference': 'MO-2024-003',
                'product': 'FG-001',
                'bom': 'BOM-001',
                'template': 'TEMP-001',
                'quantity': 200,
                'status': 'draft',
                'days_from_now': 10
            },
        ]
        
        manufacturing_orders = []
        for data in mo_data:
            product = Product.objects.get(code=data['product'])
            bom = BillOfMaterials.objects.get(reference=data['bom'])
            template = WorkOrderTemplate.objects.get(code=data['template'])
            
            scheduled_date = datetime.now() + timedelta(days=data['days_from_now'])
            
            mo, created = ManufacturingOrder.objects.get_or_create(
                reference=data['reference'],
                defaults={
                    'product_to_manufacture': product,
                    'quantity_to_produce': data['quantity'],
                    'bom': bom,
                    'work_order_template': template,
                    'status': data['status'],
                    'scheduled_date': scheduled_date,
                    'responsible': users.SysUser if users else None,  # ناظر تولید
                    'notes': f'یادداشت برای {data["reference"]}'
                }
            )
            
            # تولید Work Orderها
            if created and data['status'] != 'draft':
                mo.generate_work_orders()
            
            manufacturing_orders.append(mo)
        
        return manufacturing_orders