


A = zeros(Int64,10,10)

for i in 1:10
	println(A[:,i])
end



fill!(A[:,1],1)


println("")
for i in 1:10
	println(A[:,i])
end


A = zeros(Int64,1000,1000)

B = Dict()

for i in 1:1000
	get!(B,i => Array{Int64}(i:1:i+1000),3)
end

function printtest2(stuff)
	for i in 1:1000
		#println(stuff[:,i])
	end
end



function printtest(stuff)
	for item in stuff
		#println(item)
	end
end


 @time printtest(B)


@time printtest2(A)



A = [13,14,15,1,2,3,4,5,6,7,8,9,10,11,12]

println(partialsortperm(A,1:4))


function maxk(a, k)
    b = partialsortperm(a, 1:k, rev=true)
    return collect(zip(b, a[b]))
end

#println(maxk(A, 1))

function findextrema(v, n; rev=false)
           idx = selectperm(v, 1:n; rev=rev)
           return v[idx], idx
 end

#println(findextrema(A,3; rev=true))

