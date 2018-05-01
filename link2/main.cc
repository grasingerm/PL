#include "src1.h"
#include "src2.h"
#include <stdio.h>

using namespace n;

int main() {
  printf("f1() = %lf\n", f1());
  printf("f2(6.9) = %lf\n", f2(6.9));
  printf("f2(f1()) = %lf\n", f2(f1()));

  return 0;
}
