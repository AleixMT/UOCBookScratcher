#!/usr/bin/python3
import os
import sys
import struct
from  googletrans import Translator
import csv

translator = Translator()
pathPrefix = "books_organized/unknown/"
folder = os.listdir(pathPrefix)

dicts = {}
trainingDataset = {}

for file in folder:
	file_pointer = open(pathPrefix + file)
	line = file_pointer.readline()
	keywords = line.replace('.', ',').split("{")[1].split("}")[0].split(",") #comentario
	for keyword in keywords:
		keyword = keyword.lstrip().rstrip().upper().swapcase()
		trainingDataset[keyword] = file

file_pointer = open("dictionary.csv", "w+")
for keyword, value in trainingDataset.items():
	file_pointer.write(keyword + "," + value + "\n")

print("DONE")

input()
langs = ["ES"]
for lang in langs:
	dictTemp = {}

	for keyword, value in trainingDataset.items():
		print(keyword + lang)
		translatedKeyword = translator.translate(text=keyword, dest=lang)
		print("Keyword " + keyword + " is translated in " + lang + " as " + translatedKeyword.text)
		dictTemp[translatedKeyword] = value
	dicts[lang] = dictTemp
dicts["EN"] = trainingDataset
langs.append("EN")

for lang in langs:
	file_pointer = open(lang + "_dictionary.csv", "w+")
	for keyword, value in dicts[lang].items():
		file_pointer.write(keyword + "," + value + "\n")
	#csv.DictWriter(