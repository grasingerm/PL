#include <stdio.h>

#define N 1000

__global__ void MatAdd(float A[N][N], float B[N][N], float C[N][N]) {
  int i = threadIdx.x;
  int j = threadIdx.y;
  C[i][j] = A[i][j] + B[i][j];
}

int main() {
  float a[N][N];
  float b[N][N];
  float c[N][N];

  int i, j;
  for (i = 0; i < N; ++i) {
    for (j = 0; j < N; ++j) {
      a[i][j] = 3.0 * i - 7.0 * j * j;
      b[i][j] = (double) i / (double) j;
    }
  }

  size_t size = N * N * sizeof(float);

  float* d_A;
  cudaMalloc(&d_A, size);
  float* d_B;
  cudaMalloc(&d_B, size);
  float* d_C;
  cudaMalloc(&d_C, size);

  cubaMemcpy(d_A, a, size, cudaMemcpyHostToDevice);
  cubaMemcpy(d_B, b, size, cudaMemcpyHostToDevice);

  int numBlocks = 1;
  dim3 threadsPerBlock(N, N);
  MatAdd<<<numBlocks, threadsPerBlock>>>(a, b, c);

  cudaMemcpy(c, d_C, size, cudaMemcpyDeviceToHost);
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);

  for (i = 0; i < N; ++i) {
    for (j = 0; j < N; ++j) {
      printf("%.3lf + %.3lf = %.3lf\n", a[i][j], b[i][j], c[i][j]);
    }
  }

  return 0;
}
