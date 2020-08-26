#!/usr/bin/julia


#1) Create a codon list in a dict

function initilize_dict()
	CODON = Dict(
	    "CTT"=>"L","CTC"=>"L","CTA"=>"L","CTG"=>"L","TTA"=>"L","TTG"=>"L", 
	    "ATT"=>"I","ATC"=>"I","ATA"=>"I",                                   
	    "GTT"=>"V","GTC"=>"V","GTA"=>"V","GTG"=>"V",                       
	    "TTT"=>"F","TTC"=>"F",					     
	    "ATG"=>"M",	  						     
	    "TGT"=>"C","TGC"=>"C",					     
	    "GCT"=>"A","GCC"=>"A","GCA"=>"A","GCG"=>"A",			     
	    "GGT"=>"G","GGC"=>"G","GGA"=>"G","GGG"=>"G",			     
	    "CCT"=>"P","CCC"=>"P","CCA"=>"P","CCG"=>"P",			
	    "ACT"=>"T","ACC"=>"T","ACA"=>"T","ACG"=>"T",			    
	    "TCT"=>"S","TCC"=>"S","TCA"=>"S","TCG"=>"S","AGT"=>"S","AGC"=>"S", 
	    "TAT"=>"Y","TAC"=>"Y",					   
	    "TGG"=>"W",							  
	    "CAA"=>"Q","CAG"=>"Q",					
	    "AAT"=>"N","AAC"=>"N",					
	    "CAT"=>"H","CAC"=>"H",					 
	    "GAA"=>"E","GAG"=>"E",				
	    "GAT"=>"D","GAC"=>"D",					    
	    "AAA"=>"K","AAG"=>"K",					    
	    "CGT"=>"R","CGC"=>"R","CGA"=>"R","CGG"=>"R","AGA"=>"R","AGG"=>"R", 
	    "TAA"=>"STOP","TAG"=>"STOP","TGA"=>"STOP"	               
	     )
end



#Test of it works, it does
CODON = initilize_dict()
println(get(CODON,"TAA",3))




#2) Translate dna7.fsa into aa7.fsa

function check_inputfile(filename::String)
	#Check and open file,
	#The input could also be from the ARGS

	try 
		infile = open(filename,"r")
	catch 
		println("File does not exisist, Exit")
		exit()
	end 
end


function check_outfile(filename::String)
	#Check and open file,
	#The input could also be from the ARGS


	if isfile(filename)
		#Be sure not to overwrite something
		outfile = open(filename,"a")
	else 
		#Create file if non existens 
		outfile = open(filename,"w")
 	end 

end



function translate_aa(infile, outfile, codon::Dict, sequence)
	#Input is file name for in and outfile
	#codon is the translatation dict
	#line is the line there are suppoes to be translate, note that:
	
	#Since each full line in the sequence is 60 characters long, this works. 
	#Since the last line in each sequence is a part of the 3 table, (All those i checked) i will assume this method is fine

	sequence = join(sequence)

	if get(codon,sequence[end-2:end],3) != "STOP"
		println("A sequence did not end with a stop, exit") 
		close(infile)
		exit()
	end 

	len = length(sequence)-3
	count = 0

	for i in 1:3:len
		newlineflag = true 
		global newlineflag

		print(outfile,get(codon,sequence[i:i+2],3))
		
		count += 1 
		#Make sure there is no aa seq above 60
		if count == 60 

			print(outfile,"\n")
			count = 0 
			#It is possible that there 60 charaters in the last line, therefor are we using a flag for not inserting double newline
			newlineflag = false
		end 

	end

	#Newline for next sequence or the end 
	if newlineflag != true 
		print(outfile,"\n")
	end

end


###ACCUTAL PROGRAM 

#The filename

#input = ARGS[1]
input1 = "dna7.fsa"
infile = check_inputfile(input1)

#input2 = ARGS[2]
input2 = "aa7.fsa"
outfile = check_outfile(input2)

codon =  initilize_dict()


#Get the first line
println(outfile,readline(infile)*"Amino Acid Sequence")
sequence = []
for line in eachline(infile)
	global infile, outfile, codon, sequence 
	if match(r"^>\w+", line) != nothing
		
		translate_aa(infile, outfile, codon::Dict, sequence)
		println(outfile,"\n"*line*"Amino Acid Sequence")

		sequence = []
	else
		#Might not the most efficent way to read the sequence twice, 
		#But in terms of code length and if statements for newliners, flag and so on is the the shortest. 

		append!(sequence, line)

	end 
end


