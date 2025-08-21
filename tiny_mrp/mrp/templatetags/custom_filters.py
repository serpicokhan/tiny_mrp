from django import template
from datetime import datetime
from django.contrib.auth.models import User

import jdatetime
register = template.Library()

@register.filter
def get_item(dictionary, key):
    return dictionary.get(key, None)
@register.filter
def get_sum_item(dictionary):
    return sum(dictionary.values())
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
@register.filter
def in_group(user, group_name):
    """Check if the user belongs to a specific group."""
    return user.groups.filter(name=group_name).exists()
@register.filter
def has_comment_by_user(purchase_request, user):
    """
    Check if the given user has commented on the purchase request.
    """
    # return purchase_request.notes.filter(user=user).exists()
     # First get the group(s) the user belongs to
    user_groups = user.userId.groups.all()
    
    # Get all users in the same group(s)
    group_users = User.objects.filter(groups__in=user_groups).distinct()
    
    # Get all notes from these users on the purchase request
    group_notes = purchase_request.notes.filter(user__userId__in=group_users)
    
    return group_notes.exists()
@register.filter
def get_comment_by_user(purchase_request, user):
    """
    Check if the given user has commented on the purchase request.
    """
    # if(purchase_request.notes.filter(user=user).count()>0):
    #     return purchase_request.notes.filter(user=user)[0].content
    # return None
    user_groups = user.userId.groups.all()
    
    # Get all users in the same group(s)
    group_users = User.objects.filter(groups__in=user_groups).distinct()

    
    # Get all notes from these users on the purchase request
    group_notes = purchase_request.notes.filter(user__userId__in=group_users)[0].content
    print(group_notes)
    return group_notes
@register.filter(name='to_jalali')
def to_jalali(value, format='%Y-%m-%d'):
    """
    Convert a Gregorian date to Jalali date.
    
    Args:
        value: A datetime object or string representing a Gregorian date.
        format: The desired output format (default: 'YYYY/MM/DD').
    
    Returns:
        A string representing the date in Jalali format.
    """
    # Handle case where value is None or invalid
    if not value:
        return ''
    
    # If value is a string, parse it to a datetime object
    if isinstance(value, str):
        try:
            value = datetime.strptime(value, '%Y-%m-%d')  # Adjust format if your input differs
        except ValueError:
            return value  # Return original value if parsing fails
    
    # Ensure value is a datetime object
    if not isinstance(value, datetime):
        return value
    
    # Convert Gregorian to Jalali
    jalali_date = jdatetime.date.fromgregorian(date=value)
    
    # Return formatted Jalali date
    return jalali_date.strftime(format)
@register.filter
def sum_production(machines):
    """Calculate total production for a list of machines"""
    total = 0
    for machine in machines:
        
        try:
            # Access the production value
            amar= machine.amar
            print(amar)
            for i in amar:
                prod_value+=i.production_value

            print('!!!',prod_value)
            if prod_value is not None:
                total += float(prod_value)
        except (AttributeError, ValueError, TypeError):
            
            continue
    print(total)
    return total

@register.filter
def sum_wastage(machines):
    """Calculate total wastage for a list of machines"""
    total = 0
    for machine in machines:
        try:
            # Access the wastage value
            waste_value = machine.amar.wastage_value
            if waste_value is not None:
                total += float(waste_value)
        except (AttributeError, ValueError, TypeError):
            continue
    return total