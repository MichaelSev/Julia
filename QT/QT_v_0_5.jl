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
		#Consider changes this to matrix structure, if there is speed to get (not main focus on the distancematrix)
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


function eucledian_distance(string1::Array{Float64,1},string2::Array{Float64,1})
	#Eucledian distance formula 
	distance = 0 
	for i in 1:length(string1)

		distance += (string1[i]-string2[i])^2

	end

	return round(sqrt(distance),digits=5)
end


function calculate_distancematrix(PointPosition::Vector)
	#Calculate the distance matrix, from the position of each datpoint	

	matrixsize = length(PointPosition)
	matrixsize2 = length(split(PointPosition[1]))

	PointMatrix    = zeros(Float64, matrixsize,matrixsize2)
	distanceMatrix = zeros(Float64, matrixsize,matrixsize)

	#Convert the points from string to float
	for i in 1:matrixsize
		PointMatrix[i,:] =  round.(parse.(Float64,split(PointPosition[i])), digits=5)
	end

	#Calculate the distance matrix
	for i in 1:matrixsize
		for j in 1:matrixsize 

			#Do not calcualte the diagonal, default zero 
			if i != j || i > j 
				distance = eucledian_distance(PointMatrix[i,:],PointMatrix[j,:])

				#NOTE NOTE NOTE 
				#Consider adding the points to the threshold matrix here also, this is now done later in the process 
				distanceMatrix[i,j] = distance
				distanceMatrix[j,i] = distance		
			end
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



	return round(threshold, digits=5)

end



function make_whitelist(blacklist,datasize)
	return setdiff(Vector{Int64}(1:1:datasize), blacklist)
end



function make_potentialcluster(distanceMatrix::Array{Float64,2},threshold,whitelist)
	

	#Define which points there are suitable for being a part of the QT cluster. 
	#This would be an obvious part to make my own type, which i have written behind my ear 
	
	#The dimensions of the matrix (always symmetric)
	m = size(distancematrix,1)
	
	potentialclusters = Vector{Array{Int64,1}}()
	for i in whitelist

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

######################################
######################################
######################################
######################################
######################################
######################################


function make_candidatecluster(distancematrix::Array{Float64,2},threshold::Float64,candidatepoints)

	out = Vector{Int64}()
	push!(out,candidatepoints[1])
	popat!(candidatepoints,1)
	selecteddistance = 0 

	newpointdistance = distancematrix[out[1],candidatepoints]

	while length(candidatepoints) > 0 

		nearstpointindex = argmin(newpointdistance)
		selecteddistance = newpointdistance[nearstpointindex]
		push!(out,candidatepoints[nearstpointindex])
		popat!(candidatepoints,nearstpointindex)
		popat!(newpointdistance,nearstpointindex)


		#Update distance 

		for i in length(newpointdistance):-1:1
			item = newpointdistance[i]
			if item < distancematrix[out[end],candidatepoints[i]]
				newpointdistance[i]=distancematrix[out[end],candidatepoints[i]]
			end

			if newpointdistance[i] > threshold
				popat!(candidatepoints,i)
				popat!(newpointdistance,i)
			end
		end
	


	end


	return out, selecteddistance
end




function qt_clustering(distancematrix::Array{Float64,2},threshold,potentialclusters)
	
	#The dimensions of the matrix 
	m = size(distancematrix,1)
	n = size(distancematrix,2)
	

	outcluster = Vector{Array{Int64,1}}()
	outclusterdistance = Vector{Float64}()
	#For each start position 

	for item in potentialclusters

		
		#End the end, there will only be one point 
		if length(item) >1
			outlist, distancenum = make_candidatecluster(distancematrix,threshold,item)
			push!(outcluster,outlist)
			push!(outclusterdistance,distancenum)
		else
			push!(outcluster,item)
			push!(outclusterdistance,0.)
		end 
	end

	#Find the biggest cluster and return it 
	biggestclusterpoint = get_biggest_cluster(outcluster,distancematrix,outclusterdistance)

	return sort(biggestclusterpoint)

end


function get_biggest_cluster(outcluster,distanceMatrix,outclusterdistance)

	clutsersize = length(outcluster[1])
	cluterdiameter = outclusterdistance[1] 
	cluster = 1
	 
	for i in 1:length(outcluster)
		
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
	return outcluster[cluster]
end	


######################################
######################################
######################################
######################################
######################################
######################################



Colnames, PointPosition = read_file(ARGS[1])

distancematrix = calculate_distancematrix(PointPosition)
threshold = threshold_handler(distancematrix,ARGS[2])

blacklist = Vector{Int64}()




for i in 1:1000
	global threshold, distancematrix
	whitelist = make_whitelist(blacklist,size(distancematrix,1))

	if length(whitelist) == 0 
		break 
	else 

		potentialclusters = make_potentialcluster(distancematrix,threshold,whitelist)


		out = qt_clustering(distancematrix,threshold,potentialclusters)


		for item in out
			push!(blacklist,item)
			print("$(item-1) ")
		end 
		print("\n")
	end


end 










