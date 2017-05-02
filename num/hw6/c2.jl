analytical_soln(x::Real, y::Real) = cos(x) * sin(y);

force(x::Real, y::Real) = -2.0 * cos(x) * sin(y);

function conjugate_gradient(h::Real; tol::Real=1e-7, max_iterations::Int=10000)
  # initialize data
  const start_time = time();
  for iteration = 1:max_iterations
    # check for convergence
    if #converged
      return , iteration, time() - start_time, true;
    end
  end
  return grid, max_iterations, time() - start_time, false;
end

for h in [0.1; 0.05; 0.025]
  println("Conjugate gradient, h = ", h);
  grid_approx_soln, iterations, time_elapsed, did_converge = conjugate_gradient(h);
  println("   time elapsed:     ", time_elapsed);
  println("   iterations:       ", iterations);
  println("   sec/iteration:    ", time_elapsed / iterations);
  println("   converged:        ", (did_converge) ? "true" : "false");
  grid_analytical_soln = Grid(h, analytical_soln);
  println("   rel. L2 error:    ", 
          norm(grid_analytical_soln.us - grid_approx_soln.us, 2) / 
          norm(grid_analytical_soln.us, 2));
  println();
end
