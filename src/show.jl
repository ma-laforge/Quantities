#Quantities show functions
#-------------------------------------------------------------------------------

#==Generate friendly show functions
===============================================================================#
#_sh: shorthand

#Base.string{T}(q::Type{Unit{T}}) = "$T"
_shunit{T}(q::Type{Unit{T}}) = "$T"

_shstring{QT<:QuantityType}(::Type{QT}) = split(string(QT), '.')[end]

#Return the name of the quantity associated with this type:
#(Assumes last 4 characters are simply "Type"):
_quantstr{QT<:QuantityType}(::Type{QT}) = _shstring(QT)[1:end-4]

function Base.show{T,QT,U}(io::IO, q::Quantity{T,QT,U})
	strt = _quantstr(QT)
	print(io, "$strt{$T}($(q.v) $(_shunit(U)))")
end

#Last line

