'''
 fmt = getattr(settings, 'LOG_FORMAT', None)
 lvl = getattr(settings, 'LOG_LEVEL', logging.DEBUG)

 logging.basicConfig(format=fmt, level=lvl)
 logging.debug(neuserbject.OrderId.id)
 '''
from django.shortcuts import render
from django.shortcuts import get_object_or_404
from django.http import JsonResponse
from django.template.loader import render_to_string
from django.db.models import Sum
import jdatetime
from django.http import HttpResponseRedirect
from django.http import HttpResponse
from django.views.decorators import csrf
import django.core.serializers
import logging
from django.conf import settings
from mrp.models.users import *
from django.views import View
import json
from django.forms.models import model_to_dict
from mrp.forms import SysUserForm
# from mrp.forms import SysUserImageForm
from django.urls import reverse_lazy
from django.db import transaction
from django.views.decorators.csrf import csrf_exempt
from mrp.business.userutility import *
from django.contrib.auth.decorators import login_required
from mrp.business.DateJob import *
from django.core.paginator  import *
from django.contrib.auth.models import User
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response

import json

#####################
#for generate random user fullName
#in time of form posting random generated username must be deleted
import hashlib
import random
##########################################################
@login_required
def list_user(request,id=None):
    books=[]
    userGroups=[]

    # if(request.user.username=="moein"):
    books = SysUser.objects.filter(userStatus=True)


    #paging

    users=UserUtility.doPaging(request,books)
    return render(request, 'mrp/users/userList.html', {'user': users,'section':'list_user'})

##########################################################
##########################################################
# نمای کاربر عادی و کاربر معمولی تفاوت داشته باشد
###############


@login_required
def save_user_form(request, form, template_name,id=None,NewUser=None):


    data = dict()
    if (request.method == 'POST'):
        if form.is_valid():

            # newUser=User.objects.get(id=form.instance.userId_id)
            # newUser.username=form.instance.title
            # if(form.instance.email):
            #     newUser.email=form.instance.email
            # newUser.set_password(form.instance.password)
            # newUser.save()
            if(NewUser):
                createDjangoUser(form.instance)
            else:
                #updated user
                newUser=User.objects.get(id=form.instance.userId_id)
                newUser.username=form.instance.title
                if(form.instance.email):
                    newUser.email=form.instance.email
                newUser.set_password(form.instance.password)
                newUser.save()


            form.save()
            data['form_is_valid'] = True
            books = SysUser.objects.filter(userStatus=True)
            page=request.GET.get('page',1)
            users=UserUtility.doPaging(request,books)
            data['html_user_list'] = render_to_string('mrp/users/partialUserList.html', {
                'user': users
            })
        else:
            data['form_is_valid'] = False
            print(form.errors)

    context = {'form': form,'lId':id}


    data['html_user_form'] = render_to_string(template_name, context, request=request)
    return JsonResponse(data)
##########################################################

@login_required
def user_delete(request, id):
    print("user 108: ",id)

    comp1 = get_object_or_404(SysUser,id=id)
    print("$$$$$$$$$$$$")
    print(comp1)
    data = dict()
    if (request.method == 'POST'):

        comp1.delete()
        data['form_is_valid'] = True  # This is just to play along with the existing code
        companies = SysUser.objects.filter(userStatus=True)
        page=request.GET.get('page',1)
        users=UserUtility.doPaging(request,companies)
        #Tasks.objects.filter(userId=id).update(userrkorder=id)
        data['html_user_list'] = render_to_string('mrp/users/partialUserList.html', {
            'user': users
        })
    else:
        context = {'user': comp1}
        data['html_user_form'] = render_to_string('mrp/users/partialUserDelete.html',
            context,
            request=request,
        )
    return JsonResponse(data)

