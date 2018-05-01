#include <random>
#include <iostream>
#include <cmath>
#include <array>

using namespace std;

inline double potential(const double x) { return x*x; }

int main() {
  const static double beta = 5.0;
  const array<double, 5> delta_maxs = {{0.05, 0.1, 0.5, 1.0, 5.0}};

  for (const auto& delta_max : delta_maxs) {
    size_t nsteps = 100;
    for (size_t k = 0; k < 6; ++k) {
      default_random_engine generator;
      uniform_real_distribution<double> delta_dist(-delta_max, delta_max);
      uniform_real_distribution<double> epsilon_dist(0.0, 1.0);

      double x = 0.0;
      double u = potential(x);

      double u_sum = 0.0;
      double x_sum = 0.0;
      double xsq_sum = 0.0;

      for (size_t k = 0; k < nsteps; ++k) {
        double delta = delta_dist(generator);
        double x_trial = x + delta;
        double u_trial = potential(x_trial);

        if (u_trial <= u) {
          x = x_trial;
          u = u_trial;
        }
        else {
          double epsilon = epsilon_dist(generator);
          double B = exp(-beta * (u_trial - u));
          if (epsilon <= B) {
            x = x_trial;
            u = u_trial;
          }
        }

        u_sum += u;
        x_sum += x;
        xsq_sum += x*x;
      }

      cout << "delta_max = " << delta_max << '\n';
      cout << "nsteps = " << nsteps << '\n';
      cout << "<U> = " << u_sum / nsteps << '\n';
      cout << "<x> = " << x_sum / nsteps << '\n';
      cout << "<x^2> = " << xsq_sum / nsteps << '\n';
      cout << '\n';

      nsteps *= 10;
    }
  }

  return 0;
}
