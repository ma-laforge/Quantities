#Quantities: A Julian way to deal with quantities of arbitrary units
#-------------------------------------------------------------------------------

module Quantities

include("base.jl")
include("show.jl")


#==Exported symbols
===============================================================================#
export Length, Dist, Position

#Useful typealiases (sadly, names conflict with constructors):
export _Length, _Dist, _Position

#Accessor functions:
export value #High-collision WARNING: other modules probably want to export "value"

end

#Last line

