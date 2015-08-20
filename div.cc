#include <cstdio>

int main()
{
  int a = 8;
  int b = 3;

  printf("%d / %d = %d\n", a, b, a / b);
  printf("%lf / %d = %lf\n", static_cast<double>(a), b,
         static_cast<double>(static_cast<double>(a) / b));
  printf("%d / %lf = %lf\n", a, static_cast<double>(b),
         static_cast<double>(a / static_cast<double>(b)));
  printf("%lf / %lf = %lf\n", static_cast<double>(a), static_cast<double>(b),
         static_cast<double>(a) / static_cast<double>(b));

  return 0;
}
