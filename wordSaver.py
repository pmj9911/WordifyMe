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

option = int(input("enter option: \n1. Enter new words.\n2. Revise\n3. View words\n:"))
file = open("wordsList.txt","a+")
if option == 1:
	InputWords(file)
elif option == 2:
	Revise(file)
elif option == 3:
	WordList(file)
file.close()