#include <stdio.h>

struct st
{
  float a;
  float b[10];
} *ST;

#ifdef __cplusplus
  extern "C" struct st *MYCOMMON(void);
  extern "C" void FCTN(void);
#else
  fortran struct st *MYCOMMON(void);
  fortran void FCTN(void);
#endif

int main() {
  int i;

  ST = MYCOMMON();
  ST->a = 1.0;
  for (i = 0; i < 10; ++i)
    ST->b[i] = i+2;
  printf("\n in C and C++\n");
  printf("  a = %5.1f\n", ST->a);
  printf("  b = ");
  for (i = 0; i < 10; ++i)
    printf("%5.1f ", ST->b[i]);
  printf("\n\n");

  FCTN();
}
