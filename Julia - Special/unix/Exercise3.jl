#!/usr/bin/julia

#1) 

infile = open("ex1.acc","r")

for line in eachline(infile)
	println(line)
end

close(infile)

#2)

print("Try give me a file : ")
filename = readline()
infile = open(filename,"r")

for line in eachline(infile)
	println(line)
end

close(infile)


#3)
print("Try give me a file : ")
filename = readline()
infile = open(filename,"r")


filelength = 0
global filelength
for line in eachline(infile)
	global filelength
	filelength +=1
end
println(filelength)
close(infile)


#4) split the file into three 
cut -f 1 ex1.dat > col1.dat
cut -f 2 ex1.dat > col2.dat
cut -f 3 ex1.dat > col3.dat



#4) calculate the sum
print("Try give me a file : ")
filename = readline()

infile = open(filename,"r")


filelength = 0
filesum = 0.0

global filelength,filesum
for line in eachline(infile)
	global filelength,filesum


	filesum +=parse(Float64,line)
	filelength +=1
end

if filelength == 0 
	println("empty file")
else
	println("The sum of the file is $filesum")
end

close(infile)

#5) Calculate the mean 

print("Try give me a file : ")
filename = readline()

infile = open(filename,"r")


filelength = 0
filesum = 0.0

global filelength,filesum
for line in eachline(infile)
	global filelength,filesum


	filesum +=parse(Float64,line)
	filelength +=1
end

if filelength == 0 
	println("empty file")
else
	meanvalue = filesum/filelength
	println("The mean of the file is $meanvalue")
end

close(infile)


#6) find number of positive and negative numbers


print("Try give me a file : ")
filename = readline()

infile = open(filename,"r")


filelength = 0
positive, negative, neutral = 0,0,0

global filelength,filesum
for line in eachline(infile)
	global filelength, positive, negative, neutral

	number = parse(Float64,line)

	if number < 0 
		negative += 1
	elseif number > 0 
		positive += 1 
	else 
		neutral += 1 
	end 

end


if filelength == 0 
	println("empty file")
else
	println("The number of positive is $positive \n The number of negative is $negative \n The number of neutral is $neutral ")
end


close(infile)

#7, 8 & 9 ) find biggest and smallest and collected 
print("Try give me a file : ")
filename = readline()

infile = open(filename,"r")


filelength = 0
positive, negative = 0,0


global filelength,filesum
for line in eachline(infile)
	global filelength, positive, negative, neutral
	filelength +=1
	number = parse(Float64,line)

	if number < negative 
		negative = number
	elseif number > positive
		positive = number  
	end 

end


if filelength == 0 
	println("empty file")
else
	println("The highgest number  of positive is $positive \n The smallet number of negative is $negative \n ")
end


close(infile)


#10)
print("Try give me a number and i will guess it between 1 and 10 \n You can tell me wether is is higher, lower or correct. \n Input your number here : ")
correct = readline()


guess_bool = false 
smallest = 1 
highest = 10 
guess = 5

answer = ""


global smallest, highest, guess,answer 

while answer != "correct"  
	global smallest, highest, guess,answer 

	println("I guess that your number is $guess, is your number higher, lower or correct?")
	answer = readline()

	if answer == "higher"
		guess += 1
	elseif answer == "lower"
		guess -= 1

	elseif answer == "correct"
		println("Yeah")

	end 

	if guess < smallest || guess > highest 
		println("you lied")
		answer = "correct"
	end 

end 


#Consider chaning this to Divide And Conquer
