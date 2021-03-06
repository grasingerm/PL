#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <time.h>
#include <iomanip>
#include <random>
using namespace std;

int main() {
  default_random_engine rng;
  uniform_int_distribution<size_t> choice_dist(0, 1);
  uniform_real_distribution<double> eps_dist(0.0, 1.0);
  rng.seed(random_device()());

	int NTRIAL=10000000;
	double sum_u=0;
	double sum_x=0;

	double x=0;
	double u=0;
	double N=0;

	for (int i=0;i<NTRIAL;i++){
		sum_u=sum_u+u;
		sum_x=sum_x+x;

		double delta=double(rand())/RAND_MAX-0.5;
		double xtrial=x+delta;
		double utrial=xtrial*xtrial;
		if (utrial<=u) {
			x=xtrial;
			u=utrial;
		} else {
			double B=exp(-5*(utrial-u));
			double epsilon=double(rand())/RAND_MAX;
			if (epsilon<B) {
				x=xtrial;
				u=utrial;
			}
		}
	}

	sum_u=sum_u+u;
	sum_x=sum_x+x;

	double u_avg=sum_u/NTRIAL;
	double x_avg=sum_x/NTRIAL;
	double x2_avg=u_avg;

	cout << u_avg <<endl;
	cout << x_avg <<endl;
	cout << x2_avg <<endl;
	return 0;
}
