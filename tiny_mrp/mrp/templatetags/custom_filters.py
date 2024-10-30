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
@register.filter(name='get_rank')
def get_rank(dictionary, current_key):
    rank=['اول','دوم','سوم']
    # Sort the dictionary by value in descending order and get the keys
    sorted_keys = sorted(dictionary, key=dictionary.get, reverse=True)
    # Find the rank of the current item based on its position in sorted keys
    return rank[sorted_keys.index(current_key)]  # Adding 1 to start rank at 1 instead of 0
@register.filter
def sum_vazn_for_shift(zayeat_vazn_dict, shift_id):
    total_vazn = 0
    for zayeat_id, entries in zayeat_vazn_dict.items():
        for entry in entries:
            if entry['shift'] == shift_id:
                total_vazn += entry['vazn']
    return round(total_vazn,2)