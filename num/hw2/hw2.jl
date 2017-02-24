using PyPlot;

#! Approximate the solution to an ODE using Euler's method
#!
#! \param   dfx     Differential equation, dfx = dfx(x,y,t)
#! \param   x0      Initial value of x
#! \param   dfy     Differential equation, dfy = dfy(x,y,t)
#! \param   y0      Initial value of x
#! \param   t0      Initial value of t
#! \param   tf      Final value of t
#! \param   nsteps  Number of timesteps
#! \return          Discrete ts, xs, and ys
function forward_euler(dfx::Function, x0::Real, dfy::Function, y0::Real,
                       t0::Real, tf::Real, nsteps::Int)
  const h   =   (tf - t0) / nsteps;
  xs        =   zeros(nsteps+1);
  ys        =   zeros(nsteps+1);
  ts        =   zeros(nsteps+1);
  xs[1]     =   x0;
  ys[1]     =   y0;
  ts[1]     =   t0;

  for i=1:nsteps
    xs[i+1] = xs[i] + h * dfx(xs[i], ys[i], ts[i]);
    ys[i+1] = ys[i] + h * dfy(xs[i], ys[i], ts[i]);
    ts[i+1] = ts[i] + h;
  end

  return ts, xs, ys;
end

#! Approximate the solution to an ODE using Euler's method
#!
#! \param   dfx     Differential equation, dfx = dfx(x,y,t)
#! \param   x0      Initial value of x
#! \param   dfy     Differential equation, dfy = dfy(x,y,t)
#! \param   y0      Initial value of x
#! \param   t0      Initial value of t
#! \param   tf      Final value of t
#! \param   nsteps  Number of timesteps
#! \return          Discrete ts, xs, and ys
function backward_euler(dfx::Function, x0::Real, dfy::Function, y0::Real,
                        t0::Real, tf::Real, nsteps::Int; iters::Int = 25,
                        tol::Real = 1e-3)
  const h   =   (tf - t0) / nsteps;
  xs        =   zeros(nsteps+1);
  ys        =   zeros(nsteps+1);
  ts        =   zeros(nsteps+1);
  xs[1]     =   x0;
  ys[1]     =   y0;
  ts[1]     =   t0;

  for i=1:nsteps
    x = xs[i];
    y = ys[i];
    ts[i+1]  = ts[i] + h;
    for k=1:iters
      xs[i+1] = xs[i] + h * dfx(x, y, ts[i+1]);
      ys[i+1] = ys[i] + h * dfy(x, y, ts[i+1]);
      if norm([xs[i+1] - x; ys[i+1] - y], 2) / norm([x, y], 2) < tol
        break;
      end
      x = xs[i+1];
      y = ys[i+1];
    end
  end

  return ts, xs, ys;
end

#! \param   dfx     Differential equation, dfx = dfx(x,y,t)
#! \param   x0      Initial value of x
#! \param   dfy     Differential equation, dfy = dfy(x,y,t)
#! \param   y0      Initial value of x
#! \param   t0      Initial value of t
#! \param   tf      Final value of t
#! \param   nsteps  Number of timesteps
#! \return          Discrete ts, xs, and ys
function runge_kutta_2(dfx::Function, x0::Real, dfy::Function, y0::Real,
                       t0::Real, tf::Real, nsteps::Int)
  const h   =   (tf - t0) / nsteps;
  xs        =   zeros(nsteps+1);
  ys        =   zeros(nsteps+1);
  ts        =   zeros(nsteps+1);
  xs[1]     =   x0;
  ys[1]     =   y0;
  ts[1]     =   t0;

  for i=1:nsteps
    kx1       =   xs[i] + h / 2 * dfx(xs[i], ys[i], ts[i]);
    ky1       =   ys[i] + h / 2 * dfy(xs[i], ys[i], ts[i]);

    xs[i+1]   =   xs[i] + h * dfx(kx1, ky1, ts[i] + h / 2);
    ys[i+1]   =   ys[i] + h * dfy(kx1, ky1, ts[i] + h / 2);
    
    ts[i+1]   =   ts[i] + h;
  end

  return ts, xs, ys;
end

# Problem 1
const eps = 0.01;
dfx(x, y, t) = eps * x - y;
dfy(x, y, t) = x + eps * y;
for steps in [10; 25; 250; 1000]
  ts, xs, ys = forward_euler(dfx, 1.0, dfy, 0.0, 0.0, 10.0, steps);
  plot(ts, xs; label="x(t)") 
  plot(ts, ys; label="y(t)");
  legend();
  title("Forward Euler, h = $(ts[2]-ts[1])");
  savefig("fe_$steps.png");
  clf();
end

for steps in [10; 25; 250; 1000]
  ts, xs, ys = backward_euler(dfx, 1.0, dfy, 0.0, 0.0, 10.0, steps);
  plot(ts, xs; label="x(t)"); 
  plot(ts, ys; label="y(t)");
  legend();
  title("Backward Euler, h = $(ts[2]-ts[1])");
  savefig("be_$steps.png");
  clf();
end

ts1, xs1, ys1 = forward_euler(dfx, 1.0, dfy, 0.0, 0.0, 10.0, 250);
ts2, xs2, ys2 = backward_euler(dfx, 1.0, dfy, 0.0, 0.0, 10.0, 250);
plot(ts1, xs1; label="x(t), forward"); 
plot(ts1, ys1; label="y(t), forward");
plot(ts2, xs2; label="x(t), back"); 
plot(ts2, ys2; label="y(t), back");
title("h = $(ts1[2]-ts1[1])");
legend();
savefig("compare_250.png");
clf();

# Test RK2 against forward euler
ts1, xs1, ys1 = forward_euler(dfx, 1.0, dfy, 0.0, 0.0, 10.0, 1000);
tsrk, xsrk, ysrk = runge_kutta_2(dfx, 1.0, dfy, 0.0, 0.0, 10.0, 1000);
println("||x_fe - x_rk2|| / ||x_fe|| = $(norm(xs1 - xsrk, 2) / norm(xs1, 2))");
println("||y_fe - y_rk2|| / ||y_fe|| = $(norm(ys1 - ysrk, 2) / norm(ys1, 2))");
plot(ts1, xs1; label="x(t), forward"); 
plot(ts1, ys1; label="y(t), forward");
plot(tsrk, xsrk; label="x(t), RK2"); 
plot(tsrk, ysrk; label="y(t), RK2");
title("h = $(ts1[2]-ts1[1])");
legend();
savefig("compare_fe-rk2_1000.png");
clf();

# Problem 2
const mu = 1.0
dfx_vdp(x, y, t) = y;
dfy_vdp(x, y, t) = mu * (1 - x*x) * y - x;

ts, xs, ys = runge_kutta_2(dfx_vdp, 5.0, dfy_vdp, 2.0, 0.0, 100.0, 10000);
plot(xs, ys);
title("RK2 approximation of Van der Pol oscillator");
savefig("rk2.png");
