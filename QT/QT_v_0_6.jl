#!/usr/bin/julia

#The system of this file 

#PART1, read file and save the data
#PART2, calculate the distance matrix
#PART3, do the clustering
#PART4, optimzation functions
#PART5, accutal program 


######################################
######################################
######################################
######################################
#Read file functions

function give_colnames(colsize)
	#Will name the the points in a given dataset with "Point,i" if no names is supported from the input file 
	Colnames = Vector{String}()
	for i in 1:colsize
		push!(Colnames,"Point$i")
	end
	return(Colnames)
end

function read_file(filename::String)
	#Read the input file, returns a distance matrix f
	infile = open(filename,"r")
	#Test wether or not the first column is names or just positions

	Colnames = Vector{String}()
	PointPosition = Vector{String}()

	for line in eachline(infile)
		line = split(line)

		coordinates =  Vector{String}()
		for item in line 
			#Make sure there is no 
			if match(r"^\d+",item) != nothing && match(r"\d+$",item) != nothing
				push!(coordinates,item)
			else 
				push!(Colnames,item)
			end
		end 

		### NOTES HERE###
		#Consider changes this to matrix structure, if there is speed to get (not main focus on the distanceMatrix)
		#Could also consider to calcualte the distance matrix here, as i find each of the previous found???!!!
		push!(PointPosition,join(coordinates, " "))
	end
	close(infile)
	

	#Check if colnames is given 
	if length(Colnames)== 0 
		Colnames = give_colnames(size(PointPosition,1))
	end

	return Colnames, PointPosition
end


######################################
######################################
######################################
######################################
#Distance matrix functions


function eucledian_distance(string1,string2)
	#Eucledian distance formula 
	distance = 0.0
	for i in 1:length(string1)
		distance += (string1[i]-string2[i])^2
	end
	return sqrt(distance)
end


function calculate_distanceMatrix(PointPosition::Vector)
	#Calculate the distance matrix, from the position of each datpoint	

	matrixsize = length(PointPosition)
	matrixsize2 = length(split(PointPosition[1]))

	PointMatrix    = zeros(Float64, matrixsize2,matrixsize)
	distanceMatrix = zeros(Float64, matrixsize,matrixsize)

	#distanceMatrix = Array{Float64,2}(undef,matrixsize,matrixsize)

	#Convert the points from string to float
	for i in 1:matrixsize
	
		PointMatrix[:,i] =  parse.(Float64,split(PointPosition[i]))
	end

	#Calculate the distance matrix
	for i in 1:matrixsize
		for j in i+1:matrixsize 
			distance = eucledian_distance(view(PointMatrix,:,i),view(PointMatrix,:,j))
			#distance = eucledian_distance(PointMatrix[:,i],PointMatrix[:,j])
			distanceMatrix[i,j] = distance
			distanceMatrix[j,i] = distance		
			
		end
	end	
	return distanceMatrix
end


function threshold_handler(distanceMatrix::Array{Float64,2},threshold::String)

	maxdistsance = maximum(distanceMatrix)
	
	#Define the threshold
	if threshold[end] == '%'
		threshold = maxdistsance*(parse(Float64,threshold[1:(end-1)])/100)
	else
		threshold = parse(Float64,threshold)
	end
	return threshold
end


function make_whitelist(whitelist,blacklist)
	return setdiff(whitelist, blacklist)
end


function make_potentialcluster(distanceMatrix::Array{Float64,2},threshold,whitelist)
	#Define which points there are suitable for being a part of the QT cluster. 
	#This would be an obvious part to make my own type, which i have written behind my ear 
	
	#The dimensions of the matrix (always symmetric)
	m = size(distanceMatrix,1)
	
	potentialclusters = Vector{Array{Int64,1}}()
	counter = 1
	for i in 1:m 
		#CC = potential for current cluster 
		cc = Vector{Int64}()
		push!(cc,i)
		for j in whitelist

			#If not its own position, and the distance is lower than the threshold
			if j != i  && distanceMatrix[i,j] <= threshold
				push!(cc,j)
			end

		end
		push!(potentialclusters,cc)
	end


	return potentialclusters

end

function update_potentialcluster(distanceMatrix,threshold,whitelist,potentialclusters)
	
	for item in whitelist
		if isempty(potentialclusters[item])
			cc = Vector{Int64}()
			push!(cc,item)
			
			for j in whitelist

				#If not its own position, and the distance is lower than the threshold
				if j != item  && distanceMatrix[item,j] <= threshold
					push!(cc,j)
				end
			end
			potentialclusters[item] = cc
		end
	end

	return potentialclusters
end

######################################
######################################
######################################
######################################
######################################
######################################


function make_candidatecluster(distanceMatrix::Array{Float64,2},threshold::Float64,candidatepoints,outcluster)

	out = Vector{Int64}()
	push!(out,candidatepoints[1])
	popat!(candidatepoints,1)
	selecteddistance = zero(eltype(distanceMatrix)) 

	newpointdistance = distanceMatrix[out[1],candidatepoints]

	while length(candidatepoints) > 0 

		nearstpointindex = argmin(newpointdistance)
		selecteddistance = newpointdistance[nearstpointindex]

		push!(out,candidatepoints[nearstpointindex])
		popat!(candidatepoints,nearstpointindex)
		popat!(newpointdistance,nearstpointindex)

		#Update distance 
		for i in length(newpointdistance):-1:1
			item = newpointdistance[i]

			#Can be ooptimized here by moving the second statement into the first statement 
			if item < distanceMatrix[out[end],candidatepoints[i]]
				newpointdistance[i]=distanceMatrix[out[end],candidatepoints[i]]
			end

			if newpointdistance[i] > threshold
				popat!(candidatepoints,i)
				popat!(newpointdistance,i)
			end
		end

		#It works, but is highly inefficient, something else should be reconsidered. 
		if length(out) == 1000 ||  length(out) == 1000 || length(out) == 1000
			flag = check_alreadymade_cluster(outcluster,out)
			if flag 
				print("YES")
				candidatepoints =  Vector{Int64}()
			end
		end
	end
	 
	return out, selecteddistance
