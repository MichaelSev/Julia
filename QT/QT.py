#!/usr/bin/env python3
import sys,re,math,copy 

print("QT-Clustering ")

def input_handler():
    """ handles sys.argv input and asks for any missing input. """
    # No input given
    if len(sys.argv) < 2 : 
        sys.stderr.write("You forgot to give me any input")
        filename = input("Insert filename: ")
        quality_threshold = input("Insert a quality threshold (maximum cluster diameter): ")

    # Only filename is provided
    elif len(sys.argv) == 2: 
        filename = sys.argv[1]
        quality_threshold = input("Insert a quality threshold (maximum cluster diameter): ") 

    # Both filename and quality threshold are provided
    elif len(sys.argv) == 3:
        filename = sys.argv[1]
        quality_threshold = sys.argv[2]

    else: 
        sys.stderr.write("Invalid input, try again")
        sys.exit(1)

    return filename, quality_threshold

def read_inputfile(filename):
    """ Reads file and collects data in list of tuples """
    coordinates = tuple()
    data = list()
    try:
        with open(filename, 'r') as infile: 
            for line in infile:
                # store all coordinates for each point in a tuple
                coordinates = tuple()
                for item in line.split('\t'):
                    if re.match(r'[0-9|.]+', item):
                        coordinates += (float(item.strip()),)
                # store each tuple in a list containing all datapoints
                data.append(coordinates)
        
        #
        return data
    except IOError as error:
        sys.stderr.write("File I/O error, reason: " + str(error) +"\n")
        sys.exit(1)
    except ValueError as error:
        sys.stderr.write("Value Error, reason: " + str(error) +"\n" + "At point: ", pointID)
        sys.exit(1)


def euclidean_distance(point1,point2): 
    # EUCLIDEAN DISTANCE : takes two multidimensional points of equal rowLength, and returns the euclidean distance.
    distance = math.sqrt(sum([(q - p)**2 for q, p in zip(point1, point2)])) 

    return distance

def calculate_distance_matrix(data):
    """ calculates the distance matrix from data as well as the diamter of the entire dataset  """
    distance_matrix = list(list(euclidean_distance(point1, point2) for j, point2 in enumerate(data))
                            for i, point1 in enumerate(data))
    data_diameter = max([item for subtuple in distance_matrix for item in subtuple])
    return distance_matrix, data_diameter


def quality_threshold_handler(quality_threshold, data_diameter): 
    """ Takes the quality_threshold from input and data_diameter (maximal diameter of data)
        Gives the data as a float
        Remark, i think we should move the control of the input to the start. 
        It does not make logic sense that we first calculate all the distances and then say the input is invalid	
    """
    # Analyse quality threshold input
    percentage_flag = re.search(r"[\%]$", quality_threshold)
    value = re.search(r'[0-9][\.0-9]?', quality_threshold)

    # recognize if quality threshold is given as set value or a percentage of the maximum data diameter
    if percentage_flag is not None:
        threshold = float(quality_threshold[:-1])/100*data_diameter
    elif value is not None:
        threshold = float(quality_threshold)
    else: 
        print("Wrong input for maximum diameter, you can try again with either a value or 30%")
        sys.exit(1)
    return threshold




def test_new_point(local_control,currentRow,threshold,distance_list,distance_matrix):

        
  return nearestpoint,distance_list,currentdata_diameter,local_control


