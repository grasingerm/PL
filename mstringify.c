#include <stdio.h>

#define M_STRINGIFY(text) "implicitly concat with " #text

int main ()
{
  puts (M_STRINGIFY(coco_the_monkey));
  return 0;
}
