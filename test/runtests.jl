#Test code
#-------------------------------------------------------------------------------

#No real test code yet... just run demos:

using Quantities
Q=Quantities

typealias AbstractLength{T<:Number, QT<:Q.AbstractLengthType, U<:Q.Unit} Q.Quantity{T,QT,U}
typealias Length_m{T}                   Q.Quantity{T,Q.LengthType,Q.Meter}

#Sample data:
#-------------------------------------------------------------------------------
l1m=Length(1.5, :m)
l2m=Length(1.2, :m)
d1m=Dist(5, :m)
d2m=Dist(8.01, :m)
l1in=Dist(55, :in)
d1in=Dist(83.01, :in)
inch=Length(1, :in)

#g(x::AbstractLength) = "CATCHALL: AbstractLength"
#==Problems:
 -Although above expression works, ::AbstractLength generates signatures that
  conflict with almost all declarations below
  NOTE: Not sure what the reason is for this, because you CAN do a proper
  catchall (see below).
==#

#Catchall that works:
g{T,QT<:Q.AbstractLengthType,U}(x::Q.Quantity{T,QT,U}) = "AbstractLength{ANY}"

g{T,QT<:Q.AbstractLengthType}(x::Q.Quantity{T,QT,Q.Meter}) = "AbstractLength{:m}"
g{T,QT<:Q.AbstractLengthType}(x::Q.Quantity{T,QT,Q.Inch}) = "AbstractLength{:in}"
g(x::Length_m) = "Length{:m}"
g{T}(x::_Length{T, Q.Unit{:in}}) = "_Length{:in}"
#g{T}(x::Q.Quantity{T, Q.LengthType, Q.Inch}) = "Length{:in}" #Equiv to previous


symbollist = [:l1m, :l2m, :d1m, :d2m, :l1in, :d1in]
for symb in symbollist
	val = eval(symb)
	print("$symb => ", )
		show(val)
		println()
end

valuelist = [eval(symb) for symb in symbollist]
for val in valuelist
	print("g($val) => ", g(val))
		println()
end

@show g(Length(3.3, :in))
@show g(Dist(3.8, :MYTYPE))

println("\nA few mathematical operations...")
@show d1m, d2m
@show d1m+d2m
@show d1m+d1m
@show 3*d1m
@show d1m*4.0
@show 5inch
@show 11.3inch
@show value(l1m)

:Test_Complete
