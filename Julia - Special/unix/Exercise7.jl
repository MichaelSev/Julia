#!/usr/bin/julia


#1) Regex


input = ARGS[1]

try 
	println(parse(Float64,(input)))
catch 
	println(typeof(ARGS[1]))
	println("JAH")
end


#OR


println("I am a sum calculater")


input = ARGS[1]

try 
	println(parse(Float64,(input)))
catch 
	println(typeof(ARGS[1]))
	println("JAH")
end

println(occursin( r"^-?\d+(\.\d+)?$" ,input)  )
