macro my_macro(x::Int, y::Int)
  return (x+y);
end

macro N1_Q4(xi::Real, eta::Real)
  return ((1-(xi))*(1-(eta))/4.);
end

macro ndebug()
  return true;
end

macro dprint()
  return quote
    if @ndebug
      println("we're not debugging, dickbag");
    else
      println("we're debugging???");
    end
  end
end

println("3+5 = ");
println(@my_macro(3,5));
println("N1 at -0.5, -0.5 = ", @N1_Q4(-0.5,-0.5));
println("N1 at -1, -1 = ", @N1_Q4(-1,-1));

if @ndebug
  println("fuck you");
else
  println("nawh brah, nawh");
end

@dprint
