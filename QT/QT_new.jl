#The system of this file 

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

function eucledian_distance(string1,string2)
	#Eucledian distance formula 
	distance = 0.0
	for i in 1:length(string1)
		distance += (string1[i]-string2[i])^2
	end
	#Try a hundred times: 
	#@distance = sum((string1-string2)^2)
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
	#maxdistance
	#Define the threshold
	if threshold[end] == '%'
		threshold = maxdistsance*(parse(Float64,threshold[1:(end-1)])/100)
	else
		threshold = parse(Float64,threshold)
	end
	return threshold
end

################
####### Potential cluster check 
################

struct Acceptancelist 
	#Blacklist, the list of observations already selected as candidate clusters
	#Greylist, the list of observation, which has calculated a candidate cluster
	#Whitelist, the list of observation, which is in greylist, and has not been calculated yet. 

	blacklist::Array{Int64,1}
	greylist ::Array{Int64,1}
	whitelist::Array{Int64,1}
end

struct Potentialclusterlist 
	#Has the pourposse of beeing immunrateasfkjljsafl
	original::Array{Int64,2}
	iterazeable::Array{Int64,2}
end

function make_potentialcluster(distanceMatrix::Array{Float64,2},threshold,whitelist,greylist)
	#Define which points there are suitable for being a part of the QT cluster. 
	#There is some 

	m = size(distanceMatrix,1)
	#potentialclusters = Array{Int64}(undef,m,m)
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

######################################
######################################
############## PART 3 ################
######################################
######################################

#Not sure if i gonna use, let it be for now. 
struct CandidateCluster
	distance::Float64
	canCluster::Array{Int64,1}
end 

function make_candidatecluster!(distanceMatrix::Array{Float64,2},threshold,candidateclustermatrix::Array{Int64,2},candidatepoints::Array{Int64,1})
	#Calculate a candidate cluster

	#Initilize objects
	candidateCluster = zeros(Int64,size(candidateclustermatrix,1))
	candidateCluster[1] = candidatepoints[1]

	candidatepoints=(candidatepoints[1:argmin(candidatepoints)-1])
	newpointdistance = distanceMatrix[candidateCluster[1],candidatepoints[2:end]]
	selecteddistance = 0.

	popat!(candidatepoints,1)
	localcount = 1
	#Find all candidate points 
	while length(candidatepoints) > 0 

		localcount +=1
		#Find smallest

		nearstpointindex = argmin(newpointdistance)
		selecteddistance = newpointdistance[nearstpointindex]

		candidateCluster[localcount] = candidatepoints[nearstpointindex]

		#Remove elements, I have considered do a true/false indexing instead of popping. 
		#Nut sure if i am up for to many elements. 
		popat!(candidatepoints,nearstpointindex)
		popat!(newpointdistance,nearstpointindex)

		#Update distance 
		for i in length(newpointdistance):-1:1
			item = newpointdistance[i]
			checkdistance =  distanceMatrix[candidateCluster[localcount],candidatepoints[i]]
			
			#Check if the distance should be updated and afterwards exceeds the threshold 
			if item < checkdistance
				if checkdistance > threshold
					popat!(candidatepoints,i)
					popat!(newpointdistance,i)
				else 
					newpointdistance[i]=checkdistance
				end			
			end			
		end

		#Consider adding a more generic method here. 
		if localcount== 2 || localcount == 5 || localcount == 10 || localcount == 20
			if check_alreadymade_cluster(candidateclustermatrix,candidateCluster,localcount) 
				candidatepoints =  Vector{Int64}()
			end
		end
	end

	return candidateCluster, selecteddistance
end 


function check_alreadymade_cluster(outcluster,currentout,localcount)
	#Check if there already have been calculated a cluster, identical with the current. 
	item = currentout[1:localcount]
	iterator = item[2:end]
	item = sort(item)

	for seed in iterator
		comparecombject = sort(outcluster[1:localcount,seed])
		if comparecombject != item
			return false 
		end
	end
	return true 
end

######################################
######################################
############## PART 4 ################
######################################
######################################

function qt_clustering!(distanceMatrix::Array{Float64,2},threshold,potentialClusters::Array{Int64,2},candidateClusterMatrix::Array{Int64,2},
candidateClusterDistance::Array{Float64,1},greylist)

	#The dimensions of the matrix 
	m = size(distanceMatrix,1)
	n = size(distanceMatrix,2)
	
	for item in greylist
		pos = item 
		item = potentialClusters[:,item]
		#item = view(potentialClusters,:,item)

		if length(item) >1
			candidateCluster,candidateDistance = make_candidatecluster!(distanceMatrix,threshold,candidateClusterMatrix,item)
			candidateClusterMatrix[:,pos]=candidateCluster
			candidateClusterDistance[pos]=candidateDistance
		else	
			candidateClusterMatrix[1,pos]= item[1]
			candidateClusterDistance[pos]=0.
		end 		
	end
	return candidateClusterDistance, candidateClusterMatrix
