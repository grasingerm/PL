using PyPlot;

markers = ["x", "o", "v", "^", "<", ">", "8", "s", "p", "D", "|", "_"];

function fp(f::Function, x0::Real; eps::Real = 1e-3, iters::Int = 100,
            do_plot::Bool=false)
  xs = zeros(iters);
  xs[1] = x0;
  iter = 1;
  while iter < iters
    xs[iter+1] = f(xs[iter]);
    iter += 1;
    if abs(xs[iter] - xs[iter-1]) < eps
      break;
    end
  end
  xs = xs[1:iter];
  if do_plot
    max_x = ceil(maximum(xs));
    min_x = floor(minimum(xs));
    ys = map(x -> f(x), xs);
    if iter <= 12
      for i=1:iter
        plot(xs[i], ys[i], markers[i]; label="iter $i");
      end
    else
      max_x = ceil(maximum(xs[(iter-11):iter]));
      min_x = floor(minimum(xs[(iter-11):iter]));
      marker_idx = 1;
      for i=(iter-11):iter
        plot(xs[i], ys[i], markers[marker_idx]; label="iter $i");
        marker_idx += 1
      end
    end
    axs = linspace(min_x, max_x, 100);
    ays = map(f, axs);
    plot(axs, ays, "-"; label="f(x)");
    plot(axs, axs, "--"; label="x");
    legend(; bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.0);
    show();
  end
  return xs;
end

fp(x -> sin(x), pi / 4; iters = 25, do_plot=true);
fp(x -> sin(x), 3 * pi / 4; iters = 25, do_plot=true);
fp(x -> cos(x), 3 * pi / 4; iters = 25, do_plot=true);
