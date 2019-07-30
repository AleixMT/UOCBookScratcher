#!/bin/bash
#########################################################################################################
# Book stealer from UOC (Open University of Catalonia) v. 1.0.						#
# Author: Aleix Mariné (aleix.marine@estudiants.urv.cat).						#
#													#
# This script downloads all files pointed by a link from PDF and material section in UOC website. If	#
# the file is empty, the file generated will be erased; so, only valid files will be kept. This script 	#
# will go through all links with id from 1 to 9999999. This last number is arbitrary, so possibly more 	#
# files can be found beyond this number.								#
#													#
# Files will be saved in the folder "books", created in the same location as this script. In this 	    #
# location, you can also find the file "dades.txt", which contains the last id link number consulted. 	#
# The script will start downloading from this number. You can modify this value in "dades.txt" with a 	#
# number within 1 to 9999999. The file "links.txt" contains all links consulted pointing to valid files.#
# Keep this file for future references.									                                #
#													                                                    #
# For executing this file you need to give execution permission to this script. This can be done with 	#
# chmod utility in most unix system: Open a terminal in the ubication of this script and write:		#
# chmod 777 uocbookscratcher.sh										#
# 													#
# For executing the script open a console and set it in the ubication of this script (same as before)	#
# and write:												#
# ./uocbookscratcher.sh											#
#########################################################################################################
prefijof="MostraPDFMaterialAction.do?id="	# Initialize prefijof var. which contains the first part of the name of the downloaded files 	
prefijo="http://cvapp.uoc.edu/autors/MostraPDFMaterialAction.do?id="	# Initialize prefijo var, which contains the first part of the links

maxLinkNumber=$(($1+$2))
cd books	# Enter in "books" folder
for (( sufijo = $1; sufijo < maxLinkNumber; sufijo++ ))
do
    link=$prefijo$sufijo		# link = prefijo+sufijo. Generate a new link adding prefijo and sufijo
    size=$(wget --spider $link -O - 2>&1 | sed -ne '/Longitud/{s/.*: //;p}' | cut -d ' ' -f1)  #//HC
    if [ $size -eq 0 ]
    then
        continue
    fi
    wget -q $link

    # Download the file pointed by the link contained in variable link. Redirect stderr to stdout (2>&1) | Keep only the line that contains the size of the file | Cut it for keeping just the number containing the size of the downloaded file. Keep this number in var. content.
    echo $link >> ../links.txt	# keep the link in the links.txt folder.
    infollibre=$(pdfgrep . $prefijof$sufijo | tr -s '\n' | tr '\n' ' ' | grep -shoP "^.*?PID_[0-9]*" | tr -s ' ' | tr ' ' '_' | tr -d ",.'()[]{}")

    if [ -z "$infollibre" ]
    then
        echo "WARNING: Untitled book. Renaming... "
        infollibre=$sufijo
    elif [ ${#infollibre} -gt 251 ]
    then
        echo $infollibre
        echo "WARNING: Too large name. Resizing name..."
        infollibre=${infollibre:0:251}
        echo $infollibre
    fi

    infollibre=$infollibre.pdf

    echo -e "· BOOK FOUND! Title:"
    echo $infollibre
    mv "$prefijof$sufijo" "$infollibre"
done


#http://cvapp.uoc.edu/autors/MostraPDFMaterialAction.do?id=151860"

