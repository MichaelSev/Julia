A = Array{Int64,1}([1,2,4])


for i in 1:10
	#push!(A,i)
end
println(A)


B = 11

println(length(intersect(A,B)))