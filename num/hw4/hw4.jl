using PyPlot;

const λ = 1.0;
const a = 1.0;

function plot_solution(xs, ts, us::Matrix{Float64}; t::String="", 
                       fname::String="", show_plot::Bool=false)

  plot(xs, us[:, 1], "k-"; label=@sprintf("\$t = %.3f\$", ts[1]));
  plot(xs, us[:, div(length(ts), 2)], "k--"; label=@sprintf("\$t = %.3f\$", 
                                                     ts[div(length(ts), 2)]));
  plot(xs, us[:, end], "k-."; label=@sprintf("\$t = %.3f\$", ts[end]));
  legend(; loc=3);
  if t != ""
    title(t);
  end
  xlabel("x");
  ylabel("u");
  if show_plot
    show();
  end
  if fname != ""
    savefig(fname);
  end
  clf();
end

for h in [1/10; 1/20; 1/40]
  const k = λ * h;
  const aa = -a * λ / 4;
  const bb = 1.0;
  const cc = -aa;

  xs = linspace(-1.0, 1.0, Int(round((2.0) / h)));
  ts = linspace(0.0, 1.0, Int(round(1.0 / k)));
  const M, K = length(xs), length(ts);

  u = zeros(M, K);
  u[:, 1] = map(x -> sin(π * x), xs);

  for n in 1:K-1
    # calculate pi and qi for Thomas' algorithm
    p = zeros(M);
    q = zeros(M);
    p[1], q[1] = 0.0, sin(π * (-1 - ts[n]));
    for m in 2:M-1
      dd = u[m, n] - a * λ * (u[m+1, n] - u[m-1, n]) / 4;
      denom = aa * p[m-1] + bb;
      p[m] =  -cc / denom;
      q[m] = (dd - aa * q[m-1]) / denom;
    end
    #dd = u[M, n];
    #denom = -λ * p[M-1] + bb
    u[M, n+1] = u[M-1, n];
    for m in M-1:-1:2
      u[m, n+1] = p[m] * u[m+1, n] + q[m];
    end
    u[1, n] = sin(π * (-1 - ts[n]));
  end

  plot_solution(xs, ts, u; t="Crank-Nicolson, \$h = $h\$", show_plot=true);
end
