#!/usr/bin/julia

#1) 

println("Hello world")

#2) 

for i in 1:10
    println("Hello world")
end

#3) print number 1:10
for i in 1:10
    println(i)
end


#4) get it to ask for a name 
print("Enter your name: ")
n = readline()

if n == "Michael"
	println("Your name is $n. What a beutiful name")
else
	println("Your name is $n.")
end 


#5) Make a program that ask for two numbers and print the sum 
println("Input two numbers and I will calculate the sum : ")
print("Enter the first number: ")
n1 = readline()
n1 = parse(Float64,n1)
print("Enter the second number: ")
n2 = readline()
n2 = parse(Float64,n2)

println(n1+n2)

#6) Extend and make it ask for operation 

println("Input two numbers and I will calculate the sum : ")
print("Enter the first number: ")
n1 = readline()
n1 = parse(Float64,n1)
print("Enter the second number: ")
n2 = readline()
n2 = parse(Float64,n2)

print("Enter the oeprator: ")
operator = readline()

if operator == "+"
	println(n1+n2)
elseif operator == "-"
	println(n1-n2)

elseif operator == "*"
	println(n1*n2)

elseif operator == "/"
	if n2 == 0
		println("illegal to use zero")
	else 
		println(n1/n2)
	end

else 
	println("invalid argument you gave me there")
end 

#7) print all numbers in between two numbers 
println("Input two numbers and I will calculate the sum : ")
print("Enter the first number: ")
n1 = readline()
n1 = parse(Float64,n1)
print("Enter the second number: ")
n2 = readline()
n2 = parse(Float64,n2)


for i in n1:n2
	println(i)
end


#8) 
println("Input two numbers and I will calculate the sum : ")
print("Enter the first number: ")
n1 = readline()
n1 = parse(Float64,n1)
print("Enter the second number: ")
n2 = readline()
n2 = parse(Float64,n2)

if n2 < n1
	n1, n2 = n2, n1
end


for i in n1:n2
	println(i)
end


#9) Continue asking for number, until a lower is given 
print("Try give me a number : ")
n1 = readline()
n1 = parse(Float64,n1)

global n2 = n1 


while n1 <= n2
	global n2

	print("Try give me a another number : ")
	n2 = readline()
	n2 = parse(Float64,n2)
end
	


#10) Exercise 10 

print("Try give me a number : ")
n1 = readline()
n1 = parse(Float64,n1)


if n1 < 0 
	println("invalid option")
else 
	summ = n1
	global summ 
	global n1 
	while n1 > 1
		global summ 
		global 
		n1 = n1 -1
		summ = summ * n1 
	end
	println("The factoiral is $summ")
end



#11) 
print("Try give me a number : ")
n1 = readline()
n1 = parse(Float64,n1)


if n1 < 0 

	summ = n1
	global summ 
	global n1 
	while n1 < 0
		global summ 
		global 
		n1 = n1 +1
		summ = summ + n1 
	end
	println("The sum is $summ")

else 
	summ = n1
	global summ 
	global n1 
	while n1 > 0
		global summ 
		global 
		n1 = n1 -1
		summ = summ + n1 
	end
	println("The sum is $summ")
end





