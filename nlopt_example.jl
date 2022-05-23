using NLopt;

println("First example");
println("=============");

count = 0;

function myfunc(x::Vector, grad::Vector)
  if length(grad) > 0
    grad[1] = 0;
    grad[2] = .5 / sqrt(x[2]);
  end

  global count;
  count::Int += 1;
  println("f_$count($x)")

  sqrt(x[2]);
end

function myconstraint(x::Vector, grad::Vector, a, b)
  if length(grad) > 0
    grad[1] = 3a * (a*x[1] + b)^2;
    grad[2] = -1;
  end

  (a*x[1] + b)^3 - x[2]
end

opt = Opt(:LD_SLSQP, 2);
lower_bounds!(opt, [-100, 0.]);
upper_bounds!(opt, [100., 100.]);
xtol_rel!(opt, 1e-4);

min_objective!(opt, myfunc);
inequality_constraint!(opt, (x, g) -> myconstraint(x, g, 2, 0), 1e-8);
inequality_constraint!(opt, (x, g) -> myconstraint(x, g, -1, 1), 1e-8);

(minf, minx, ret) = optimize(opt, [1.234, 5.678]);
println("got $minf at $minx after $count iterations (return $ret)");
println();

println("Second example");
println("=============");

function myfunc2(x::Vector, grad::Vector)
  if length(grad) > 0
    grad[1] = -x[2];
    grad[2] = -x[1];
  end

  return -x[1]*x[2];
end

function myconstraint2(x::Vector, grad::Vector)
  if length(grad) > 0
    grad[1] = 2;
    grad[2] = 2;
  end

  return 2*x[1]+2*x[2] - 4;
end

opt = Opt(:LD_SLSQP, 2);
#lower_bounds!(opt, [-100, 0.]);
#upper_bounds!(opt, [100., 100.]);
xtol_rel!(opt, 1e-4);

min_objective!(opt, myfunc2);
equality_constraint!(opt, myconstraint2);

(minf, minx, ret) = optimize(opt, [0.0; 0.0]);
println("got $minf at $minx after $count iterations (return $ret)");
println();

println("Third example");
println("=============");

opt = Opt(:AUGLAG, 2);
local_opt = Opt(:LD_LBFGS, 2);
#lower_bounds!(opt, [-100, 0.]);
#upper_bounds!(opt, [100., 100.]);
xtol_rel!(opt, 1e-4);
xtol_rel!(local_opt, 1e-4);
opt.local_optimizer = local_opt;

min_objective!(opt, myfunc2);
equality_constraint!(opt, myconstraint2);

(minf, minx, ret) = optimize(opt, [0.0; 0.0]);
println("got $minf at $minx after $count iterations (return $ret)");
println();
