#!/usr/bin/julia

#1) Make a program that can write words to a file
println("I can save words to a file.\n I will only stop when you write STOP")
input = ""

outfile = open("words.txt","w")

while input != "STOP"
	global input
	print("Feed me some words! :")
	input = readline()

	if input != "STOP"
		print("YES")
		write(outfile,input*"\n")
	end

end

close(outfile)



#2) make a program that can read the words and sort them 

println("I can sort words from a file")

outfile = open("words.txt","r")

wordlist = []

for line in eachline(outfile)
	global wordlist

	push!(wordlist,(line))
end

outlist = (reverse(sort(wordlist)))
close(outfile)

outfile = open("words.txt","w")
for item in outlist
	write(outfile,item*"\n")
end

close(outfile)





#3) sort and exisisting list 
println("I can sort words from a file")

outfile = open("ex5.acc","r")

wordlist = []

for line in eachline(outfile)
	global wordlist

	push!(wordlist,(line))
end

outlist = (reverse(sort(wordlist)))
close(outfile)


#Check the first
newlist = []
push!(newlist,outlist[1])


for i = 2:(length(outlist))
	global newlist

	if outlist[i-1] != outlist[i]
		push!(newlist,outlist[i])
	end
end  




outfile = open("clean.acc","w")
for item in newlist
	write(outfile,item*"\n")
end

close(outfile)

#4) improve with pop



println("I can sort words from a file")

outfile = open("suppl/ex5.acc","r")

wordlist = []

for line in eachline(outfile)
	global wordlist

	push!(wordlist,(line))
end

outlist = (reverse(sort(wordlist)))
close(outfile)


#Check the first

println(length(outlist))


for i = (length(outlist)-1):-1:1
	global newlist

	if outlist[i+1] == outlist[i]

		popat!(outlist,i)
	end
end  


println(length(outlist))


outfile = open("clean.acc","w")
for item in outlist
	write(outfile,item*"\n")
end

close(outfile)

#5)

println("I can find word in a  file")



answer = ""


while answer != "STOP"
	global answer 
	println("Which accession numbers do you want to search for? \nI will stop when you write STOP")
	print("Input your number: ")
	answer = readline()

	flag = false

	infile = open("clean.acc","r")
	for line in eachline(infile)
		println(line)
		if string(line) == string(answer)
			println("\n \n It is there \n \n")
			flag = true
		end 
	end
	close(infile)

	println(answer)


	if flag == true
		flag = false 
	else 
		println("\n \n Your input is not here \n \n")
	end 

end

#Not the best method, could consider to save the file in a variable instead. 

#6)



println("I can sort words from a file")
infile = open("clean.acc","r")

variablelist = []
for line in eachline(infile)
	push!(variablelist,line)
end

close(infile)



println("Which accession numbers do you want to search for? \nI will stop when you write STOP")
print("Input your number: ")
answer = readline()

while answer != "STOP"
	global answer 


	flag = false

	#higher and lower
	H = length(variablelist) 
	L = 1


	global L, H 
	while L < H 
		global answer 

		center = Int(floor((H+L)/2))

		tester = variablelist[center]

		if variablelist[center] > answer 
			L = center +1
		elseif variablelist[center] < answer
			H = center
		else 

			flag = true 
			println("$answer can be found at position $center")
			L = H +1 
		end
	end



	if flag == true
		flag = false 

	else 
		println("\n \n Your input is not here \n \n")
	end 

	#Repeat
	println("Which accession numbers do you want to search for? \nI will stop when you write STOP")
	print("Input your number: ")
	answer = readline()

end



#7)

println("I am an input check ")


if isempty(ARGS) == true
	global infile 
	println("please feed me a file")
	print("Here: ")
	input = readline()

	infile = open(input,"r")
else
	try 
	infile = open(ARGS[1],"r")
	global infile 
	catch 
		println("Something wrong with your input, Exit")
		quit
	end 


	println("I have opened the file $ARGS[1]")
end



println(ARGS)

println(readline(infile))



close(infile)



#8)

#Save which column and file name there shall be opened and cutted

#for line infile
	#Save the correct column in each line
#end 

#close file 

println("I am an input check ")



columns = (ARGS[1:(end-1)])
cutt = []
#Convert to intergers
for i in 1:length(columns)
	global cutt
	println(typeof(columns[i]))
	push!(cutt,(parse.(Int64,columns[i])))
end

filename = ARGS[end]

println(cutt)
infile = open(filename,"r")


for line in eachline(infile)
	
	splitted = split(line)
	global splitted
	for item in cutt
		
		print(splitted[item]*"\t")
	end
	print("\n")
end



close(infile) 





#Calculate the sum, 9 and 10 collected

println("I am a sum calculater")



filename = ARGS[end]

infile = open(filename,"r")

colsum = []
#The first line to find the number of columns
line = split(readline(infile))
i = length(line)

for j in 1:i
	push!(colsum, parse(Float64,line[j]))
end
println(line)

#Read the rest
for line in eachline(infile)


	#reset position 
	i = 1

	#Calculate the sum 
	splitted = split(line)
	global splitted, i , colsum

	for item in splitted
		

		colsum[i] += parse(Float64,item)

		i +=1
	
	end

end



println(colsum)

close(infile)






