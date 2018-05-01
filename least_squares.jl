using PyPlot;

A = [1.0 1.0; 2.0 1.0; 3.0 1.0; -1.0 1.0; 0.0 1.0];
b = [1.0; 2.0; 2.0; -1.5; 1.1];

c = (A'*A) \ (A'*b);
fit(x) = c[1]*x + c[2];

scatter(A[:, 1], b);
xs = linspace(minimum(A[:, 1]), maximum(A[:,1]), 100);
plot(xs, map(fit, xs));
show();