end

function check_alreadymade_cluster(outcluster,currentout)
	newcluster = false
	for item in outcluster
		if length(currentout) <= length(item)
			
			if sort(item[1:length(currentout)]) == sort(currentout)
				#println("YES")
				newcluster = true
			end
		end
	end
	return newcluster 
end




function qt_clustering(distanceMatrix::Array{Float64,2},threshold,potentialclusters,outcluster,outclusterdistance)

	#The dimensions of the matrix 
	m = size(distanceMatrix,1)
	n = size(distanceMatrix,2)
	
	potentialclusters_copy = copy(potentialclusters) 
	
	
	#For each start position 

	counter = 0 
	for item in potentialclusters_copy
		counter += 1

		#In the end, there will only be one point, this can be left out, does no much for the speed 
		if length(item) >1

			outlist, distancenum = make_candidatecluster(distanceMatrix,threshold,item,outcluster)
			outcluster[counter]=outlist
			outclusterdistance[counter]=distancenum
		else
			outcluster[counter]=item
			outclusterdistance[counter]=0.
		end 
	end
	return outclusterdistance, outcluster
end


function get_biggest_cluster(outcluster,distanceMatrix,outclusterdistance)

	clutsersize = length(outcluster[1])
	cluterdiameter = outclusterdistance[1] 
	cluster = 1
	
	#From 2, because the first cluster is the one above
	for i in 2:length(outcluster)
		
		#Find largest cluster
		if clutsersize < length(outcluster[i])
			clutsersize = length(outcluster[i])
			cluterdiameter = outclusterdistance[i] 
			cluster = i
		end

		if clutsersize == length(outcluster[i]) && cluterdiameter > outclusterdistance[i]
			clutsersize = length(outcluster[i])
			cluterdiameter = outclusterdistance[i] 
			cluster = i
		end		
	end
	return sort(outcluster[cluster])
end	


######################################
######################################
######################################
######################################
######################################
######################################

function recycle_finish_cluster(biggestclusterpoint,potentialclusters,outcluster,blacklist,outclusterdistance)

	#Turn it around, due to indexing
	biggestclusterpointrev = sort(biggestclusterpoint,rev=true)



	for item in potentialclusters
		if length(item) != 0  
			uniqueness = intersect(biggestclusterpointrev,item)
			index = item[1,1]
			if isempty(uniqueness)
				#Delete the potentialcluster, because it shall not be calculated in next interation
				#println(item)
				potentialclusters[index] = Vector{Int64}()
			else
				tester = potentialclusters[index]
				potentialclusters[index] = setdiff(tester,biggestclusterpointrev)
				outclusterdistance[index] = 0.
				outcluster[index] = Vector{Int64}()
			end
		end
	end

	return outclusterdistance, outcluster, potentialclusters
end

function update_blacklist(blacklist,newcluster)
	return union(blacklist,newcluster)
end

function print_output(biggestclusterpoint)
	for item in biggestclusterpoint
		#push!(blacklist,item)
		print("$(item-1) ")
	end 
	print("\n")
end

function qt(filename, inputargument)
	Colnames, PointPosition = read_file(filename)
	distanceMatrix = calculate_distanceMatrix(PointPosition)
	threshold = threshold_handler(distanceMatrix,inputargument)


	blacklist = Vector{Int64}()
	whitelist = Vector{Int64}(1:1:size(distanceMatrix,1))
	
	#Can find out of, if the set is faster, need more testing
	#blacklist = Set{Int64}()
	#whitelist = Set{Int64}(1:1:size(distanceMatrix,1))

	outcluster = Vector{Array{Int64,1}}()
	outclusterdistance = Vector{Float64}()
	for i in 1:size(distanceMatrix,1)
		push!(outcluster,Vector{Int64}())
		push!(outclusterdistance,0.)
	end

	potentialclusters = make_potentialcluster(distanceMatrix,threshold,whitelist)

	while length(whitelist) != 0 
		
		
		outclusterdistance, outcluster = qt_clustering(distanceMatrix,threshold,potentialclusters,outcluster,outclusterdistance)
		biggestclusterpoint = get_biggest_cluster(outcluster,distanceMatrix,outclusterdistance)

		#The potential clusters, are popped each time in qt_clustering, i can not find a way to make a good copy. 
		#It is even deleted, but there is no return of it?, i find this strange 
		
	
		print_output(biggestclusterpoint)
		
		blacklist = update_blacklist(blacklist,biggestclusterpoint)
		whitelist = make_whitelist(whitelist,blacklist)
		outclusterdistance, outcluster, potentialclusters = recycle_finish_cluster(biggestclusterpoint,potentialclusters,outcluster,blacklist,outclusterdistance)
		potentialclusters = update_potentialcluster(distanceMatrix,threshold,whitelist,potentialclusters)
	end 
end 


for i in 1:1
	@time qt(ARGS[1], ARGS[2])
end






