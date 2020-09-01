#!/usr/bin/julia


#NOOOOT DONE!!!


####Exercise 1

#a) For finding the variant and gene mutation, the first word should be FT 
# The next should be either VARIANT or MUTAGEN. 
#Thereafter are the placement named, note that some of those also are identical. The next lines are removed since those are just informations (i presume)


#b) Pseudocode 

#for line in file
#if line starts with "FTs+ (MUTAGEN||VARIANT)" save line .

#If line start with SQ, save the sequence until line startswith "//"


#d) Errrorcheking of if threre is any, check if non aa is written, check if there is different mutation on the same positition, check if the position even exisst, if there is the same number of AA as there is stated. 

#e) could 


#The code from part c. 

function read_file(filename::String,outname::String)
	#Read file and get the name and sequence 

	infile = open(filename,"r")
	outfile = open(outname,"w")

	sequnceflag = false
	sequence = ""

	#MUTATIONS SHOULD BE MADE IT ITS OWN TYPE!!! 
	mutations = ""

	for line in eachline(infile)
		line = split(line)

		#Get the information to header,
		if line[1] == "ID"
			print(outfile,"> $(join(line[2:end]," "))")
		elseif line[1] =="AC"
			println(outfile,join(line[2:end]," "))
		end 

		#Get the sequence 
		if line[1] == "//"
			sequnceflag = false
		elseif sequnceflag 
			sequence *= join(line)
		elseif line[1] =="SQ"
			sequnceflag = true 
		end


		#Get the mutations 
		if line[1] == "FT"
			
			
			if line[2] == VARIANT
				mutations 

			elseif line[2] =="MUTAGEN"

			end 
		end


	end 



	println(sequence)
	close(infile)
	close(outfile)

end


read_file("appendix1.txt","appendix1out.fsa")


##not done either
####Exercise 2

#Appendix5 is the translation file
#Appendix4 is the blacklist
#Appendix3 is the information 

#Pseucode 
#For line in appendix5, save in dict with key and value as the translation 

#For line in appendix4, translate it into swiss, according to the dict, save it in a set (could also be a list and then found by binary search)

#For line in appendix 3, if key not in set, calculate the mean and save it in dict 


#c) Assumed that all infromation is contained in the translation list, assumed that the order of the files are build the same way always, it does not exeed memory, that there are at least two results for finding top and bottom. 

#d) That there are atleast 10 of each should be considered, 


#ACCUTAL CODE 


blaa 

