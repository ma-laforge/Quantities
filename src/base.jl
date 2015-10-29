#Quantities base types & core functions
#-------------------------------------------------------------------------------


#==Main data structures
===============================================================================#
abstract Unit{Symbol} #Think this might be too much

abstract QuantityType
#==TODO: How to limit Units to supported units?
It would be nice to flag an error when people write :M, instead of :m...
==#
typealias Meter Unit{:m}
typealias Kilogram Unit{:kg}
typealias Inch Unit{:in}
typealias Radians Unit{:rad}
typealias Degrees Unit{:deg}
typealias RadiansPerSecond Unit{:rad_s}
typealias Hertz Unit{:Hz}

immutable Quantity{T<:Number, QuantityType, Unit} #<: Number
	v::T
end
value(q::Quantity) = q.v

#==NOTE:
It would probably be bad to inherit Quantity from Number(Quantity <: Number)
If that happens, how would Julia deal with the recursive structure:
    Quantity{Quantity{Quantity...}} ?
==#


#==Specific quantities
===============================================================================#
abstract AbstractLengthType <: QuantityType
abstract LengthType <: AbstractLengthType
abstract DistType <: AbstractLengthType
#==AbstractLength: Meter is known as a "unit of length"... even though the
actual thing measured might be a length, distance, position, ....
So, "AbstractLength" refers to any quantity measured in "unit of length".
==#

#==Useful aliases
===============================================================================#
typealias _Length{T<:Number, U<:Unit} Quantity{T,LengthType,U}
typealias _Dist{T<:Number, U<:Unit}   Quantity{T,DistType,U}

#==Problem:
 -"type Length" permits you to create constructor function "Length",
  but "typealias Length" *conflicts* with constructor function "Length"
  (TODO: Can this behaviour be changed in Julia?)
==#


#==Constructor functions
===============================================================================#
Length{T<:Number}(v::T, u::Symbol) = Quantity{T,LengthType, Unit{u}}(v)
Dist{T<:Number}(v::T, u::Symbol) = Quantity{T,DistType, Unit{u}}(v)


#==Support basic math operations
===============================================================================#
#Operators that interoperate with other (same) Quantities
const _operators_self = Symbol[:-, :+]

#Operators that interoperate with Number-s
const _operators_num = Symbol[:/, :*]

#const _operators = vcat(_operators_num, _operators_self)
#_dotop(x)=Symbol(".$x")

for op in _operators_self; @eval begin

#Quantity op Quantity
function Base.$op{T1<:Number,T2<:Number,QT<:QuantityType,U<:Unit}(q1::Quantity{T1,QT,U}, q2::Quantity{T2,QT,U})
	return Quantity{promote_type(T1,T2),QT,U}($op(q1.v, q2.v))
end

end; end

for op in _operators_num; @eval begin

#Quantity op Number
function Base.$op{TN<:Number,T<:Number,QT<:QuantityType,U<:Unit}(q::Quantity{T,QT,U}, n::TN)
	return Quantity{promote_type(T,TN),QT,U}($op(q.v, n))
end

#Number op Quantity
function Base.$op{TN<:Number,T<:Number,QT<:QuantityType,U<:Unit}(n::TN, q::Quantity{T,QT,U})
	return Quantity{promote_type(T,TN),QT,U}($op(n, q.v))
end

end; end


#Last line
