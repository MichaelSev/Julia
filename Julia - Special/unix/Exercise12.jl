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
	mutations = Dict{String,String}()


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
			if line[2] == "VARIANT"
				
				push!(mutations,line[3] => join(line[5:7]))

			elseif line[2] =="MUTAGEN"
				push!(mutations,line[3] => line[5][1:4])
			end 
		end
	end 

	#Do the mutation 
	bytes =  Vector{UInt8}(sequence)
	for key in keys(mutations)
		position = parse(Int64,key)
		#If correct position 
		if sequence[position]==mutations[key][1]
			bytes[position] = mutations[key][4]
		else
			println("The mutations and sequence are not in compliance with eachother, at $position")
		end
	end

	print_sequence(sequence,outfile)

	close(infile)
	close(outfile)
end


function print_sequence(seq,outfilename)
	number = Int(floor(length(seq)/60))
	for i in 1:60:number*60
		println(outfilename,seq[i:i+59])
	end 
	println(outfilename,seq[(number*60+1):length(seq)])
end

read_file("appendix1.txt","appendix1out.fsa")



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

####The code 

function get_blacklistfile(filename::String)
	#Get the blacklist as set from appendix 4
	infile = open(filename,"r")
	
	blacklist = Set{String}()
	for line in eachline(infile)
		push!(blacklist,line)
	end

	#End
	close(infile)
	return(blacklist)
end

function get_informationfile(filename::String)
	infile = open(filename,"r")
	informations = Dict{String, Float64}()

	for line in eachline(infile)
		line = split(line)
		#Key= line[1], value =mean of line[2:end]
		push!(informations,line[1]=>sum(parse.(Float64,line[2:end])/length(line[2:end])))

	end
	close(infile)

	return informations
end

function get_translation(filename::String)
	#Get the translation from appendix file 

	infile = open(filename,"r")
	informations = Dict{String, String}()

	for line in eachline(infile)
		line = split(line)
		#Key= Swissprot, value=Genbank
		push!(informations,line[1]=>line[3])
	end
	close(infile)
	return informations
end 

function remove_blacklist(data::Dict,blacklist::Set,translation::Dict)
	#First shall the blacklist be translated 
	blacklisttranslated = Set{String}()
	for item in blacklist
		push!(blacklisttranslated,translation[item])
	end
	
	#Find the interasections
	datakey = Set{String}(keys(data))
	intersections = intersect(datakey,blacklisttranslated)

	#pop the intersections
	for item in intersections 
		delete!(data,item)
	end

	return data
end 

function sort_and_print_dict(dictname::Dict)
	#sort and print the dict by value

	#I have to say, I like this method. 
	means = [(acc, v) for (acc, v) in dictname]
    
    sort!(means, by=x -> x[2], rev=true)

    #Print statements 
	println("The higest value is $(round(means[1][2],sigdigits=5)) with the ID: $(means[1][1]) ")
	println("The lowest value is $(round(means[end][2],sigdigits=5)) with the ID: $(means[end][1]) ")
end 

function do_the_job()
	#Read the file and get the informations
	blacklist 	= get_blacklistfile("appendix4.txt")
	data  		= get_informationfile("appendix3.txt")
	translation = get_translation("appendix5.txt")

	#Remove the blacklisted items from the data
	data = remove_blacklist(data,blacklist,translation)

	#print the reamning values 
	sort_and_print_dict(data)
end


#Call the script
do_the_job()


