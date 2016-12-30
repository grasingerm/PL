include("element.jl");

f(x, y) = x * y;
g(x, y) = x + y;
h(x, y) = x^2 + y^2;

println("xy = ", quad_2p2d(f));
println("x + y = ", quad_2p2d(g));
println("x^2 + y^2 = ", quad_2p2d(h));
println(quad_2p2d((x, y) -> 4*x^2 * y^2 - 3*x + 4.0));

@assert(abs(quad_2p2d(f) - 0.0) < 1e-12);
@assert(abs(quad_2p2d(g) - 0.0) < 1e-12);
@assert(abs(quad_2p2d(h) - 8.0 / 3.0) < 1e-12);
@assert(abs(quad_2p2d((x, y) -> 4*x^2 * y^2 - 3*x + 4.0) - 160.0 / 9.0) < 1e-12);
