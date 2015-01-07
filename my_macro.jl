macro my_macro(x::Int, y::Int)
  return (x+y);
end

macro N1_Q4(xi::Real, eta::Real)
  return ((1-(xi))*(1-(eta))/4.);
end

println("3+5 = ");
println(@my_macro(3,5));
println("N1 at -0.5, -0.5 = ", @N1_Q4(-0.5,-0.5));
println("N1 at -1, -1 = ", @N1_Q4(-1,-1));
@assert(false, "this was suppose to fail, dummy");
