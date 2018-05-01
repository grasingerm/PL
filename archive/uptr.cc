#include <cstdio>
#include <memory>
#include <utility>

int main ()
{
  double* pa = new double;
  double* pb = new double;

  *pa = 6.9;
  *pb = 0.69;

  auto upa = std::unique_ptr <double> (pa);
  auto upb = std::unique_ptr <double> (pb);

  printf ("a = %lf, b = %lf\n", *upa, *upb);

  upa.swap (upb);

  printf ("a = %lf, b = %lf\n", *upa, *upb);

  upa.reset (upb.release ());

  printf ("a = %lf\n", *upa);

  return 0;
}
