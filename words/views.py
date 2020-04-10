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
from django.conf import settings
from django.core.files import File
# Create your views here.
class addWord(APIView):
    parser_classes = (MultiPartParser,)

    def get(self,request):
        # todaydate = datetime.date.today()
        # print(todaydate)
        # file = open("../media/wordsList.txt","r")
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
        # with open(settings.MEDIA_ROOT+"/wordsList.txt","a+") as f:
        #     myfile = File(f)
        #     wordsList = WordDetail.objects.all()
        #     for i in range(len(wordsList)):
        #         myfile.write(wordsList[i].word+" - "+wordsList[i].meaning+" - "+wordsList[i].meaning + "\n")
        #     myfile.close()
        #     f.close()            
        # return Response({'wordsJson':"la"},content_type='application/json')
        return Response({'status':"get not allowed"},status=403)

    def post(self,request):
        try:
            word = request.POST.get('word')
            meaning = request.POST.get('meaning')
            date = request.POST.get('date')
            example = request.POST.get('example')
            wordsRow , created = WordDetail.objects.get_or_create(
                                        word=word,
                                        meaning=meaning,
                                        example=example,
                                        dateEntered=date)
            print (created)
            print("example saved")
            if created:
                with open(settings.MEDIA_ROOT+"/wordsList.txt","a+") as f:
                    myfile = File(f)
                    myfile.write(word+" - "+meaning+" - "+meaning + "\n")
                    print(myfile.closed)
                    myfile.close()
                    print(myfile.closed)
                    f.close()
            else:
               print(created)
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
            dateStart = request.POST.get('dateStart')
            dateEnd = request.POST.get('dateEnd')
            if dateEnd is not None:
                print("range of date")
                wordsList = WordDetail.objects.filter(dateEntered__range=[dateStart,dateEnd]).order_by("?")[:]
            else:
                wordsList = WordDetail.objects.filter(dateEntered=dateStart).order_by("?")[:]
            # wordsList = WordDetail.objects.all()
            wordsJson = wordsList.values()[:]
            print(wordsJson)
            # wordsJson = json.dumps(wordsList)
            return Response(wordsJson,content_type='application/json')
        except Exception as e:
            traceback.print_exc()
            print(e)
            return HttpResponse(status=403)
