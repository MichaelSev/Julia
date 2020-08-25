#!/usr/bin/julia
#This is similar too the one in exercise 7... IN general a lot is similar since I made it with functions already



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

function translation_table(char::Char)
	#Can translate a letter
	char = uppercase(char)
	if char == 'A'
		out =  "T"
	elseif char =='T'
		out = "A"
	elseif char =='C'
		out = "G"
	elseif char =='G'
		out = "C"
	else 
		print("Illegal char, exit")
		close(infile)
		exit()
	end 


	return out 
end

function reverse_complement_seq(seq::Array,outfile)
	#note that the input is an array for optimize speed
	#output is written to file

	seq = reverse(join(seq))
	i = 0
	newline = false
	for char in seq 
		newline = false
		print(outfile, translation_table(char))
		i += 1
		if i == 60
			print(outfile, "\n")
			i = 0
			newline = true 
		end 
	end
	if newline != true
		print(outfile,"\n")
	end
end

########### PROGRAM HERE 
#input = ARGS[1]
input1 = "dna7.fsa"
infile = check_inputfile(input1)

#input2 = ARGS[2]
input2 = "dna7comreverse.fsa"
outfile = check_outfile(input2)


#print the firstidentification
println(outfile,readline(infile)*"Reverse complement string")

dnastring=[]
for line in eachline(infile)
	global dnastring
	if line[begin] == '>'
		reverse_complement_seq(dnastring,outfile)

		#Next sequence and reset
		println(outfile,line*"Reverse complement string")
		dnastring=[]

	else
		push!(dnastring,line)
	end 
end

close(infile)
close(outfile)





#2) Improve 2.1 Make a function that calculates factorial, rememeber input control
println("I will calculate factorial of interger numbers\nI will stop when you write STOP")

function checkinput(number)
	out = 1
	try 
		number = parse(Int64,number)
		out = 1
		if number < 0 
			println("I can only take positive numbers\nEXIT")
			exit()
		elseif number > 0
			for i in number:-1:1
				out *= i
			end
		end
	catch
		println("Your input is gibberish and not an integer \n EXIT")
		exit()
	end
	return out 
end 

#Test if there is an argument first
try 
	input = ARGS[1]
	global input
catch 
	print("Try feed me a number: ")
	input = readline()
	global input
end

while input != "STOP"
	global input
	number = checkinput(input)
	
	println("The factorial is:  $number")
	print("Try feed me a number: ")
	input = readline()
end 	




#3) Bases translator 
println("I will calculate factorial of interger numbers\nI will stop when you write STOP")

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

function checkinput(input)
	#Input the codon
	try 
		if length(input) != 3
			println("Your input is not in the correct 3 bases format \nEXIT")
			exit()
		end 

		input=uppercase(input)		
		out=codon[input]
		global out
	#Takes the error, if there is a number or something
	catch
		println("Your input is gibberish and not a codon \n EXIT")
		exit()
	end
	return out 
end 



#Test if there is an argument first
try 
	input = ARGS[1]
	global input
catch 
	print("Try feed me a number: ")
	input = readline()
	global input
end


codon = initilize_dict()
while input != "STOP"
	global input
	number = checkinput(input)

	println("The codon for $input is:  $number")
	print("Try feed me a 3 letter codon: ")
	input = readline()
end 	





#4) Standard deviator calculator 

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

function calculate_sd(infile)
	#Note that i calculate the sd of ALL numbers,
	squaredsum, normsum, size = 0, 0, 0

	for line in eachline(infile)
		#Save the data in a structure
		line = split(line)

		for item in line 
			try 
				item = parse(Float64,item)
				squaredsum 	+= item*item 
				normsum 	+= item 
				size 		+=1
			catch 
				println("Not a number: $item")
			end 
		end
	end
	m = [squaredsum, normsum, size]
	std = sqrt((m[3]*m[1]-m[2]^2)/(m[3]*(m[3]-1)))
	return std
end


####PROGRAM HERE
#input = ARGS[1]
input1 = "suppl/ex1.dat"
infile = check_inputfile(input1)

#Calculate it
println("The standard deviation is: $(calculate_sd(infile))")

close(infile)



#5) List the accessionnumbers ordered. The exercise is copied directly from my previous handin. 

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