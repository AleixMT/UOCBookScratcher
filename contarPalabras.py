#!/usr/bin/python3
# -*- coding: utf-8 -*-
import codecs
import os
import subprocess
import sys

if __name__ == "__main__":

    def mapFunctionWC(texto):
        # remove leading and trailing whitespace
        # line = v.strip() Aquesta linia es reundant si fem word.strip() a cada paraula
        # split the line into words
        result = {}
        texto = texto.translate(["-?.!,;:()\""]).lower()  # deleting trash characters

        for line in texto.split("\n"):
            for word in line.strip().split():
                if word in result:
                    print(word)
                    result[word] = result.get(word) + 1
                else:
                    print(word)
                    result[word] = 1
        return result

    #text = os.system("pdfgrep . books/Accesibilidad\\ PID_00253481.pdf > tmp")
    text = subprocess.check_output("pdfgrep . books/Control_presupuestario_y_de_gestión_PID_00256843.pdf", shell=True)
    text = text.decode(encoding='UTF-8')
    #print(text)
    dictio = mapFunctionWC(text)
    lista = []

    for key, value in dictio.items():
        lista.append([key, value])

    lista_ordenada = []

    while lista:
        maxim = 0
        posMaxim = 0
        for pos in range(len(lista)):
            if lista[pos][1] > maxim:
                maxim = lista[pos][1]
                posMaxim = pos

        if len(lista[posMaxim][0]) > 4:
            lista_ordenada.append(lista[posMaxim])
            lista.pop(posMaxim)
        else:
            lista.pop(posMaxim)


    print(lista_ordenada)