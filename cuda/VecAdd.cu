#include <stdio.h>

__global__ void VecAdd(double* A, double* B, double* C, int N) {
  int i = blockDim.x * blockIdx.x + threadIdx.x;
  if (i < N)
    C[i] = A[i] + B[i];
}

#define N 10000

int main() {
  double a[N];
  double b[N];
  double c[N];

  int i;
  for (i = 0; i < N; ++i) {
    a[i] = 3.0*(double)i - 11.4;
    b[i] = 42.0 / ((double)i);
  }

  size_t s = N * sizeof(double);

  double* da;
  cudaMalloc((void**)&da, s);
  double* db;
  cudaMalloc((void**)&db, s);
  double* dc;
  cudaMalloc((void**)&dc, s);

  cudaMemcpy(da, a, s, cudaMemcpyHostToDevice);
  cudaMemcpy(db, b, s, cudaMemcpyHostToDevice);

  int threadsPerBlock = 256;
  int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
  VecAdd<<<blocksPerGrid, threadsPerBlock>>>(da, db, dc, N);

  cudaMemcpy(c, dc, s, cudaMemcpyDeviceToHost);
  
  for (i = 0; i < 10000; ++i) {
    printf("%.3lf + %.3lf = %.3lf\n", a[i], b[i], c[i]);
  }
  
  cudaFree(da);
  cudaFree(db);
  cudaFree(dc);

  return 0;
}
