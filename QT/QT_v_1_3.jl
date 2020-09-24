#The order of this file 

#PART1, Read file
#PART2, Distance matrix and other structures 
#PART3, Sub routine 
#PART4, Main routine 
#PART5, Print and check output 

######################################
######################################
############## PART 1 ################
######################################
######################################

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
############## PART 2 ################
######################################
######################################
#### DISTANCE MATRIX 

function eucledian_distance(string1,string2,size)
	#Eucledian distance formula 
	distance = 0.0
	for i in 1:size
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

	#Convert the points from string to float
	for i in 1:matrixsize
		PointMatrix[:,i] =  parse.(Float64,split(PointPosition[i]))
	end

	itemsize = length(PointMatrix[:,1])
	#Calculate the distance matrix
	for i in 1:matrixsize
		for j in i+1:matrixsize 
			distance = eucledian_distance(view(PointMatrix,:,i),view(PointMatrix,:,j),itemsize)
			distanceMatrix[i,j] = distance
			distanceMatrix[j,i] = distance
		end
	end	
	return distanceMatrix
end

function threshold_handler(distanceMatrix::Array{Float64,2},threshold::String)
	#Define the threshold
	maxdistsance = maximum(distanceMatrix)
	if threshold[end] == '%'
		threshold = maxdistsance*(parse(Float64,threshold[1:(end-1)])/100)
	else
		threshold = parse(Float64,threshold)
	end
	return threshold
end

################
####### Potential cluster check 

struct Potentialclusterlist 
	#Has the pourposse of beeing immunrateasfkjljsafl
	original::Array{Int64,2}
	iterazeable::Array{Int64,2}
end

function make_potentialcluster(distanceMatrix::Array{Float64,2},threshold,whitelist,greylist)
	#Define which points there are suitable for being a part of the QT cluster. 

	m = size(distanceMatrix,1)
	potentialclusters = zeros(Int64,m,m)

	#For reducing the output matrixng 
	maximumsize = 0

	#For each column
	for i in greylist
		potentialclusters[1,i] = i
		counter = 1

		#For each row in column, find the potential candidates
		for j in whitelist 
		#If not its own position, and the distance is lower than the threshold
			if j != i  && distanceMatrix[i,j] <= threshold
				counter +=1
				potentialclusters[counter,i]=j

				if counter > maximumsize
					maximumsize = counter
				end
			end
		end
	end
	maximumsize +=1
	return potentialclusters[1:maximumsize,:],maximumsize
end

struct Acceptancelist 
	#Blacklist, the list of observations already selected as candidate clusters
	#Greylist, the list of observation, which has calculated a candidate cluster
	#Whitelist, the list of observation, which is in greylist, and has not been calculated yet. 
	blacklist::Array{Int64,1}
	greylist ::Array{Int64,1}
	whitelist::Array{Int64,1}
end

function  update_colorlist(acceptancelist,recalculationlist,finishCandidateCluster,distanceMatrix)
	blacklist = union(acceptancelist.blacklist,finishCandidateCluster)
	whitelist = setdiff(acceptancelist.whitelist,blacklist)
	greylist = setdiff(recalculationlist,blacklist)

	return(Acceptancelist(blacklist,greylist,whitelist))
end

######################################
######################################
############## PART 3 ################
######################################
######################################
function make_candidatecluster!(distanceMatrix::Array{Float64,2},threshold,candidateClusterMatrix::Array{Int64,2},candidatepoints::Array{Int64,1},candidateClusterDistance,pos)
	#Calculate a candidate cluster

	#Initilize objects
	candidateCluster = 	candidateClusterMatrix[:,end]
	candidateCluster[1] = pos

	candidatepoints = candidatepoints[2:argmin(candidatepoints)-1]
	newpointdistance = distanceMatrix[candidatepoints,pos]
	localcount = 1

	#Find all candidate points 
	while length(candidatepoints) > 0 
		#Check if the cluster has already be calculated, generic ways has been tested, but this is by far the fastest
		if localcount==  2 || localcount == 5 || localcount == 10 || localcount == 15 || localcount == 20 || localcount == 50  || localcount == 100  
			if check_alreadymade_cluster(candidateClusterMatrix,sort!(candidateCluster[1:localcount]),localcount) 
				return candidateClusterMatrix, candidateClusterDistance
			end
		end

		localcount +=1
		#Find smallest
		nearstpointindex = argmin(newpointdistance)
		candidateClusterDistance[pos] = newpointdistance[nearstpointindex]
		candidateCluster[localcount] = candidatepoints[nearstpointindex]

		popat!(candidatepoints,nearstpointindex)
		popat!(newpointdistance,nearstpointindex)

		#Update distance 
		for i in length(candidatepoints):-1:1
			checkdistance =  distanceMatrix[candidateCluster[localcount],candidatepoints[i]]
	
			#Check if the distance should be updated and afterwards exceeds the threshold 
			if newpointdistance[i] < checkdistance 
				if checkdistance > threshold
					popat!(candidatepoints,i)
					popat!(newpointdistance,i)
				else 
					newpointdistance[i]=checkdistance
				end			
			end			
		end

	end

	candidateClusterMatrix[:,pos]=candidateCluster
end 


function check_alreadymade_cluster(outcluster,currentout,localcount)
	#Check if there already have been calculated a cluster, identical with the current. 
	#Check all other candidate cluster, with the same points 
	for seed in currentout
		if sort!(outcluster[1:localcount,seed]) == currentout
			return true
		end
	end
	return false 
end
######################################
######################################
############## PART 4 ################
######################################
######################################

