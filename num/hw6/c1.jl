analytical_soln(x::Real, y::Real) = cos(x) * sin(y);

force(x::Real, y::Real) = -2.0 * cos(x) * sin(y);

type Grid
  nx::Int
  ny::Int
  us::Matrix{Float64}
  xs::Matrix{Float64}
  ys::Matrix{Float64}

  function Grid(h::Real)
    n = Int(round(1/h) + 1);
    xs = Matrix{Float64}(n, n);
    ys = Matrix{Float64}(n, n);
    for (j, y) in zip(1:n, 0.0:h:1.0), (i, x) in zip(1:n, 0.0:h:1.0)
      xs[i, j] = x;
      ys[i, j] = y;
    end
    return new(n, n, zeros(n, n), xs, ys);
  end

  function Grid(h::Real, analytical_soln::Function)
    n = Int(round(1/h) + 1);
    xs = Matrix{Float64}(n, n);
    ys = Matrix{Float64}(n, n);
    us = Matrix{Float64}(n, n);
    for (j, y) in zip(1:n, 0.0:h:1.0), (i, x) in zip(1:n, 0.0:h:1.0)
      xs[i, j] = x;
      ys[i, j] = y;
      us[i, j] = analytical_soln(x, y);
    end
    return new(n, n, us, xs, ys);
  end

  Grid(grid::Grid) = new(grid.nx, grid.ny, copy(grid.us), copy(grid.xs),
                         copy(grid.ys));
end

function copy_grid_values!(dest::Grid, src::Grid)
  copy!(dest.us, src.us);
end

function enforce_bcs!(grid::Grid)
  for j=1:grid.ny
    grid.us[1, j] = analytical_soln(grid.xs[1, j], grid.ys[1, j]); 
    grid.us[grid.nx, j] = analytical_soln(grid.xs[grid.nx, j], 
                                          grid.ys[grid.nx, j]); 
  end
  
  for i=2:grid.nx-1
    grid.us[i, 1] = analytical_soln(grid.xs[i, 1], grid.ys[i, 1]); 
    grid.us[i, grid.ny] = analytical_soln(grid.xs[i, grid.ny], 
                                          grid.ys[i, grid.ny]); 
  end
end

function jacobi(h::Real; tol::Real=1e-7, max_iterations::Int=10000)
  grid = Grid(h);
  next_grid = Grid(grid);
  const start_time = time();
  for iteration = 1:max_iterations
    enforce_bcs!(next_grid);
    for j=2:grid.ny-1, i=2:grid.nx-1
      next_grid.us[i, j] = (grid.us[i-1, j] + grid.us[i+1, j] + 
                            grid.us[i, j-1] + grid.us[i, j+1] - 
                            h*h*force(grid.xs[i, j], grid.ys[i, j])) / 4.0;
    end
    if norm(next_grid.us - grid.us, 2) < tol
      return next_grid, iteration, time() - start_time, true;
    end
    copy_grid_values!(grid, next_grid);
  end
  return grid, max_iterations, time() - start_time, false;
end

function gauss_seidel(h::Real; tol::Real=1e-7, max_iterations::Int=10000)
  grid = Grid(h);
  next_grid = Grid(grid);
  const start_time = time();
  for iteration = 1:max_iterations
    enforce_bcs!(next_grid);
    for j=2:grid.ny-1, i=2:grid.nx-1
      # use updated neighboring values
      next_grid.us[i, j] = (next_grid.us[i-1, j] + next_grid.us[i+1, j] + 
                            next_grid.us[i, j-1] + next_grid.us[i, j+1] - 
                            h*h*force(grid.xs[i, j], grid.ys[i, j])) / 4.0;
    end
    if norm(next_grid.us - grid.us, 2) < tol
      return next_grid, iteration, time() - start_time, true;
    end
    copy_grid_values!(grid, next_grid);
  end
  return grid, max_iterations, time() - start_time, false;
end

function SOR(h::Real; tol::Real=1e-7, max_iterations::Int=10000)
  const omega = 2.0 / (1.0 + pi * h);
  grid = Grid(h);
  next_grid = Grid(grid);
  const start_time = time();
  for iteration = 1:max_iterations
    enforce_bcs!(next_grid);
    for j=2:grid.ny-1, i=2:grid.nx-1
      # use updated neighboring values
      next_grid.us[i, j] += omega * (
                           (next_grid.us[i-1, j] + next_grid.us[i+1, j] + 
                            next_grid.us[i, j-1] + next_grid.us[i, j+1] - 
                            h*h*force(grid.xs[i, j], grid.ys[i, j])) / 4.0 -
                           next_grid.us[i, j]);
    end
    if norm(next_grid.us - grid.us, 2) < tol
      return next_grid, iteration, time() - start_time, true;
    end
    copy_grid_values!(grid, next_grid);
  end
  return grid, max_iterations, time() - start_time, false;
end

for (method_str, approx_method) in [("Jacobi iterative solution", jacobi);
                                    ("Gauss-Seidel iterative solution", gauss_seidel);
                                    ("SOR iterative solution", SOR)]
  for h in [0.1; 0.05; 0.025]
    println(method_str, ", h = ", h);
    grid_approx_soln, iterations, time_elapsed, did_converge = approx_method(h);
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
end
