using PyPlot;

term(n, z) = (-1)^n * z^(2*n + 1) / ((2*n + 1) * factorial(n));

zs = collect(1:3);
approxs = Float64[];
for z in zs
  push!(approxs, 
        @parallel (+) for i = 0:4
          term(i, z);
        end);
end
approx2s = pmap(z -> begin
               return 1.0 - exp(-z^2) / (z*sqrt(pi)) * (1.0 - 1.0 / (2. * z^2)
                            + 3. / (4. * z^4));
               end, zs)

plot(zs, map(erf, zs), "-sk", zs, approxs, "--Dk", zs, approx2s, "-.*k");
legend(["Exact"; "Taylor approx."; "By parts"]);
xlabel("\$z\$");
ylabel("\$Erf(z)\$");
ylim([0.0; 2.0]);
show();
