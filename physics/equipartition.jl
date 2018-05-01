harmonic_potential(k::Real, x::Real) = 0.5 * k * x*x;

function metropolis_accept(u0::Real, u1::Real, beta::Real)
  if u1 <= u0
    return true;
  else
    return (rand() < exp(-beta * (u1 - u0)));
  end
end

if length(ARGS) != 5
  error("Five arguments required. x0, k, beta, nsteps, and delta");
end

x0 = parse(ARGS[1]);
k = parse(ARGS[2]);
beta = parse(ARGS[3]); 
nsteps = parse(ARGS[4]); 
delta = parse(ARGS[5]); 

xsum = 0.0;
xsqsum = 0.0;
esum = 0.0;

x = x0;
u = harmonic_potential(k, x);

for step = 1:nsteps
  xtrial = x + rand([-delta; delta]);
  utrial = harmonic_potential(k, xtrial);
  if metropolis_accept(u, utrial, beta)
    x = xtrial;
    u = utrial;
  end
  xsum += x;
  xsqsum += x*x;
  esum += u;
end

exp_x = xsum / nsteps;
exp_xsq = xsqsum / nsteps;
println("<x>    = $(exp_x)");
println("<x^2>  = $(exp_xsq)");
println("Δx     = $(sqrt(exp_xsq - exp_x^2))");
println("<E>    = $(esum / nsteps)");
println("1/2β   = $(1 / (2*beta))");
