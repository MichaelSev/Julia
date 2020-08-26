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


function check_args(ARGS)
	#Check the inputs argument, if none arguments ask for one at IO

	println("I will check the accessionnumber in the filw dna-array.dat")
	if length(ARGS) == 1
		accessionnumber = ARGS[1]
		println("I will search for the number: $accessionnumber")
	elseif length(ARGS) == 0
		print("Please feed me an accesionnumber: ")
		accessionnumber = readline()
	#in case of many inputs
	else 
		println("I can only handle one accesssion number at the time\nYou can feed me one: ")
		accessionnumber = readline()
	end
	return accessionnumber
end 


function readfile(accessionnumber)
	#Search for the accessionnumber in the file. Input only accessionnumber 
	#The two first lines are the data of the file, those are saved manual 

	infile = check_inputfile("dna-array.dat")
	header = readline(infile) #not used, could also just be the "header"
	information = readline(infile)


	check_flag = false 
	for line in eachline("dna-array.dat") 
		line = split(line,"\t")

		#When the file is found, there is no more need for further search
		if line[2] == accessionnumber
			outline = line 

			#Return it here for save a global 
			return([information,outline])
			check_flag = true 
			break 
		end 

	end
	close(infile)
	
	if check_flag == false
		println("No accessionnumber found for: $accessionnumber in the file dna-array.dat\n EXIT")
		exit()
	end 
end


function readdata(readfileout)
	
	#Put information in list and as numbers
	information = parse.(Int64,split(readfileout[1],"\t")[4:end])
	accdata = readfileout[2]
	accnum = parse.(Float64,accdata[4:end])

	
	println("The data for: $(accdata[1]), with the accnumber: $(accdata[2]) and general name: $(accdata[3]) is: ")

	#Find the index for cancer and healty patients 
	cancerindex =  findall(x->x==0, information)
	healtyindex =  findall(x->x==1, information) 

	#Find the longestitem 
	cancerindexlen = length(cancerindex)
	healtyindexlen = length(healtyindex)

	println("$(accnum[cancerindex])")

	println("Cancer data \t Healty data ")
	for i in 1:max(healtyindexlen,cancerindexlen)

		#Print the healty index
		if i <= cancerindexlen
			print("$(accnum[cancerindex][i]) \t \t")
		else 
			print("\t \t")
		end	

		if i <= healtyindexlen
			print("$(accnum[healtyindex][i]) \n ")
		else 
			print("\n")
		end	


	end
end 



####PROGRAM HERE
accessionnumber =  check_args(ARGS)

readfileout = readfile(accessionnumber)

readdata(readfileout)

