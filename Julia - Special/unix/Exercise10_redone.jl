#!/usr/bin/julia


#Pseudcode 

#Initilize variables and names

#Read files
#For item in file, 
	#Save key to dict, add number as string to value
#end 
#Close files 

#Take advantage
#For key in dict
	#Calculate the mean of all numbers in value
#End 

#Sort and print output
#Show the output orded

#Test of M64930


function read_file(filenames)
	#Input: Array of file names, there shall be read. The key should be the first column. 
	#Output, dict of all inputs file with key and value

	dictname = Dict()

	for item in filenames
		infile = open(item,"r")

		for line in eachline(infile)
			#Split done, in the case of the key has different lengths, otherwise it could be split by that. 
			line = split(line) 
			key = line[1]
			value = join(line[2:end]," ")
		
			#If in dict
			if haskey(dictname,key) 
				dictname[key] = dictname[key] * " " * value

			#if not in dict 
			else
				#Get key and value
				get!(dictname,key,value)

			end
		end
		close(infile)
	end
	return dictname 
end 


function take_mean(dictname::Dict)
	#Take the mean of all values for each key. 

	for item in keys(dictname)

		#Split the string, and parse it into float
		#println(dictname[item])
		value = parse.(Float64,split(dictname[item]))

		#Calculate the mean 
		value = sum(value)/length(value)

		#Save in dict
		dictname[item] = value
	end

	return dictname
end


function sort_and_print_dict(dictname::Dict)
	#sort and print the dict by value

	#I have to say, I like this method. 
	means = [(acc, v) for (acc, v) in dictname]
    
    sort!(means, by=x -> x[2], rev=true)
    for (accession, mean) in means
        println(accession, "\t", round(mean, sigdigits=5))
    end
end 

####PROGRAM HERE
#input = [ARGS[1], ARGS[2], ARGS[3]]
input = ["test1.dat","test2.dat","test3.dat"]

accesiondict = read_file(input)
accesiondict = take_mean(accesiondict)
sort_and_print_dict(accesiondict)

#Or 
#sort_and_print_dict(take_mean(read_file(input)))

#Should be approx 6,57 (caluclated with a few decimals by hand) it works. 
println(accesiondict["M64930"])

