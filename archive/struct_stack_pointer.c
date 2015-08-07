#include <stdio.h>

struct yolo
{
  int a;
  int b;
};

struct yolo y;
struct yolo* py = &y;

void print_yolo (struct yolo* y)
{
  printf("a: %d, b: %d\n", y->a, y->b);
}

int main ()
{
  py->a = 4;
  py->b = 3;

  print_yolo (py);

  return 0;
}