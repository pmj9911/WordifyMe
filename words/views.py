from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser,JSONParser
from django.core.serializers.json import DjangoJSONEncoder
import json
import traceback
from .models import WordDetail
from django.http import HttpResponse
import random
import datetime
# Create your views here.
class addWord(APIView):
    parser_classes = (MultiPartParser,)

    def get(self,request):
        # todaydate = datetime.date.today()
        # print(todaydate)
        # file = open("/home/parthjardosh/GRE/WordifyMe/media/wordsList.txt","r")
        # lines = file.readlines()
        # for i in range(len(lines)):
        #     temp = lines[i].split(' - ')
        #     word = temp[0]
        #     meaning=temp[1][:-1]
        #     print(i+1,"\t",word)
        #     wordsrow , created = WordDetail.objects.get_or_create(
        #                                    word=word,
        #                                    meaning=meaning,
        #                                    dateEntered=todaydate)
        #     print(created)
        # file.close()
        # wordsList = WordDetail.objects.all()[:]
        # wordsJson = wordsList.values()[:]
        # return Response(wordsJson,content_type='application/json')
        return HttpResponse(status=403)

    def post(self,request):
        try:
            word = request.POST.get('word')
            meaning = request.POST.get('meaning')
            date = request.POST.get('date')
            wordsRow , created = WordDetail.objects.get_or_create(
                                        word=word,
                                        meaning=meaning)
            wordsRow.example = request.POST.get('example')
            print ("created")
            print("example saved")
            if created:
                wordsRow.dateEntered = date
                file = open("../media/wordsList.txt","a+")
                file.write(word+" - "+meaning+"\n")
                file.close()
            else:
                print(created)
            wordsRow.save()
            wordsList = WordDetail.objects.all()[:]
            wordsJson = wordsList.values()[:]
            return Response(wordsJson,content_type='application/json')
        except Exception as e:
            traceback.print_exc()
            print(e)
            return HttpResponse(status=403)
class viewWords(APIView):
    parser_classes = (MultiPartParser,)

    def get(self,request):
        try:
            # wordsList = sorted(WordDetail.objects.all().order_by('id')[:], key=lambda x: random.random())
            wordsList = WordDetail.objects.order_by("?")[:]
            # wordsList = WordDetail.objects.all()
            wordsJson = wordsList.values()[:]
            # wordsJson = json.dumps(wordsList)
            return Response(wordsJson,content_type='application/json')
        except Exception as e:
            traceback.print_exc()
            print(e)
            return HttpResponse(status=403)
    def post(self,request):
        try:
            date = request.POST.get('date')
            wordsList = WordDetail.objects.filter(dateEntered=date).order_by("?")[:]
            # wordsList = WordDetail.objects.all()
            wordsJson = wordsList.values()[:]
            print(wordsJson)
            # wordsJson = json.dumps(wordsList)
            return Response(wordsJson,content_type='application/json')
        except Exception as e:
            traceback.print_exc()
            print(e)
            return HttpResponse(status=403)