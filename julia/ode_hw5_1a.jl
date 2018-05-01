using DifferentialEquations;
using PyPlot;

k = rand();

f(t, x) = k*x - x^3;

tspan = (0.0, 10.0);

for x0 in [-3*sqrt(k)/2; -sqrt(k)/2; -0.01*sqrt(k); 0.01*sqrt(k); sqrt(k)/2; 3*sqrt(k)/2]
  prob = ODEProblem(f, x0, tspan);
  sol = solve(prob, Vern9());
  plot(sol.t, sol.u / sqrt(k), "b-");
end

xlabel("\$t\$");
ylabel("\$x / \\sqrt{k}\$");
title("\$\\dot{x} = k x - x^3, k > 0\$");
show();
