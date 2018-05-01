using PyPlot;

function simpsons(f::Function, a::Real, b::Real, n::Int)
  @assert(n % 2 == 0, "Number of intervals must be even");
  const h::Float64 = (b - a) / n;
  fs = pmap(f, a:h:b);

  sum::Float64 = fs[1] + fs[end];
  
  for i=2:2:n
    sum += 4.0 * fs[i];
  end

  for i=3:2:n-1
    sum += 2.0 * fs[i];
  end

  return h * sum / 3.0;
end

#=
f(x) = x^2;
g(x) = x^3;
h(x) = x - 1;

println("Integral of x^2 from 0 to 1 (n = 2) = ", simpsons(f, 0, 1, 2));
println("Integral of x^2 from 0 to 1 (n = 10) = ", simpsons(f, 0, 1, 10));
println("Integral of x^2 from -1 to 1 (n = 2) = ", simpsons(f, -1, 1, 2));
println("Integral of x^2 from -1 to 1 (n = 10) = ", simpsons(f, -1, 1, 10));
println("Integral of x-1 from 0 to 1 (n = 2) = ", simpsons(h, 0, 1, 2));
println("Integral of x-1 from 0 to 1 (n = 10) = ", simpsons(h, 0, 1, 10));
println("Integral of x-1 from -1 to 1 (n = 2) = ", simpsons(h, -1, 1, 2));
println("Integral of x-1 from -1 to 1 (n = 10) = ", simpsons(h, -1, 1, 10));
println("Integral of x^3 from 0 to 1 (n = 2) = ", simpsons(g, 0, 1, 2));
println("Integral of x^3 from 0 to 1 (n = 10) = ", simpsons(g, 0, 1, 10));
println("Integral of x^3 from -1 to 1 (n = 2) = ", simpsons(g, -1, 1, 2));
println("Integral of x^3 from -1 to 1 (n = 10) = ", simpsons(g, -1, 1, 10));
println("Integral of x^4 from 0 to 10 (n = 2) = ", simpsons(x -> x^4, 0, 10, 2));
println("Integral of x^4 from 0 to 10 (n = 100000) = ", simpsons(x -> x^4, 0, 10, 100000));
=#

function fourier(f::Function, L::Real, ncoeffs::Int; nint::Int=1000)
  coeffs = Array{Float64}(ncoeffs);
  for m=1:ncoeffs
    coeffs[m] = (1.0 / L * 
                 simpsons(x -> f(x) * sin(m * π * x / L), -L/2.0, L/2.0, nint));
  end

  return x -> begin
    return @parallel (+) for n = 1:ncoeffs
      coeffs[n] * sin(n * π * x / L);
    end;
  end;
end

@everywhere s(x) = (x > 0) ? 1.0 : -1.0;
@everywhere L = 5.0;
@everywhere xs = linspace(-L/2.0, L/2.0, 100);
ss = pmap(s, xs);
fs2 = pmap(fourier(s, L, 5), xs);
fs3 = pmap(fourier(s, L, 10), xs);
fs4 = pmap(fourier(s, L, 15), xs);
fs5 = pmap(fourier(s, L, 20), xs);
fs6 = pmap(fourier(s, L, 100), xs);

plot(xs, ss, xs, fs2, xs, fs3, xs, fs4, xs, fs5, xs, fs6);
legend(["square wave", "fourier, n = 5", "fourier, n = 10", "fourier, n = 15",
        "fourier, n = 20", "fourier, n = 100"]; loc=2);
