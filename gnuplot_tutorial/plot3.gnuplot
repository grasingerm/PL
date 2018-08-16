theta(t) = theta0 + a * exp(-t / tau) * sin(2 * pi * t / T + phi)

a = 40
tau = 15
phi = -0.5
T = 15
theta0 = 10

fit theta(x) "cavendish.data" using 1:2:3 via a, tau, phi, T, theta0
plot "cavendish.data" title "" with yerrorbars, theta(x) title "Model"
