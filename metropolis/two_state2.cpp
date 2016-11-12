#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <time.h>
#include <iomanip>
#include <random>
#include <array>
using namespace std;

int main() {
  default_random_engine rng;
  uniform_int_distribution<size_t> choice_dist(0, 1);
  uniform_int_distribution<size_t> trial_dist(0, 1);
  uniform_real_distribution<double> eps_dist(0.0, 1.0);
  rng.seed(random_device()());
  std::array<int, 2> xs;
  std::array<std::array<int, 2>, 4> ics;
  ics[0] = {0, 0};
  ics[1] = {1, 0};
  ics[2] = {0, 1};
  ics[3] = {1, 1};
  std::array<int, 3> ntrials = { 10000, 100000, 1000000 };
  std::array<double, 5> betas = { 0.01, 0.1, 1.0, 10.0, 100.0 };

  for (auto ic : ics) {
    for (auto beta : betas) {
      for (auto ntrial : ntrials) {
        xs = ic;
        double sum_u=0;

        for (int i=0; i<ntrial; i++){
          sum_u += xs[0] + xs[1] + xs[0]*xs[1];

          int trial_move = trial_dist(rng);
          int choice = choice_dist(rng);

          double dU = (choice == 0) ?
            (trial_move - xs[0]) + (trial_move - xs[0]) * xs[1] :
            (trial_move - xs[1]) + (trial_move - xs[1]) * xs[0];

          if (dU < 0) {
            xs[choice] = trial_move;
          } else {
            double B = exp(-beta * dU);
            if (eps_dist(rng) < B) 
              xs[choice] = trial_move;
          }
        }
        sum_u += xs[0] + xs[1] + xs[0]*xs[1];

        double u_avg=sum_u/ntrial;

        cout << "ntrial   =   " << ntrial <<endl;
        cout << "beta     =   " << beta <<endl;
        cout << "ic       =   " << ic[0] << ", " << ic[1] <<endl;
        cout << "<U>      =   " << u_avg <<endl;
      }
    }
  }
	return 0;
}
