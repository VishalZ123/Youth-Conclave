from dataclasses import dataclass
from urllib import response
from django.shortcuts import render
from django.http import HttpResponse
import pyrebase
import pyqrcode
import png
import json
import os
from uuid import uuid4
from rest_framework.status import HTTP_200_OK

config = {
    "apiKey": "AIzaSyAvoPLd4_KG7BDTVMD8IwkNAshLXhHNDhE",
    "authDomain": "youth-conclave.firebaseapp.com",
    "databaseURL": "https://youth-conclave-default-rtdb.firebaseio.com/",
    "projectId": "youth-conclave",
    "storageBucket": "youth-conclave.appspot.com",
    "messagingSenderId": "412881327801",
    "appId": "1:412881327801:web:d006185b5b25e367db6d68",
    "measurementId": "G-TTD5RBE176",
}
path = './assets/'
firebase = pyrebase.initialize_app(config)
storage = firebase.storage()
database = firebase.database()
# Create your views here.


def getStart(email):
    '''
    removes the . and @ from the email address for the use of emails as keys
    '''
    s = ''
    for l in email:
        if l != '.' and l != '@':
            s += l
    return s


def generate_qr(request):
    body_unicode = request.body.decode('utf-8')
    body = json.loads(body_unicode)
    emailList = body['emails']

    for email in emailList:
        # generate QR using email
        unique_id = str(uuid4())
        data = '{"email":"'+email+'", "uuid":"'+unique_id+'"}'
        url = pyqrcode.create(data)
        filename = "qr"+getStart(email)+".png"
        url.png(path+filename, scale=6)

        # upload image to firebase
        storage.child("qr_images/"+email+".png").put(path+filename)
        url = storage.child("qr_images/"+email+".png").get_url(token=None)
        os.remove(path+filename)

        all = database.child('People')
        all.child(getStart(email)).set(
            {"email": email, "present": False, "url": url, "uuid":unique_id})
        print("generated for "+email+"\n")
    return HttpResponse("QR generated for all")


def entry(request):
    email = request.headers.get("email")
    uuid = request.headers.get("uuid")
    
    stored_uuid = database.child('People').child(getStart(email)).child('uuid').get().val()
    if(uuid==stored_uuid):
        print(getStart(email),'\n')
        is_pr = database.child('People').child(getStart(email)).child('present').get().val()
        print('present status=', is_pr)
        if(is_pr):
            response = True
        else:
            response = False
            database.child('People').child(getStart(email)).update({"present":True})
    else:
        response = 'Invalid QR'
    return HttpResponse(response, status=HTTP_200_OK)

def exit(request):
    email = request.headers.get("email")
    uuid = request.headers.get("uuid")
    
    stored_uuid = database.child('People').child(getStart(email)).child('uuid').get().val()
    print(uuid==stored_uuid)
    if(uuid==stored_uuid):
        database.child('People').child(getStart(email)).update({"present":False})
        response='exited'
    else:
        response = 'Invalid QR'
    return HttpResponse(response, status=HTTP_200_OK)
