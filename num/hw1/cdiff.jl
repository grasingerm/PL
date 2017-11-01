function cdiff(f::Function, d::Function, h::Real)
  max_error = 0.0;
  for x in (0.0+h):h:1.0
    x_error = abs(d(x) - (f(x + h) - f(x - h)) / (2 * h));
    if x_error > max_error
      max_error = x_error
    end
  end
  return max_error
end

f1(x) = sin(2 * pi * x);
df1(x) = 2 * pi * cos(2 * pi * x);

f2(x) = x^(3.0/2.0);
df2(x) = 1.5 * sqrt(x);

println("Central difference error, sin(2 pi x)\n");
println("h error");
println("-------");
for h in [0.1; 0.01; 0.001; 0.0001; 0.00001; 0.000001]
    println("$h $(cdiff(f1, df1, h))"); 
end

println("\nCentral difference error, x^(3/2)\n");
println("h error");
println("-------");
for h in [0.1; 0.01; 0.001; 0.0001; 0.00001; 0.000001]
    println("$h $(cdiff(f2, df2, h))"); 
end

function trap(f::Function, F::Function, h::Real)
  sum = 0.5 * (f(0.0) + f(1.0));
  for x in (0.0+h):h:(1.0-h)
    sum += f(x);
  end
  return abs(F(1.0) - F(0.0) - h * sum);
end

F1(x) = -cos(2 * pi * x) / (2 * pi);
F2(x) = 2.0 * x^(5/2) / 5.0;

println("\nTrapezoidal rule error, sin(2 pi x)\n");
println("h error");
println("-------");
for h in [0.1; 0.01; 0.001; 0.0001; 0.00001; 0.000001]
    println("$h $(trap(f1, F1, h))"); 
end

println("\nTrapezoidal rule error, x^(3/2)\n");
println("h error");
println("-------");
for h in [0.1; 0.01; 0.001; 0.0001; 0.00001; 0.000001]
    println("$h $(trap(f2, F2, h))"); 
end
