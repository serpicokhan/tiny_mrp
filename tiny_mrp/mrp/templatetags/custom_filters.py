from django import template

register = template.Library()

@register.filter
def get_item(dictionary, key):
    return dictionary.get(key, None)
@register.filter(name='get_item_from_shift')
def get_item_from_shift(value, shift_id):
    for item in value:
        if item.get('shift') == shift_id:
            return item.get('vazn')
    return ''  # or some default value
