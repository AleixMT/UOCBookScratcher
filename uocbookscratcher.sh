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
mkdir books  	# Creates "books" folder, if already exists an error will be shown, but execution will continue
cd books	# Enter in "books" folder
if [ -f dades.txt ]	# If file "dades.txt" exists, (this is not the first execution) we need to continue from the last link we generated so...
then
	sufijo=$(tail -1 dades.txt)	# ... we capture last line from dades.txt (which contains the last id number consulted) and keep it in var.
else			# if doesn't exist generate a new one
	echo 0 >dades.txt	# We create dades.txt with a 0 in it. 
	sufijo=0		# initialize sufijo var with a 0 (first id link).
fi 
while [ $sufijo -lt 9999999 ]; do	# While var sufijo is less than 9999999 do following instructions:
	echo "Link número $sufijo"	# Print the link number on screen
	num=$(ls -l | wc -l)		# Count how many lines (wc -l) are displayed by ls -l (show files in directory) and keep it in num.
	let num=$num-3			# Adjust num var, which contains now the number of books downloaded by the moment
	echo "$num llibres trobats"	# Print how many books we have found
	link=$prefijo$sufijo		# link = prefijo+sufijo. Generate a new link adding prefijo and sufijo
	content=$(wget 2>&1 $link | grep -o "Longitud:.*" | cut -d ' ' -f2) 
# Download the file pointed by the link contained in variable link. Redirect stderr to stdout (2>&1) | Keep only the line that contains the size of the file | Cut it for keeping just the number containing the size of the downloaded file. Keep this number in var. content.
	if [ $content = 0 ]	# if content (size of the downloaded file) is 0 (we have just downloaded an empty file)
	then
		f=$prefijof$sufijo	# Generate the name of the last downloaded file f = prefijo+sufijo
		rm $f			# Remove this file
	else			# Otherwise, if content is different from 0 (valid file).
		echo $link >> links.txt	# keep the link in the links.txt folder.
	fi
	echo $sufijo>dades.txt		# Save the last id number consulted in dades.txt
	let sufijo=$sufijo+1		# Add 1 to sufijo for consulting the next link
done

#http://cvapp.uoc.edu/autors/MostraPDFMaterialAction.do?id=151860"

