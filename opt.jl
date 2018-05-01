using Optim

f(x) = 3 * sin(x) - cos(1 / (x^2 + 1)) + x^2 / 16

result1 = optimize(f, -50.0, 50.0, Optim.Brent());
println("minimizer1: $(Optim.minimizer(result1))");
println("minimum1: $(Optim.minimum(result1))");

result2 = optimize(f, -50.0, 50.0, Optim.GoldenSection());
println("minimizer2: $(Optim.minimizer(result2))");
println("minimum2: $(Optim.minimum(result2))");
