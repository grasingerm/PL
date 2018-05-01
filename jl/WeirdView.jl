type WeirdView{T}
  a::Vector{T};
  x::Real;

  WeirdView(a::Vector{T}, x::Real) = new(a, x);
end

Base.getindex(vw::WeirdView, i::Int) = vw.a[i] * vw.x;

type WeirdView2{T}
  a::Vector{T};
  f::Function;

  WeirdView2(a::Vector{T}, f::Function) = new(a, f);
end

Base.getindex(vw::WeirdView2, i::Int) = vw.f(vw.a[i]);

type WeirdView3{T,N}
  a::Array{T,N};
  f::Function;

  WeirdView3(a::Array{T,N}, f::Function) = new(a, f);
end

Base.getindex(vw::WeirdView3, idxs...) = vw.f(vw.a[idxs...]);
