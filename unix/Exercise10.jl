#!/usr/bin/julia

#1) Take test files and calculate the mean of all numbers



function take_average(filename::String,dictname::Dict)
	#Filename: sepearted datafile, with identifier in first column.
	#Dictname: the dict 

	#Returns the dict. 
	infile = open(filename,"r")


	#Save each number to dict 
	for line in eachline(infile)

		#If not in dict 
		line = split(line)
		if haskey(dictname,line[1]) != true 
			#Calculate the mean value of all numbers
			value = sum(parse.(Float64,line[2:end]))/length(line[2:end])
			get!(accesiondict,line[1],value)

		#if already in dict 
		#This is for addeing a second file, if there are any overlab 
		else
			#Not the most optimal calculation wise, but it saves memory for not saving all numbers before the mean is calculated in the end. 
			dictname[line[1]] = (dictname[line[1]] + sum(parse.(Float64,line[2:end])))/(length(line[2:end])+1)
		end
	end
	close(infile)
	return accesiondict
end 

function sort_and_print_dict(dictname::Dict)
	#sort and print the dict by value
	#input:
	#dict 

	dictname = sort(collect(dictname), by = x -> x[2],rev=true)
	x = map(x -> x[1], dictname)
	y = map(x -> x[2], dictname)
	println("Accesionnumber \t meanvalue")
	for i in 1:length(x)
		println(x[i],"\t",y[i])
	end
end 


####PROGRAM HERE
#input = [ARGS[1], ARGS[2], ARGS[3]]
input = ["test1.dat","test2.dat","test3.dat"]

accesiondict = Dict()

for item in input
	global accesiondict
	accesiondict = take_average(item,accesiondict)
end

sort_and_print_dict(accesiondict)

#Should be approx 6,57 (caluclated with a few decimals by hand) it works. 
println(accesiondict["M64930"])



#10) Transpose and print matrix 
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

function get_matrix(filename)
	#Takes a filename, and saves the data as a matrix of list in list. 
	infile = check_inputfile(filename)
	
	matrix = []

	for line in eachline(infile)
		push!(matrix,split(line))
	end

	close(infile)
	return matrix
end

function not_transpose(mymatrix)
	#Not a transpose, but if you want to have it opposite (in case you forget what transpose not means)
	#This is only saved for my own joy.
	for i in length(mymatrix[1]):-1:1
		#Note that this only works for non empty matrix 
		for j in size(mymatrix)[1]:-1:1
			print(mymatrix[j][i] *"\t")
		end
		print("\n")
	end
end 


function my_transpose(mymatrix)
	#True transpose of a matrix
	for i in 1:length(mymatrix[1])
		#Note that this only works for non empty matrix 
		for j in 1:size(mymatrix)[1]
			print(mymatrix[j][i] *"\t")
		end
		print("\n")
	end
end 
####PROGRAM HERE
#input = ARGS[1]
input = "matrix.dat"

#Get matrix and print it
mymatrix = get_matrix(input)
my_transpose(mymatrix)

#Later note, this is in practice an list in any, and not list in list. 
#But since the other was ment only to python, since it solves the job it will be there. 
#Note that exercise 11 is a true matrix