end


function get_biggest_cluster(outcluster,distanceMatrix,outclusterdistance)
	#Find the biggest cluster and return it sorted 
	#This method shall be change according to the new method of indexing 

	#The lowest number will always be zero (unless it is full, which is very imposible)
	clutsersize = argmin(outcluster[:,1])
	cluterdiameter = outclusterdistance[1] 
	cluster = 1

	#From 2, because the first cluster is the one above
	for i in 2:size(outcluster,2)
		pos = argmin(outcluster[:,i])
		#Find largest cluster
		if clutsersize < pos
			clutsersize = pos
			cluterdiameter = outclusterdistance[i] 
			cluster = i
		end

		if clutsersize == pos && cluterdiameter > outclusterdistance[i]
			clutsersize = pos
			cluterdiameter = outclusterdistance[i] 
			cluster = i
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

	potentialclusters , maximumsize = make_potentialcluster(distanceMatrix,threshold,acceptancelist.whitelist,acceptancelist.greylist)
	potentialclusterlist = Potentialclusterlist(potentialclusters,potentialclusters)

	candidateClusterMatrix 	= zeros(Int64,maximumsize,obnum)
	candidateClusterDistance= zeros(Float64,obnum)

	FINISH_CLUTSERTOPRINT = Array{Array{Int64,1},1}()

	while length(acceptancelist.whitelist) != 0 

		candidateClusterDistance, candidateClusterMatrix = qt_clustering!(distanceMatrix,threshold,potentialclusterlist.iterazeable,
		candidateClusterMatrix,candidateClusterDistance,acceptancelist.greylist)

		finishCandidateCluster = get_biggest_cluster(candidateClusterMatrix,distanceMatrix,candidateClusterDistance)

		recalculatelist,candidateClusterMatrix,candidateClusterDistance = recycle_clusters(potentialclusterlist,finishCandidateCluster,candidateClusterMatrix,candidateClusterDistance)

		acceptancelist = update_colorlist(acceptancelist,recalculatelist,finishCandidateCluster,distanceMatrix)

		potentialclusters = make_potentialcluster(distanceMatrix,threshold,acceptancelist.whitelist,acceptancelist.greylist)[1]
		potentialclusterlist = Potentialclusterlist(potentialclusterlist.original,potentialclusters)
		
		println(sort(finishCandidateCluster,rev=true)[1:10])
		push!(FINISH_CLUTSERTOPRINT,finishCandidateCluster)
	end

	print_output(FINISH_CLUTSERTOPRINT,Colnames, PointPosition)
end


function print_output(FINISH_CLUTSERTOPRINT,Colnames, PointPosition)
	outfile = open("QTclustering_out.lst","w")

	localcount = 0
	for item in FINISH_CLUTSERTOPRINT

		localcount +=1
		println(outfile,"-> Cluster" ,localcount)
		for number in  sort(item[1:argmin(item)-1])
			println(outfile,Colnames[number],"\t",PointPosition[number])
		end
	end
	close(outfile)
end


function recycle_clusters(potentialclusterlist,finishCandidateCluster,candidateClusterMatrix,candidateClusterDistance)
	#The final removal betweeen the grey and black list of the finished cluster, can be found in the color function 

	recalculatelist = Array{Int64,1}()

	for i in 1:1:size(candidateClusterMatrix,2)
		item = view(potentialclusterlist.original,:,i)
		
		#1, because there is always zero in list  zerop 
		if length(intersect(finishCandidateCluster,item)) != 1 
			push!(recalculatelist,i)
			
			#The fill function does not work like this...
			#fill!(candidateClusterMatrix[:,i],0)
			candidateClusterMatrix[:,i] = zeros(Int64,size(candidateClusterMatrix,1))
			candidateClusterDistance[i] = 0 
		end
	end
	return(recalculatelist,candidateClusterMatrix,candidateClusterDistance)
end

function  update_colorlist(acceptancelist,recalculatelist,finishCandidateCluster,distanceMatrix)

	blacklist = union(acceptancelist.blacklist,finishCandidateCluster)
	whitelist = setdiff(acceptancelist.whitelist,blacklist)
	greylist = setdiff(recalculatelist,blacklist)

	return(Acceptancelist(blacklist,greylist,whitelist))
end


######################################
######################################
############# PART END ###############
######################################
######################################

filename = ARGS[1]
inputargument = ARGS[2]

@time qt(filename, inputargument)