##########################################################
@login_required
def user_create(request):
    if (request.method == 'POST'):
        form = SysUserForm(request.POST, files=request.FILES)
        return save_user_form(request, form, 'mrp/users/partialUserCreate.html',NewUser=True)
    else:
        # hashStr=hashlib.sha1(str(random.random()).encode('utf-8')).hexdigest()
        # user = User.objects.create_user(username=hashStr,
        #                          email='{}@test.com'.format(hashStr),
        #                          password='glass onion')
        # userInstance=SysUser.objects.create(userStatus=True,userId=user)
        form = SysUserForm()
        # form=SysUserForm()
        return save_user_form(request, form, 'mrp/users/partialUserCreate.html')
############# create django user object#############
def createDjangoUser(user):
    djangoUser = User.objects.create_user(username=user.title,
                           email=user.email,
                              password=user.password)
    user.userId=djangoUser




##########################################################
@login_required
def user_update(request, id):
    company= get_object_or_404(SysUser, id=id)

    if (request.method == 'POST'):
        print(request.FILES)
        form = SysUserForm(request.POST,request.FILES, instance=company)
    else:
        form = SysUserForm(instance=company)

    return save_user_form(request, form,'mrp/users/partialUserUpdate.html',id)
#############################################################
def changeUserStatus(request,UserId):
    try:
        if(UserId is not None):
            data=dict()
            targetUser=SysUser.objects.get(id=UserId)
            targetUser.userStatus=not targetUser.userStatus
            targetUser.save()

            return  JsonResponse(data)
    except:
        pass
#################################################
@login_required
def listUser(request,statusCode):
    try:
        print(statusCode)
        if(statusCode is not None):
            data=dict()

            if(statusCode=="0"):
                print("00")
                data['form_is_valid'] = True
                books = SysUser.objects.filter(userStatus=True)
                page=request.GET.get('page',1)
                users=UserUtility.doPaging(request,books)
                data['html_user_list'] = render_to_string('cmms/user/partialUserList.html', {
                    'user': users
                })
            elif(statusCode=="1"):
                data['form_is_valid'] = True
                books = SysUser.objects.all()
                page=request.GET.get('page',1)
                users=UserUtility.doPaging(request,books)
                data['html_user_list'] = render_to_string('cmms/user/partialUserList.html', {
                    'user': users
                })
            else:
                data['form_is_valid'] = True
                books = SysUser.objects.filter(userStatus=False)
                page=request.GET.get('page',1)
                users=UserUtility.doPaging(request,books)
                data['html_user_list'] = render_to_string('cmms/user/partialUserList.html', {
                    'user': users
                })

            return JsonResponse(data)


    except:
        pass
@login_required
def list_active_user(request):
    try:
        data=dict()

        data['form_is_valid'] = True
        books = SysUser.objects.filter(userStatus=True)
        page=request.GET.get('page',1)
        users=UserUtility.doPaging(request,books)
        data['html_user_list'] = render_to_string('cmms/user/partialUserList.html', {
            'user': users
        })
        data['html_user_paginator'] = render_to_string('cmms/user/partialUserPagination.html', {'user': users,'pageType':'list_active_user'})
        # print(data)
        return JsonResponse(data)
    except:
        pass
@login_required
def list_inactive_user(request):
    try:
        print("inactive")
        data=dict()
        data['form_is_valid'] = True
        books = SysUser.objects.filter(userStatus=False)
        page=request.GET.get('page',1)
        users=UserUtility.doPaging(request,books)
        data['html_user_list'] = render_to_string('cmms/user/partialUserList.html', {
            'user': users
        })
        data['html_user_paginator'] = render_to_string('cmms/user/partialUserPagination.html', {'user': users,'pageType':'list_inactive_user'})
        # print(data)
        return JsonResponse(data)
    except:
        pass
