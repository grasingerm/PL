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
