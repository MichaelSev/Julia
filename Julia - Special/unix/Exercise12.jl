#!/usr/bin/julia


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
			println(line)
		end


	end 



	println(sequence)
	close(infile)
	close(outfile)

end


read_file("appendix1.txt","appendix1out.fsa")

