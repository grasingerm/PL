using PyPlot;

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