function qt_clustering(distanceMatrix::Array{Float64,2},threshold,potentialClusters::Array{Int64,2},candidateClusterMatrix::Array{Int64,2},
candidateClusterDistance::Array{Float64,1},greylist)
	#Do the clustering

	for pos in greylist
		if length(potentialClusters[:,pos]) >1
			make_candidatecluster!(distanceMatrix,threshold,candidateClusterMatrix,potentialClusters[:,pos],candidateClusterDistance,pos)
		#If only one cluster back 
		else	
			candidateClusterMatrix[1,pos]=pos
		end 		
	end

	return candidateClusterDistance, candidateClusterMatrix
end


function get_biggest_cluster(outcluster,distanceMatrix,outclusterdistance,whitelist)
	#Find the biggest cluster and return it sorted 

	#The lowest number will always be zero (unless it is full, which is very imposible)
	clutsersize = argmin(outcluster[:,1])
	cluterdiameter = outclusterdistance[1] 
	cluster = 1

	for i in whitelist
		pos = argmin(view(outcluster,:,i))

		#Find largest cluster
		if clutsersize == pos && cluterdiameter > outclusterdistance[i]
			clutsersize,cluterdiameter,cluster = pos, outclusterdistance[i], i 
		elseif 	clutsersize < pos
			clutsersize,cluterdiameter,cluster = pos, outclusterdistance[i], i 
		end		
	end
	return outcluster[:,cluster]
end	

######################################
######################################
############## PART 5 ################
######################################
######################################
function qt(filename, inputargument)
	#The whole cluster algorithm 

	#Initilize objects 
	Colnames, PointPosition = read_file(filename)
	distanceMatrix = calculate_distanceMatrix(PointPosition)
	threshold = threshold_handler(distanceMatrix,inputargument)

	#observation number
	obnum = size(distanceMatrix,1)
	acceptancelist = Acceptancelist(zeros(Int64,1),Array{Int64}(1:1:obnum),Array{Int64}(1:1:obnum))

	#Find potential clusters
	potentialclusters , maximumsize = make_potentialcluster(distanceMatrix,threshold,acceptancelist.whitelist,acceptancelist.greylist)
	potentialclusterlist = Potentialclusterlist(potentialclusters,potentialclusters)

	#Initilize clustermatrix and distance 
	candidateClusterMatrix 	= zeros(Int64,maximumsize,obnum+1)
	candidateClusterDistance= zeros(Float64,obnum)

	FINISH_CLUTSERTOPRINT = Array{Array{Int64,1},1}()

	#Until all are clustered 
	while length(acceptancelist.whitelist) != 0 
		println("New turn \n \n \n")
		#Do the QT clustering, calculate all candidate clusters
		print("Cluster time:")
		@time candidateClusterDistance, candidateClusterMatrix = qt_clustering(distanceMatrix,threshold,potentialclusterlist.iterazeable,
		candidateClusterMatrix,candidateClusterDistance,acceptancelist.greylist)
	

		#Find the biggest cluster
		finishCandidateCluster = get_biggest_cluster(candidateClusterMatrix,distanceMatrix,candidateClusterDistance,acceptancelist.whitelist)
		#Sort the reamning candidate clusters, if any not should be calculated again. 
		print("Recycle time: ")

		@time recalculationlist,candidateClusterMatrix,candidateClusterDistance = recycle_clusters(potentialclusterlist.original,finishCandidateCluster[1:argmin(finishCandidateCluster)],candidateClusterMatrix,candidateClusterDistance,acceptancelist.whitelist)

		#Update the black, grey and whitelist. 
		acceptancelist = update_colorlist(acceptancelist,recalculationlist,finishCandidateCluster,distanceMatrix)

		#Find those there should be calculated again
		potentialclusters = make_potentialcluster(distanceMatrix,threshold,acceptancelist.whitelist,acceptancelist.greylist)[1]
		potentialclusterlist = Potentialclusterlist(potentialclusterlist.original,potentialclusters)
		
		#Push the outcluster 
		push!(FINISH_CLUTSERTOPRINT,finishCandidateCluster)
	end

	#Write to file
	print_output(FINISH_CLUTSERTOPRINT,Colnames, PointPosition)
end


function recycle_clusters(checklist,finishCandidateCluster,candidateClusterMatrix,candidateClusterDistance,whitelist)
	#The final removal betweeen the grey and black list of the finished cluster, can be found in the color function 

	emptylist = zeros(Int64,size(candidateClusterMatrix,1))

	#This is only worth it, for a given size
	recalculationlist,localcount = zeros(Int64,size(candidateClusterMatrix,2)) ,1
	for i in whitelist
		#1, because there is always zero in list  zero
		if length(intersect(finishCandidateCluster,checklist[:,i])) != 1 

			recalculationlist[localcount] = i
			localcount +=1
			candidateClusterMatrix[:,i] = emptylist
			candidateClusterDistance[i] = 0.
		end
	end
	
	return(recalculationlist[1:localcount],candidateClusterMatrix[1:length(finishCandidateCluster),:],candidateClusterDistance)	
end

function print_output(FINISH_CLUTSERTOPRINT,Colnames, PointPosition)
	#Print the output to file 
	outfile = open("QTclustering_out.lst","w")

	localcount = 0
	for item in FINISH_CLUTSERTOPRINT
		println(item[1:1])
		localcount +=1
		println(outfile,"-> Cluster" ,localcount)
		for number in  sort(item[1:argmin(item)-1])
			println(outfile,Colnames[number],"\t",PointPosition[number])
		end
	end
	close(outfile)
end

######################################
######################################
############# PART END ###############
######################################
######################################
filename = ARGS[1]
inputargument = ARGS[2]

@time qt(filename, inputargument)