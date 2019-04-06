module RAS

using LinearAlgebra

"""
TODO: docstrings
Multi-dimensional RAS algorithm as described in 
https://arxiv.org/pdf/1704.07814.pdf
"""
function ras(seed::Array{<:Number, D}, 
             margins::Array{<:Array{<:Number, D}, 1}, 
             max_iters::Int64=100, 
             tol::Float64=1e-10) where {D}
  X = seed
  iter = 0
  while iter < max_iters && norm([norm(margins[d] - sum(X, dims=d)) for d in 1:D]) > tol
    for d = 1:D
      X = X .* (margins[d] ./ sum(X, dims=d))
    end
    iter += 1
  end
  return X
end

export ras

end # module
