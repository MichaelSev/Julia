#!/usr/bin/julia


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

