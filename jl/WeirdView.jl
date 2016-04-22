type WeirdView{T}
  a::Vector{T}
  x::Real

  WeirdView(a::Vector{T}, x::Real) = new(a, x);
end

Base.getindex(vw::WeirdView, i::Int) = vw.a[i] * vw.x; 
