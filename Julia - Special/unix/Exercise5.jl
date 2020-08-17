#!/usr/bin/julia

#1-5) 

println("I can open a sprot file and read stuff, i will open sprot1.dat")

infile = open("sprot1.dat","r")

sq_flag = false 
dnaseq = ""
elements = 0

for line in eachline(infile )
	global sq_flag, dnaseq, elements 
	
	if line[1:2] =="//"
		sq_flag = false  
	elseif sq_flag == true
		println(line)
		dnaseq *= line[6:(end)]
	elseif line[1:2] == "ID"
		splitted = split(line)
		println(splitted[2])
		elements = splitted[5]

	elseif line[1:2] == "AC"
		splitted = split(line)
		println(splitted[2][1:(end-1)])
	elseif line[1:2] == "SQ"
		sq_flag = true
	end


end

dna_seq = (join(split(dnaseq," ")))


i = 0 

for char in dna_seq
	global i 
	i += 1 
end 

elements = parse(Int64, elements)

if elements == i 
	println("There is the correct number")
	println("The number of elements was $i")
else
	println("There is a flaw")
end




close(infile)


#6,7) 
println("I can open a sprot file and read stuff, i will open sprot1.dat")
#Note that this method only works for one sequence
infile = open("dna.fsa","r")


AA_flag = false
sequence = ""

for line in eachline(infile)

	global AA_flag, sequence 

	if AA_flag == true
		sequence *= line

	elseif line[begin] =='>'
		AA_flag = true
	end


end

println(length(sequence))



for i = 1:(length(sequence)-2)
	codon = (sequence[i:i+2])

	if codon == "ATG"
		codonstart = i
		println("Bonus at position $i")
		global codonstart
		break 
	end
end



for i = codonstart:3:length(sequence)
	codon = (sequence[i:i+2])

	if codon == "TAA" || codon =="TAG" || codon =="TGA"
		println("End position at $i")
		break
	end 
end




#9) 
println("I can open a sprot file and read stuff, i will open  orphans.sp")
#Note that this method only works for one sequence
infile = open("orphans.sp","r")



print("But i can search for an organishm for you: ")
organism = readline()
organism = uppercase(organism)

count = 0
for line in eachline(infile)

	splitted  = (split(line)[begin])

	i = 2 #Because we want the letter after 
	for char in splitted 
		global i, pos
		pos = false
		if char == '_'
			pos = i
			break 
		end 

		i += 1
	end 

	global i, pos, count 

	if pos != false 
		if organism == splitted[pos:end]

			count += 1
		end 
	end 



end 


println("There was $count that matched $organism")

close(infile)




#11) 

#The letter guessing game 


print("I can guess a number, try give me one:")
number = readline()


number = parse(Int64,number)

minn = 1
maxx = 10

guess = maxx/2

answer = "no"

counter = 0

while answer != "y" 
	global minn, maxx, guess, answer,counter 
	println("I Guess the number is: $guess \nIs this correct?")
	println("You can answer with either y (yes), h (higher) or l (lower)")
	answer = readline()


	if answer == "h"

		minn = guess

		guess = round((minn+maxx)/2)

	elseif answer == "l"
		maxx = guess 
		guess = round((minn+maxx)/2)

	end 

	counter += 1
end


println("I guess the correct number at $guess \n I did it only $counter turns")