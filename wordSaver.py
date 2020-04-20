import requests

import random as rd
def breakLine():
	print("----------------------------------------")

def InputWords(file):
	word = "hello"
	while word != "exit":
		word = input("word: \t")
		if word != "exit":
			meaning = input("meaning: \t")
			print(word,meaning)
			file.write(word+" - "+meaning+"\n")
			breakLine()

def WordList(file):
	file.seek(0)
	lines = file.readlines()
	for i in range(len(lines)):
		temp = lines[i].split(' - ')
		word=temp[0]
		print(i+1,"\t",word)

def Revise(file):
	file.seek(0)
	lines = file.readlines()
	print(type(lines))
	rd.shuffle(lines)
	for i in range(len(lines)):
		temp = lines[i].split(' - ')
		word=temp[0]
		meaning=temp[1][:-1]
		print("word : ", word)
		meaningInput = input("enter the meaning : ")
		if meaningInput == meaning:
			print("Correct")
		else:
			print("Incorrect")
			print(word," : ",meaning)
		breakLine()

def Seperate():
	file.seek(0)
	lines = file.readlines()
	print(type(lines))
	for i in range(len(lines)):
		temp = lines[i].split(' - ')
		word=temp[0]
		meaning=temp[1]
		example=temp[2][:-1]
		print(word,meaning,example)
		file1.write(word+"\n")
		file2.write(meaning+"\n")
		file3.write(example+"\n")

url = 'http://pmj9911.pythonanywhere.com/media/wordsList.txt'
myfile = requests.get(url)
open('media/wordsList.txt', 'w+').write(myfile.content)

option = int(input("enter option: \n1. Enter new words.\n2. Revise\n3. View words\n4.seperate\n:"))

file = open("media/wordsList.txt","r")
file1 = open("word.txt","w+")
file2 = open("meaning.txt","w+")
file3 = open("example.txt","w+")

if option == 1:
	InputWords(file)
elif option == 2:
	Revise(file)
elif option == 3:
	WordList(file)
elif option == 4:
	Seperate()
file.close()
file1.close()
file2.close()
file3.close()