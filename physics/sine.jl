using PyPlot;

f(θ) = sin(2*θ);
f1(θ) = 2*θ;
f2(θ) = 2*θ - 4*θ^3/3;
f3(θ) = 2*θ - 4*θ^3/3 + 4*θ^5/15;
f4(θ) = 2*θ - 4*θ^3/3 + 4*θ^5/15 - (2*θ)^7 / (factorial(7));
g(θ) = 1 - 2*(θ-pi/4)^2
g2(θ) = -1 + 2*(θ-3*pi/4)^2

xs = 0:0.1:pi;
plot(xs, map(f, xs), xs, map(f1, xs), xs, map(f2, xs), xs, map(f3, xs));
plot(xs, map(f4, xs), xs, map(g, xs), xs, map(g2, xs));
legend(["sin2\$\\theta\$", "1st Ord.", "3nd Ord.", "5rd Ord.", "7th Ord.", "2nd about \$\\pi/4\$", "2nd about \$3\\pi/4\$"]);
ylim([-2.0,2.0]);
show();
