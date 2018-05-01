#import Roots

const ϕ   =   (1 + sqrt(5)) / 2;
const ψ   =   (1 - sqrt(5)) / 2;

fibs      =   zeros(1000); fibs[1] = 1; fibs[2] = 1;
for i=3:1000; fibs[i] = fibs[i-1] + fibs[i-2]; end
fib(n)    =   fibs[n];
fiba(n)   =   1.0 / sqrt(5.0) * (ϕ^n - ψ^n);

for n = 1:1000
  @assert(abs(fib(n) - fiba(n)) / fib(n) < 1e-9, "Analytical solution wrong");
end

println("Tests passed for fibanocci analytical solution.");

function Σ_fib(n)
  sum = 0;
  for i=1:n-1
    sum += fib(i);
  end
  return sum;
end

function Σ_fib_even(n)
  sum = 0;
  for i=1:n-1
    fibi = fib(i);
    if fibi % 2 == 0
      sum += fibi;
    end
  end
  return sum;
end

function Σ_fib_odd(n)
  sum = 0;
  for i=1:n-1
    fibi = fib(i);
    if fibi % 2 != 0
      sum += fibi;
    end
  end
  return sum;
end

Σ_fiba(n)       = 1 / sqrt(5) * ( (1-ϕ^n)/(1-ϕ) - (1-ψ^n)/(1-ψ) );
Σ_fiba_even(n)  = 1 / sqrt(5) * ( (1-ϕ^n)/(1-ϕ^3) - (1-ψ^n)/(1-ψ^3) );
Σ_fiba_odd(n)   = Σ_fiba(n) - Σ_fiba_even(n);

for n = 1:100
  Σ_fibn    =   Σ_fib(n);
  Σ_fiban   =   Σ_fiba(n);
  @assert(Σ_fibn == 0.0 || abs(Σ_fibn - Σ_fiban)/Σ_fibn < 1e-9, "Analytical solution is wrong");
end

println("Tests passed for fibanocci sum analytical solution.");

for n = 3:3:78
  Σ_fibn    =   Σ_fib_even(n);
  Σ_fiban   =   Σ_fiba_even(n);
  @assert(Σ_fibn == 0.0 || abs(Σ_fibn - Σ_fiban)/Σ_fibn < 1e-9, "Analytical solution is wrong");
  #println(Σ_fibn, " == ", Σ_fiban, "?");
end

println("Tests passed for fibanocci sum even analytical solution.");

for n = 3:3:78
  Σ_fibn    =   Σ_fib_odd(n);
  Σ_fiban   =   Σ_fiba_odd(n);
  @assert(Σ_fibn == 0.0 || abs(Σ_fibn - Σ_fiban)/Σ_fibn < 1e-9, "Analytical solution is wrong");
  #println(Σ_fibn, " == ", Σ_fiban, "?");
end

println("Tests passed for fibanocci sum odd analytical solution.");

function sum_unit_seq(a, b)
  sum = 0;
  for i=a:b
    sum += i;
  end
  return sum;
end

sum_unit_seqa(a, b) = (b + a) * (b - a + 1) / 2;

for k=1:100
  x = rand(-100:100);
  y = rand(-100:100);
  a = min(x, y);
  b = max(x, y);

  @assert(abs(sum_unit_seq(a, b) - sum_unit_seqa(a, b)) < 1e-12);
end

println("Tests passed for sum of a unit sequence analytical solution.");

function Σ_fib_even_lt(f_max)
  f0    =   0;
  f1    =   1;
  fn    =   f1 + f0;
  sum   =   0;
  while fn < f_max
    if fn % 2 == 0
      sum   +=    fn;
    end
    f0  =   f1;
    f1  =   fn;
    fn  =   f1 + f0;
  end
  return sum;
end

const lnψ = log(abs(ψ));
const lnϕ = log(ϕ);
ifiba(f)  =   log(sqrt(5.0) * f) / log(ϕ);
approx_ψ_xth_power(x) = -1 - x*lnψ - 1/2*x^2*lnψ^2 -1/6*x^3*lnψ^3 - 1/24*x^4*lnψ^4 - 1/120*x^5*lnψ^5 - 1/720*x^6*lnψ^6; 
function R(f, n)
  return f - 1/sqrt(5.0) * (ϕ^n - approx_ψ_xth_power(n));
end
function dR(f, n)
  return 1/sqrt(5.0) * (ϕ^n * log(ϕ) - approx_ψ_xth_power(n) * lnψ);
end

function ifib_newton(f; ϵ=1e-5, max_steps=Int=1000, α=1.0)
  if f == 0.0; return 0; end
  n   =   round(ifiba(f));
  info("Initial guess for n = $n");
  for step=1:max_steps
    n0   =    n;
    n   -=    α * R(f, n) / dR(f, n);
    info("Step = $step; New n = $n");
    if abs(n - n0) / abs(n) < ϵ
      return round(n);
    end
  end
  return round(n);
end

function ifib_rough(f)
  return round(ifiba(f));
end

function Σ_fib_even_lta(f)
  n   =   ifib_rough(f);
  return  Σ_fiba_even(n - n % 3 + 3);
end

Σ_fib_even_lt(18);  # make sure code is compiled before profiling
Σ_fib_even_lta(18);

@time sum0  =   Σ_fib_even_lt(4e6);
println("Brute force method: $sum0");
@time sum1  =   Σ_fib_even_lta(4e6);
println("Analytical method: $sum1");

@time sum0  =   Σ_fib_even_lt(8e8);
println("Brute force method: $sum0");
@time sum1  =   Σ_fib_even_lta(8e8);
println("Analytical method: $sum1");
