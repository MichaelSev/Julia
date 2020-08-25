#!/usr/bin/julia

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

function get_matrix(filename::String)
	#Takes a filename, and saves the data as a matrix of list in list. 
	infile = check_inputfile(filename)

	matrix = parse.(Int64,split(readline(infile)))

	for line in eachline(infile)
		line = parse.(Int64,split(line))
		matrix = [matrix line]
	
	end

	close(infile)
	return matrix
end



####PROGRAM HERE
#input = [ARGS[1], ARGS[2]]
input = ["mat1.dat","mat2.dat"]

#Get matrix and print it
mymatrix1 = get_matrix(input[1])

mymatrix2 = get_matrix(input[2])

#Dot product true 
println(mymatrix1*mymatrix2)

function my_dotproduct(matrix1,matrix2)



