macro add_ints(x::Int, y::Int)
  return :($x + $y);
end

println(@add_ints(3,5));
println(@add_ints(-3,10));
println(@add_ints(-3,-5));
println(@add_ints(3,69));