@login_required
def list_all_user(request):
    try:
        data=dict()

        data['form_is_valid'] = True
        books = SysUser.objects.all()
        page=request.GET.get('page',1)
        users=UserUtility.doPaging(request,books)
        data['html_user_list'] = render_to_string('cmms/user/partialUserList.html', {
            'user': users
        })
        # data['html_user_paginator'] = render_to_string('cmms/user/partialUserPagination.html', {'user': users,'pageType':'list_all_user'})

        return JsonResponse(data)
    except:
        pass
def getUserDashbordSum(request,id):
        data=dict()
    # try:
        # print("##############",WOUtility.getNumCompletedWoCurrentMonth(id)[0].k)
        #completed wo num
        data['user_wo_num_current_month']=WOUtility.getNumCompletedWoCurrentMonth(id)[0].k
        data['user_wo_num_current_year']=WOUtility.getNumCompletedWoCurrentYear(id)[0].k
        print(data['user_wo_num_current_month'])
        #All wo
        data['user_all_wo_num_current_month']=WOUtility.getAllWorkCountCurrentMonth(id)[0].k
        data['user_all_wo_num_current_year']=WOUtility.getAllWorkCountCurrentYear(id)[0].k
        #
        data['user_task_work_hour_year']=TaskUtility.getYearlyWorkHour(id)[0].k
        data['user_task_work_hour_month']=TaskUtility.getMonthlyWorkHour(id)[0].k
        data['user_wo_num_ontime_year']=WOUtility.getnOnTimeCompletedWOCurrentYear(id)[0].k
        data['user_wo_num_ontime_month']=WOUtility.getnOnTimeCompletedWOCurrentMonth(id)[0].k
        data['form_is_valid'] = True
        return JsonResponse(data)
    # except:
    #     return JsonResponse(data)
########################################
@csrf_exempt
def userCancel(request,id):
    data=dict()
    if(request.method=='POST'):

        tg=SysUser.objects.get(id=id)
        if(tg):
            if(not tg.fullName):
                tg.delete()
                data['form_is_valid'] = True  # This is just to play along with the existing code
                companies =  SysUser.objects.all()
                #Tasks.objects.filter(taskGroupId=id).update(taskGroup=id)
                data['html_user_list'] = render_to_string('cmms/user/partialUserList.html', {
                   'user': companies
                })

    return JsonResponse(data)
############
def searchUser(request,name):
    data=dict()
    name=name.replace('_','')
    user=[]
    if not name:
        user=SysUser.objects.filter(userStatus=True)
    else:
        user=SysUser.objects.filter(fullName__contains=name)
    user=SysUser.objects.filter(fullName__contains=name)
    data['html_user_list'] = render_to_string('cmms/user/partialUserList.html', {
       'user': user
    })
    return JsonResponse(data)
@api_view(['POST'])
def user_login(request):
    print(request.data.get('username'),"##################")
    user1=SysUser.objects.filter(fullName=request.data.get('username'),password=request.data.get('password'))
    if(user1):
        t=testuser(massage=request.data.get('username'))
        serializer = userSerializer(t)
        return JsonResponse(serializer.data)
    t=testuser(id=100,massage="321312321321")
    serializer = userSerializer(t)
    return JsonResponse(serializer.data)
#############################
@api_view(['GET'])
def user_collection(request):
    if request.method == 'GET':
        print("reached user")
        posts = SysUser.objects.all()
        serializer = UserSerializer(posts, many=True)

        return Response(serializer.data)
@api_view(['GET'])
def user_detail_collection(request,uname,passwd):

    if request.method == 'GET':
        posts = get_object_or_404(SysUser, title=uname,password=passwd)
        serializer = UserSerializer(posts)
        print(serializer.data)
        return Response(serializer.data)

@api_view(['POST'])
def save_user_token(request):
    # print(request.data['title'])
    # print(request.POST.get('title'))
    if(request.data['id']):
        id=int(request.data['id'])
        user_=SysUser.objects.get(pk=id)
        if(not user.token):
            user.token=request.data['title']
            user.save()
    return Response()
def load_org_chart(request):
    return render(request,"mrp/chart/index.html",{})
