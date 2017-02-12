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
    ys = map(f, xs);
    axs = linspace(min_x, max_x, 100);
    ays = map(f, axs);
    plot(axs, ays, "-"; label="analytical")
    if iter <= 12
      for i=1:iter
        plot(xs[i], ys[i], markers[i]; label="iter $i");
      end
    else
      for i=(iter-12):iter
        plot(xs[i], ys[i], markers[i]; label="iter $i");
      end
    end
    legend();
    show();
  end
  return xs;
end

fp(x -> sin(x) - x, pi / 4; iters = 10, do_plot=true);
fp(x -> sin(x) - x, 3 * pi / 4; iters = 10, do_plot=true);
fp(x -> cos(x) - x, 3 * pi / 4; iters = 10, do_plot=true);
