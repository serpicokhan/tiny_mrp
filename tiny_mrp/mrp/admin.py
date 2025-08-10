from django.contrib import admin
from mrp.models import *
admin.site.register(Zayeat)
admin.site.register(ZayeatVaz)
admin.site.register(Asset)
admin.site.register(Failure)
admin.site.register(AssetFailure)
admin.site.register(SysUser)
admin.site.register(Comment)
class OperatorAdmin(admin.ModelAdmin):
    # Fields to display in the list view
    list_display = ('Pid', 'PNumber', 'CpCode', 'CardNo', 'FName', 'LName')
    
    # Fields to enable searching
    search_fields = ('Pid', 'PNumber', 'CpCode', 'CardNo', 'FName', 'LName')
    
    # Optional: Add filters
    list_filter = ('CpCode',)
    
    # Optional: Make fields editable directly from the list view
    list_editable = ('PNumber', 'CpCode')
    
    # Optional: Add fields to group them in the edit view
    fieldsets = [
        ('Personal Information', {
            'fields': ('FName', 'LName')
        }),
        ('Professional Information', {
            'fields': ('Pid', 'PNumber', 'CpCode', 'CardNo')
        }),
    ]

# Register your models here.
admin.site.register(Operator, OperatorAdmin)
@admin.register(Color)
class ColorAdmin(admin.ModelAdmin):
    # For the Color model
    list_display = ('id', 'name')  # Fields to display in list view
    search_fields = ('name',)      # Fields to search by
    ordering = ('name',)           # Default ordering

@admin.register(EntryForm)
class EntryFormAdmin(admin.ModelAdmin):
    # For the EntryForm model
    list_display = ('name', 'color', 'tool', 'la', 'display_info')
    search_fields = ('name', 'color__name', 'tool', 'la')  # Search by name, color name, tool, or la
    list_filter = ('color',)       # Filter by color
    ordering = ('name',)           # Default ordering
    
    def display_info(self, obj):
        return f"{obj.tool}/{obj.la}"
    display_info.short_description = 'Tool/LA'  # Sets column header
