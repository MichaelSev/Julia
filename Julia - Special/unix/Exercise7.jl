#!/usr/bin/julia


#1) Regex

println("I can check wether or not the input is a number")



function check_number(input::String)
	#check_number 
	#input: String
	#output: print statement at io. 


	flag = occursin( r"^-?\d+(\.\d+)?$" ,input) 

	if flag == true 
		println("This is a number")
	else 
		println("This is not a number")
	end 
end 

check_number(ARGS[1])




#2) Improve 5.6
println("I am another version of exercise 5.6")

#Use regex ro find ID, accession number, AA, control of sequence length and create fastafile



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



function ID_identifier(input)
	#Input as a string
	#Output, either ID string or nothing 
	match(r"^ID\s+(\w+)", input)
end 

function AC_identifier(input)
	#Input as a string
	#Output, either AC string or nothing 
	match(r"^AC\s+(\w+)", input)
end 

function SQ_identifier(input)
	#Input as a string
	#Output, either AC string or nothing 
	match(r"^SQ\s+(\w+)", input)
end 




#Acctual program 


#input = ARGS[1]
input1 = "suppl/sprot1.dat"

infile = check_inputfile(input1)

#intput2 = ARGS[2]
intput2 = "sprot_new.fsa"
outfile = check_outfile(intput2)


sq_flag,seq,ID,AC,AA_num  = false, "", "", "", ""
global sq_flag
for line in eachline(infile)
	global sq_flag,seq,ID,AC,AA_num
	#println(line)



	#Not sure this is the most effective to read it twice, in these fast case i will not consider
	if ID_identifier(line) != nothing

		ID = ID_identifier(line)[1]
		
		#Could also consider
		#ID = split(line)[2]

	elseif AC_identifier(line) != nothing
		AC =AC_identifier(line)[1]

	elseif line[1:2]=="//"

		#Write and check the result 
		if length(seq)!=parse(Int64,AA_num)
			println("The number of amino acid and the written number are not equal")

			close(infile)
			close(outfile)
			exit()
		else 
			println(outfile,">"*ID*AC*"number of AA: "*AA_num)

			for i in 1:60:length(seq)
				println(outfile,seq[i:i+59])
			end 
			#The rest are easy overwritten and are therefor not here
			sq_flag,seq = false,""
		end 


	#Sequence check 
	elseif sq_flag == true

		seq *=join(split(line," "))
	elseif  SQ_identifier(line) != nothing


		sq_flag= true
		line = split(line)
		AA_num = line[3]
	end

end

close(infile)
close(outfile)

#3) Improve 4.1 using all knowlegde 

#ASK HERE
#Is there something like "maketrans"? 
#I tried with the replace without success 

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



#4) A lot of different exercises ffrom data1-4.gb 

#5 Extract the accession number, the defination and organism (print)

#6 Extract and print all MEDLINE article numbers which are mentioned in the entries 

#7 Extract and print the translated gene 

#8 Extract and print the DNA 

#9 Extract and print ONLY the coding DNA 



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


function regex_identifier(input)

	#Input as a string
	# Finds the stuff from exercise 6

	#find the defination 
	if match(r"^DEFINITION\s+(\w+)", input) != nothing
		println("This is exercise 7.6")
		println("The definition is: ", join(split(input," ")[2:end]," "))

	#find the accession
	elseif match(r"^ACCESSION\s+(\w+)", input) != nothing
		println("The accession number is: ", join(split(input," ")[2:end]," "))

	elseif match(r"^\s+ORGANISM\s+(\w+)", input) != nothing
		println("The organism is: ", join(split(input,"  ")[3:end]," "))
	end 

end 


#This could techincal be in the same as above, since the job are identic. 
function referennce_identifier(input)
	global medlineflag 
	#For exercise 7 
	#This only works when the order is there is a REFERENCE and the refernces ends with a COMMENT 

	if medlineflag == false && match(r"^REFERENCE\s+(\w+)", input) != nothing 
		medlineflag = true 
		print("The MEDLINE numbers are:")

	elseif match(r"^\s+MEDLINE\s+(\w+)", input) != nothing
		print(split(input,"  ")[3])

	elseif match(r"^COMMENT\s+(\w+)", input) != nothing
		medlineflag = false
		print("\n")
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



function print_exon(sequence,exon)
	#Function for printing the exon in exercise 9
	#input, both string
	#Exon have the format [start]..[end]\s[start]..[end] of each exon
	#output is print in io 

	#For not taking the last newspace is end-1
	exonsplit = split(exon[1:(end-1)]," ")
	for item in exonsplit
		item = split(item,"..")

		first = parse(Int,item[1])
		last = parse(Int,item[2])

		println("Coding sequence from $first until $last :")

		#Loop for making sure only 60 letters at each line
		if last-first > 60 
			diff = floor((last-first)/60)

			#Not sure this is the most elegant way, to print it in stacks of 60, but it works
			count = 0 
			for i in first:60:last
				println(sequence[i:i+59])
				count +=1
				if count == 3 
					break 
				end
			end 
			#Print the last, 
			first = Int(first+60*diff)
			println(sequence[first:last])

		else
			println(sequence[first:last])
		end 
	end
end


#The filename
#input = ARGS[1]
input1 = "data1.gb"

infile = check_inputfile(input1)

medlineflag,translationflag,dnaflag = false, false, false 
dnaseq,intron,exon = "","",""
for line in eachline(infile)
	global dnaflag, dnaseq, exon, intron

	#Exercise (6) find Accession number, definition and organism 
	regex_identifier(line)
	referennce_identifier(line)
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


print_exon(dnaseq,exon)



close(infile)

