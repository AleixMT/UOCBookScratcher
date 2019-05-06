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
# Files will be saved in the folder "books", created in the same location as this script. In this 	#
# location, you can also find the file "dades.txt", which contains the last id link number consulted. 	#
# The script will start downloading from this number. You can modify this value in "dades.txt" with a 	#
# number within 1 to 9999999. The file "links.txt" contains all links consulted pointing to valid files.#
# Keep this file for future references.									#
#													#
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
if [ ! -d books ]; then
	mkdir books 	# Creates "books" folder, if already exists an error will be shown, but execution will continue
fi
cd books	# Enter in "books" folder

if [ -f links.txt ]	# If file "dades.txt" exists, (this is not the first execution) we need to continue from the last link we generated so...
then
	sufijo=$(tail -1 links.txt | grep -Eo "[0-9]*")	# ... we capture last line from dades.txt (which contains the last id number consulted) and keep it in var.
	sufijo=$((sufijo+1))
	state=$(tail -1 links.txt | grep $prefijof | wc -w)
	if [ $state = 0 ]
	then 
		num=0
	else
		num=$(cat links.txt | wc -l)
	fi

else			# if doesn't exist generate a new one
	sufijo=0		# initialize sufijo var with a 0 (first id link).
	num=0
	state=0

fi 

if [ $state = 1 ]
then
	while [ $sufijo -lt 9999999 ]; do	# While var sufijo is less than 9999999 do following instructions:
		echo "· $num llibres trobats de $sufijo links revisats"	# Print the link number on screen
		link=$prefijo$sufijo		# link = prefijo+sufijo. Generate a new link adding prefijo and sufijo
		wget -q 2>&1 $link
	# Download the file pointed by the link contained in variable link. Redirect stderr to stdout (2>&1) | Keep only the line that contains the size of the file | Cut it for keeping just the number containing the size of the downloaded file. Keep this number in var. content.
		if [ ! -s $prefijof$sufijo ]	# if content (size of the downloaded file) is 0 (we have just downloaded an empty file)
		then
			rm $prefijof$sufijo			# Remove this file
		else			# Otherwise, if content is different from 0 (valid file).
			num=$((num+1))
			echo $link >> links.txt	# keep the link in the links.txt folder.
			mv $prefijof$sufijo $(pdfgrep . $prefijof$sufijo | head -15 | tr -s '\n' | head -5 | tr '\n' ' ' | tr -s ' ' '_')
		fi
		sufijo=$((sufijo+1))
	done
else
	while [ $sufijo -lt 9999999 ]; do	# While var sufijo is less than 9999999 do following instructions:
		echo "· $num llibres trobats de $sufijo links revisats"	# Print the link number on screen
		link=$prefijo$sufijo		# link = prefijo+sufijo. Generate a new link adding prefijo and sufijo
		wget -q 2>&1 $link 
	# Download the file pointed by the link contained in variable link. Redirect stderr to stdout (2>&1) | Keep only the line that contains the size of the file | Cut it for keeping just the number containing the size of the downloaded file. Keep this number in var. content.
		if [ ! -s $prefijof$sufijo ]	# if content (size of the downloaded file) is 0 (we have just downloaded an empty file)
		then
			rm $prefijof$sufijo			# Remove this file
			if [ $state = 0 ]
			then
				echo $sufijo > links.txt
			fi
		else			# Otherwise, if content is different from 0 (valid file).
			num=$((num+1))
			echo $link >> links.txt	# keep the link in the links.txt folder.
			mv $prefijof$sufijo $(pdfgrep . $prefijof$sufijo | head -15 | tr -s '\n' | head -3)
			state=1

		fi
		sufijo=$((sufijo+1))
	done
fi



#http://cvapp.uoc.edu/autors/MostraPDFMaterialAction.do?id=151860"

