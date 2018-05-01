#include <iostream>
#include <vector>
#include <thread>
#include "ballin_prof.hh"

double seqsum(const double*, const size_t);
double dcsum(const double*, const size_t);

using namespace std;

int main() {
  const size_t n = 100;
  vector<double> v1(n);
  for (size_t i = 0; i < n; ++i) v1[i] = i;

  cout << "Sequential sum of v1...\n";
  tic();
  double res1 = seqsum(v1.data(), n);
  toc();
  cout << res1 << "\n\n";

  cout << "Divide and conquer sum of v1...\n";
  tic();
  double res2 = dcsum(v1.data(), n);
  toc();
  cout << res2 << "\n\n";

  const size_t n2 = 10000;
  vector<double> v2(n2);
  for (size_t i = 0; i < n2; ++i) v2[i] = i;

  cout << "Sequential sum of v2... ";
  tic();
  res1 = seqsum(v2.data(), n2);
  toc();
  cout << res1 << "\n\n";

  cout << "Divide and conquer sum of v2... ";
  tic();
  res2 = dcsum(v2.data(), n2);
  toc();
  cout << res2 << "\n\n";

  return 0;
}

double seqsum(const double* start, const size_t N) {
  double sum = 0;
  for (size_t i = 0; i < N; ++i) sum += start[i];
  return sum;
}

double dcsum(const double* start, const size_t N) {
  if (N == 1) return *start;

  const size_t mid = N / 2;
  const size_t rem = N - mid;
  return dcsum(start, mid) + dcsum(start + mid, rem); 
}
