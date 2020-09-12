#!/usr/bin/julia

#1) print mean 

println("Enter two numbers here and I will calculate the mean : ")
print("Number 1 is: ")
n1 = readline()
print("Number two is: ")
n2= readline()

n1 = parse(Int64,n1)
n2 = parse(Int64,n2)

meanvalue=round((n1+n2)/2)

println("The numbers where: $n1 and $n2 \nThe mean is $meanvalue")



#2)
#Commandline
##julia test.jl < Twonumbers.txt

#The code itself
n1 = readline()
n2 = readline()


println("$n1 and $n2")

n1 = parse(Int64,n1)
n2 = parse(Int64,n2)

meanvalue=round((n1+n2)/2)

println("The numbers where: $n1 and $n2 \nThe mean is $meanvalue")





#3) 
infile = open("ex1.dat","r")


filelength = 0
positive, negative = 0,0


global filelength, positive, negative
for line in eachline(infile)
	global negative
	string_split = split(line,"\t")
	#println(string_split)

	for item in string_split
		number = parse(Float64,item)
		if number < 0 
			negative +=1
		end 
	end 
end


println("The number of negative eleamts is $negative")


close(infile)

#4)
print("I can convert from feinhard to celcsius, give me the degree in either celcuius or fehrenheit. \nInput degree:")

input = readline()

#lastchar=(last(input))


lastchar=string(input[end])


if lastchar =="F"
	number=parse(Float64,(input[1:(end-1)]))
	println("The degree in celcius is: ",(number-32)/(9/5))
elseif lastchar =="C"
	number=parse(Float64,(input[1:(end-1)]))
	println("The degree in fahrenheit is: ", (number*(9/5))+32)
else 
	println("Invalid input, try again")
end 

#5)
println("I can give you the acesion numbers, i have selected the file orphans.sp")



infile = open("orphans.sp","r")
outfile = open("orphans_out.sp","w")

for line in eachline(infile)

	if line[1:1] ==">"

		splitted = split(line, " ")
		#println(splitted[1][2:end])
		text = string(splitted[1][2:end])

		text = text * "\n"

		write(outfile,text)
	end


end


close(infile)
close(outfile)


#6)

#First ask for file
#input1,input2 = readline(),readline()

#Make a loop to loop though one file 
	#Save the line 
	#Append a line (read one at a time from the second file)

	#Output the collected line to a third file

#end 


print("Feed me a file: ")
n1 = readline()
print("Feed me another file: ")
n2 = readline()



infile = open(n1,"r")
infile2 = open(n2,"r")


for line in eachline(infile)
	filetwoline = readline(n2)
	println(line*"\t"*filetwoline)

end




close(infile)
close(infile2)





#7) Make complement string 

println("Feed me a file¨, it will be dna.dat: ")


infile = open("dna.dat","r")

dnastring = ""
global dnastring
for line in eachline(infile)
	global dnastring

	dnastring = dnastring *line 


end


reversestring = ""
global reversestring
for char in dnastring
	
	global reversestring
	println(typeof(char))
	println(typeof('T'))
	if char == 'A'
		reversestring = reversestring* "T"
	elseif char =='T'
		reversestring =reversestring * "A"
	elseif char =='C'
		reversestring =reversestring * "G"
	elseif char =='G'
		reversestring =reversestring * "C"	
	end 

end


println(dnastring)
println("test")
println(reversestring)

close(infile)


#8) reverse string
newreverse = reverse(reversestring) 

#9) print it out
##print out in new file 
outfile = open("dna_new.dat","w")

i = 1 
global i 

for char in newreverse
	global i
	write(outfile, char)

	i += 1
	if i == 61
		write(outfile, "\n")
		i = 1 
	end 
end

close(outfile)


#10)

println("Feed me a file¨, it will be dna.fsa: ")


infile = open("dna.fsa","r")



identification = ""
dnastring = ""

global identification, dnastring

for line in eachline(infile)
	global identification, dnastring
	if line[begin] == '>'
		identification = line * "Reverse complement string \n"
	else
		dnastring = dnastring * line
	end 
end


#Complement it 
reversestring = ""
global reversestring
for char in dnastring
	
	global reversestring



end


#Reverse it 
newreverse = reverse(reversestring) 

##print out in new file 
outfile = open("dna_new.dat","w")
write(outfile, identification)
i = 1 
global i 

for char in newreverse
	global i
	write(outfile, char)

	i += 1
	if i == 61
		write(outfile, "\n")
		i = 1 
	end 
end


close(outfile)
close(infile)



#11)  Count 
println("Feed me a file¨, it will be dna.fsa: ")
infile = open("dna.fsa","r")


A_count, T_count, C_count, G_count = 0,0,0,0

global A_count, T_count, C_count, G_count
for line in eachline(infile)
	if line[begin] == '>'
		identification = line * "Reverse complement string \n"
	else
		for char in line
			
			global A_count, T_count, C_count, G_count

			if char == 'A'
				A_count += 1
			elseif char =='T'
				T_count += 1
			elseif char =='C'
				C_count += 1
			elseif char =='G'
				G_count += 1	
			end 

		end
	end
end 


println("The results is A $A_count , T: $T_count C: $C_count G: $G_count")


close(infile)


#12) Bull eye 





n = 50 
m = 50 

#center 
x_center = n/2
y_center = n/2


#Distance, use the eucledian lengtht messuare 
distance = sqrt(x_center^2 + y_center^2)

println(distance)

for i in 1:n


	for j in 1:m
		global distance, x_center , y_center

		x = i - x_center
		y = j - y_center 

		current_distance = sqrt(x^2+y^2)

		if current_distance < 0.1*distance 
			print("#")
		elseif current_distance < 0.3*distance
			print("+")
		elseif current_distance < 0.7*distance
			print("*")
		elseif current_distance < 1*distance
			print(" ")
		end

	end 
	print("\n")
end