close(infile)
close(outfile)


#3) se difference in two sets

#read files

#For line in file1
	#Save accessionnumber to set

	#read line in file2
	#Save accessionnumber in another set
#End 

#Use the opposet of intersect (setdiff)
#Closefile 


function check_inputfile(filename::String)
	#Check and open file,
	#The input could also be from the ARGS

	try 
		infile = open(filename,"r")
	catch 
		println("File does not exisist, Exit")
		exit()
	end 
end

function set_difference(set1,set2,input1,input2)
	#Check the difference between two sets, and print which numbers are not in the other. 

	infile2_set = set2
	infile1_set = set1
	#Check if there are any in the first file, which are not in the second. 
	difference = setdiff(infile_set,infile2_set)
	firstdiff = intersect(difference,infile_set)


	if length(firstdiff)!= 0 
		println("The followin accession numbers can only be found in your $input1")
		for item in firstdiff
			println(item)
		end 
	else 
		println("All accesion numbers in $input1, is also in $input2 ")
	end
end


###ACCUTAL PROGRAM 

#The filename

#input = ARGS[1]
input1 = "start10.dat"
infile = check_inputfile(input1)

#input2 = ARGS[2]
input2 = "res10.dat"
infile2 = check_inputfile(input2)


#make set
infile_set = Set()
infile2_set = Set()


for line in eachline(infile)
	
	push!(infile_set,line)

	#Because the res is slighly differ,this onlyworks for that order
	line = split(readline(infile2),"\t")

	#because the file end with a newline
	if length(line)>1
		push!(infile2_set,line[2])
	end 
end

#Check difference between the two files
#Use the function twice, but opposite for save space
set_difference(infile_set,infile2_set,input1,input2)
set_difference(infile2_set,infile_set,input2,input1)

close(infile)
close(infile2)


#4) check multiple occurencs 
#read files

#For line in file1
	#Save accessionnumber to dict, where value is the number

	#if accessionnumber already in dict, up the value 

#End 

#Print items in dict 

#Closefile 


function check_inputfile(filename::String)
	#Check and open file,
	#The input could also be from the ARGS

	try 
		infile = open(filename,"r")
	catch 
		println("File does not exisist, Exit")
		exit()
	end 
end

function sort_and_print_dict(dictname::Dict)
	#sort and print the dict by value
	#input:
	#dict 

	dictname = sort(collect(dictname), by = x -> x[2],rev=true)
	x = map(x -> x[1], dictname)
	y = map(x -> x[2], dictname)

	for i in 1:length(x)
		println(x[i],"\t",y[i])
	end
end 


###ACCUTAL PROGRAM 

#The filename

#input = ARGS[1]
input1 = "ex5.acc"
infile = check_inputfile(input1)


accesiondict = Dict()

#Save each number to dict 
for line in eachline(infile)
	if haskey(accesiondict,line) != true 
		get!(accesiondict,line,1)
	else
		accesiondict[line]+=1
	end
end

sort_and_print_dict(accesiondict)

close(infile)

#5) #First part copied directly from 7.9 
#The new part is marked down below 

function check_inputfile(filename::String)
	#Check and open file,
	#The input could also be from the ARGS

	try 
		infile = open(filename,"r")
	catch 
		println("File does not exisist, Exit")
		exit()
	end 
end

function translate_identifier(input)
	global translationflag 
	#For exercise 8

	#Print the translation, but never the first line. 
	if translationflag == true
		m = match(r"\w+", input)
		print(m.match)
	end 

	#Catch the first one, where it starts and print. 
	if translationflag != true &&  match(r"^\s+/translation", input) != nothing 
		print("The translation is: ")
		print(split(input,"\"")[2])
		translationflag = true
	end 

	#check if the translation end, this is done by a search after:" since the next section (For data1.gb is it sig_peptide, but for data2.gb is it another) change between difference documents
	if translationflag == true && match(r"\w+\"$", input) !=nothing 

		translationflag = false
		print("\n")

	end 
end

#The filename
#input = ARGS[1]
input1 = "data4.gb"

infile = check_inputfile(input1)

