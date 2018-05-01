using PyPlot;

fname = ARGS[1];
sections = split(split(fname, '.')[1], '_');
params = [];
for i=2:4
  push!(params, parse(split(sections[i], '-')[2]));
end
data = readdlm(fname, ',');

println("minimum(p_x)   =   ", minimum(data[:, 1]));
println("maximum(p_x)   =   ", maximum(data[:, 1]));
println("minimum(p_y)   =   ", minimum(data[:, 2]));
println("maximum(p_y)   =   ", maximum(data[:, 2]));
println("minimum(theta) =   ", minimum(data[:, 3]));
println("maximum(theta) =   ", maximum(data[:, 3]));
println("minimum(U)     =   ", minimum(data[:, 4]));
println("maximum(U)     =   ", maximum(data[:, 4]));

subplot(111; projection="3d");
scatter(data[:, 1], data[:, 2], data[:, 3]; s=20, c=data[:, 4]);
xlabel("\$p_x\$");
ylabel("\$p_y\$");
zlabel("\$\\theta\$");
title("\$\\kappa_1 = $(params[1]/10), \\kappa_2 = $(params[2]/10), "*
      "\\beta = $(params[3] / 1000)\$");
colorbar();
show();
