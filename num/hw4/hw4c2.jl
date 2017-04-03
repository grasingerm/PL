include("hw4_helpers.jl");

a = 1.0;
b = 1.0;

for h in [1/10; 1/20; 1/40]
  xs = linspace(-1.0, 1.0, Int(round((2.0) / h)));
  ts = linspace(0.0, 1.0, Int(round(1.0 / k)));
  const M, K = length(xs), length(ts);

  u = zeros(M, K);
  #fix this: u[:, 1] = map(x -> sin(π * x), xs);
  
  for n in 1:K-1
    for m=1:M
      u[m, n+1] = p[m+1] * u[m+1, n+1] + q[m+1];
    end
  end

  plot_solution(xs, ts, u; t="Viscous Burgers', \$h = $h\$", show_plot=false,
                           fname="cn_thomas_M-$M.png");
end