medlineflag,translationflag,dnaflag = false, false, false 
dnaseq,intron,exon = "","",""
for line in eachline(infile)
	global dnaflag, dnaseq, exon, intron

	translate_identifier(line)

	#Save the DNA sequence 
	if dnaflag ==true 
		if line[1:2]=="//"
			dnaflag = false
		else
			#If exercise 8, print DNA seq 
			m = match(r"^\s+\d+\s+([atcgATCG ]+)", line)
			println(join(split(m[1]," ")))

			dnaseq *= join(split(m[1]," "))

		end
	end

	#Check for DNA Sequence
	if  match(r"^ORIGIN", line) != nothing
		
		dnaflag=true
		println("The DNA sequence is:")
	end 


	#Find the exons and introns for exercise 9 
	if  match(r"^\s+exon\s+\w+", line) != nothing
		m = match(r"\d+..\d+", line)
		exon *=m.match*" " 
	end

end

######################################
######################################
######################################

###Get the exon part 
function get_exon(sequence,exon)
	#Function for printing the exon in exercise 9
	#input, both string
	#Exon have the format [start]..[end]\s[start]..[end] of each exon
	#output is print a list of all exons
	outexon = []

	exonsplit = split(exon[1:end]," ")[1:(end-1)]

	for item in exonsplit
		item = split(item,"..")

		first = parse(Int,item[1])
		last = parse(Int,item[2])

		push!(outexon,sequence[first:last])
	end
	return outexon
end

function sort_and_print_dict(dictname::Dict)
	#sort and print the dict by value
	#input:
	#dict 

	dictname = sort(collect(dictname), by = x -> x[2],rev=true)
	x = map(x -> x[1], dictname)
	y = map(x -> x[2], dictname)

	for i in 1:length(x)
		println(x[i],"\t",y[i])
	end
end 

##ACCUTAL PROGRMAm TWO 

listexon=join(get_exon(dnaseq,exon))

#Print and count the number of times, this could be improved by write where it is from 
println("The number of time each AA is in the exon: \n ")

exondict = Dict()

#Save each AA to dict 
for i in 1:3:length(listexon)
	line = listexon[i:i+2]

	if haskey(exondict,line) != true 
		get!(exondict,line,1)
	else
		exondict[line]+=1
	end
end 

sort_and_print_dict(exondict)

close(infile)



#6) reference managager
#First part copied directly from 7.9 
#The new part is marked down below 

function check_inputfile(filename::String)
	#Check and open file,
	#The input could also be from the ARGS

	try 
		infile = open(filename,"r")
	catch 
		println("File does not exisist, Exit")
		exit()
	end 
end


function get_authors(line,extralineflag)
	#Input:
	#Line, the line there shall be read
	#extralineflag: flag for if the authros are in more than one line

	#output, a list contaning: 
	#1: The authors 
	#2: The flag 

	#Check if the authors are placed at more than one line
	if extralineflag == true
	
		authors = line 

		if match(r"\s+and$", line) == nothing || match(r"\s+,$", line) != nothing
			extralineflag = false
		end 

	#If first time to meet the AUTHORS line
	else
		#for getting rid of AUTHORS
		if match(r"\s+and$", line) != nothing || match(r"\s+,$", line) != nothing
			extralineflag = true
			#For not getting "and"
			authors= join(split(line, " ")[4:(end-1)]," ")
		else 
			#if not and, show there is a new
			authors= join(split(line, " ")[4:end]," ")
			
		end
	end

	return authors,extralineflag
end


function get_authors(input::Array)
	#ALl of this filter back and forth is for handeling "Philips,J.A. III. and  Peter,S.""

	#First remove the AAUTHORS, which always are first therefor easy
	#I think there is an easier way, but this was the shortest I could with the setup
	input=split(join(input,", "))
	#Reomove the "and" and collect again
	input = replace(join(input, " "),"and "=>", ")
	input = split(input, ", ")


	#Get the dict 
	authordict = Dict()
	for item in input
		if haskey(authordict,item) != true 
			get!(authordict,item,1)
		else
			authordict[item]+=1
		end
	end
	return authordict
end


function sort_and_print_dict(dictname::Dict)
	#sort and print the dict by value
	#input:
	#dict 

	dictname = sort(collect(dictname), by = x -> x[2],rev=true)
	x = map(x -> x[1], dictname)
	y = map(x -> x[2], dictname)

	for i in 1:length(x)
		println(x[i],"\t",y[i])
	end
end 

##########Program 
#The filename
#input = ARGS[1]
input1 = "data1.gb"

infile = check_inputfile(input1)

authors = Dict()

extralineflag = false 

authors = []
for line in eachline(infile)
	global authors,extralineflag

	if match(r"^\s+AUTHORS", line) != nothing || extralineflag == true
		out = get_authors(line,extralineflag)
		push!(authors,out[1])
		extralineflag = out[2]
	end
end

authors = get_authors(authors)
sort_and_print_dict(authors)

close(infile)

