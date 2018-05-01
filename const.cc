int main()
{
  double x = 4.2;
  double y = 1.1;
  const double *px1 = &x;           // This is a pointer to a const double
  *px1 = 3.2;                       // Error: this would not compile
  px1 = &y;                         // This is ok
  double const *px2 = &x;           // Same case
  double* const px3 = &x;           // This is a const pointer to a double
  *px3 = 3.33333;                   // This is ok
  px3 = &y;                         // this will not compile
  const double* const px4 = &x;     // This is a const pointer to a const double

  return 0;
}
