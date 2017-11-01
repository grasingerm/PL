include("vec.jl");

A = [0.0 1.0 0.0; -1.0 0.0 0.0; 0.0 0.0 0.0];
R = eye(3, 3) + A;

u = [1.0; 1.0; 1.0];
subplot(111, projection="3d");
Ru = R*u;
eAu = exp_map(A)*u;
D, V = eig(A);
println("u = $u, ||u|| = $(norm(u, 2))");
println("Ru = $Ru, ||Ru|| = $(norm(Ru, 2))");
println("exp(A)u = $eAu, ||exp(A)u|| = $(norm(eAu, 2))");
println("det(exp(A)) = $(det(exp_map(A)))");
plot_vec_3d(u; label="u");
plot_vec_3d(Ru; label="Ru");
plot_vec_3d(eAu; label="exp(A)u");
plot_vec_3d(map(x -> real(x), V[:, 3]); label="\$\theta\$");
legend();
show();
