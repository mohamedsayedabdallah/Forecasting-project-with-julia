function holtlinear(filename,α,β)
	cd(dirname(@__FILE__))
	y=readcsv(filename)
	L=zeros(length(y))
	B=zeros(length(y))
	F=zeros(length(y))
	L[1]=y[1]
	B[1]=0

	for t=2:length(y)
		L[t]= α*y[t] + (1-α)* (L[t-1] +B[t-1])
		B[t]=β*(L[t]-L[t-1])+(1-β)* B[t-1]
		F[t]=L[t-1]+B[t-1]
	end
	
	denum=length(y)-1
	
	mySum=0
	for t=2:length(y)
		if(y[t]==0.0)
			continue
		end
		mySum+=abs((y[t]-F[t])/y[t])
	end
	
	# MAPE=sum(abs((y[2:end]-F[2:end])/y[2:end]))/denum
	MAPE = mySum/denum
	return MAPE
end
	
	
	
	
function bestAlphaBeta(filename)
	bestα=0.0
	bestβ=0.0
	bestMAPE = holtlinear(filename,bestα,bestβ)
	i=0.0
	while i<=1
		j=0.0
		while j<=1
			MAPE2 = holtlinear(filename,i,j)
			if MAPE2<bestMAPE
				bestMAPE=MAPE2
				bestα=i
				bestβ=j
			end
			j=j+0.001
		end
		i=i+0.001
		println(i)
	end
	return bestα,bestβ,bestMAPE
end
a,b,c= bestAlphaBeta("test.csv")
println("alpha ",a)
println("beta ",b)
println("MAP ",c)