def candidate_cluster(distance_matrix,threshold,global_control) :
  """ calculates candidate clusters for all points in the data set """
  
  rowLength = len(distance_matrix[0])

  #Variables and list, 
  CC = list()  # candidate clusters (CC)
  CCdiameter_list = list()    # Holds all candidate cluster diameters

  # goes through all points in the data set
  for i in range(rowLength):
    
    # if point not used, start new candidate cluster
    if global_control[i] is True: 
      local_control = copy.deepcopy(global_control)   # local control of used points in CC
      local_control[i] = False                        # current point has been used
      distance_list = copy.deepcopy(distance_matrix[i])  
      currentdata_diameter = threshold
      currentCC_diameter = 0                # current candidate cluster diameter
      currentCC = list()
      currentCC.append(i)
      
      # create a candidate cluster for each point
      for j in range(rowLength):

        # identify nearest point
        """ Remove points which exceeds the quality threshold, and identify nearest neighbor """
        rowLength = len(distance_matrix[0])
        currentRow = currentCC[-1]
        currentdata_diameter = threshold 
        nearestpoint = None 
        
        # For the point just added to the cluster, go through all other points, to identify the point to add 
        for point in range(rowLength):
      
          #Check if a current point exceed the threshold 
          if distance_matrix[currentRow][point] > threshold: 
              local_control[point] = False  
        
          
          #Update distances for the potential clusters 
      
          for n in range(len(local_control)):  
            if local_control[n] is True: 
            
              #Update the distance_list 
              if distance_list[n] < distance_matrix[currentRow][n]:
                distance_list[n] = distance_matrix[currentRow][n] 
                
              #Find index of nearst neighbour
              if distance_list[n] < currentdata_diameter:
                currentdata_diameter = distance_list[n]
                nearestpoint = n
                
        # Add the point to the potential cluster list
        if nearestpoint is None: #If no point to be added   
          CCdiameter_list.append(currentCC_diameter)
          break         
        
        else:
          currentCC.append(nearestpoint)
          #Space for optimization, control if there has been an equal cluster before                 
          local_control[nearestpoint]= False
          currentCC_diameter = currentdata_diameter

      
      #Save in list 
      CC.append(currentCC)
      
  return CC,CCdiameter_list


def pick_cluster(candidate_clusters,data_diameterList):
  """ picks the candidate cluster according to the rules:
        1. find the largest clusters in the number of points
        2. pick the cluster with the smallest diameter
        3. if same diameter pick the first one found
  """
  
  #Here are there space for optimization! 
  #Use a while loop 
  #Fx if length is 1 
  #If the second best is nothing in common with the first 
   

    
  maxCluster = 0 
  maxClusterNumber = 0 
  maxClusterDiameter = 0 
 
  for i in range(len(candidate_clusters)): 
    
   # rule 1: find the largest cluster(s) 
    if maxCluster < len(candidate_clusters[i]): 
      maxCluster = len(candidate_clusters[i])
      maxClusterNumber = i
      maxClusterDiameter = data_diameterList[i]
      
    # rule 2: find the cluster(s) with minimum diameter
    # rule 3: take the first cluster that was found
    if maxCluster ==  len(candidate_clusters[i]) and maxClusterDiameter > data_diameterList[i]:
      maxClusterNumber = i 
      maxClusterDiameter = data_diameterList[i]
      maxCluster = len(candidate_clusters[i])
  
  
  # return  picked cluster 
  clusters = candidate_clusters[maxClusterNumber]
  

  
  return clusters







def cluster_generator(distance_matrix,data_diameter):
  #Cluser generator 
  #Saves the final clusters 

  rowLength = len(distance_matrix[0])
  control=[True for i in range(rowLength)] 
  maxCluster,allClusters= list(),list()
  
  while any(control) is True: 
      
    candidate_clusters,data_diameterList=candidate_cluster(distance_matrix,data_diameter,control)

    clusters = pick_cluster(candidate_clusters,data_diameterList)
    
    clusters.sort()
    
    allClusters.append(clusters)
    
    for number in clusters: 
      control[number] = False
    
  return allClusters 

def print_clusters(clusters,data):
  #Print
  for i in range(len(clusters)): 
    
    print("-> Cluster ",i+1)
  
    for j in range(len(clusters[i])):
      
      print("point",clusters[i][j], data[clusters[i][j]])
    



""" Actual code """
# handle input given as sys.argv or terminal input, and return filename and quality threshold.
filename, init_threshold = input_handler()

# read inputfile and return data as list of tuples. 
data = read_inputfile(filename)

# calculate distance matrix and diameter of entire data set
distance_matrix,data_diameter = calculate_distance_matrix(data)  

# handle two types of threshold inputs, and return as readable format.
# still needs some error-handling, but works if  correct format (either a number or percentage).. maybe try-except?
threshold = quality_threshold_handler(init_threshold,data_diameter)
print(threshold)
# perform quality threshold clustering (QT-clustering)
final_clusters=cluster_generator(distance_matrix,threshold)

# print clusters in desired format. 
print_clusters(final_clusters,data)

