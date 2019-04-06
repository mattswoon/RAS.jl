using QuickCheck, Test, RAS

function QuickCheck.generator(::Type{Array{Float64}}, size)
  # I keep getting out of memory or invalid size for arrays of 
  # dimensions higher than 10 - note, minimum 2 dimensions required
  D = abs(QuickCheck.generator(Int64, 8)) + 2
  return QuickCheck.generator(Array{Float64, D}, size)
end

"""
If you RAS an array to margins that are equal to the margins of the seed
you should simply get the seed
"""
function trivial_ras(x::Array{Float64})
  D = ndims(x)
  return ras(x, [sum(x, dims=d) for d in 1:D]) == x
end

"""
With a seed full of ones, the resulting array's margins should differ
from the input margins by less than tol=1e-10
"""
function equal_margins(x::Array{Float64})
  D = ndims(x)
  seed = ones(Float64, size(x)...)
  margins = [sum(x, dims=d) for d in 1:D]
  y = ras(seed, margins)
  return all(abs.(x .- y) .< 1e-10)
end

condproperty(trivial_ras, 100, 1000, x -> all(x .> 0))
condproperty(equal_margins, 100, 1000, x -> all(x .> 0))
