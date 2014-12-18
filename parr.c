#include <stdio.h>

void swap (void*, void*);

#define ARRAY_SIZE 5
#define BUFFER_SIZE 128

int main ()
{
  char* s = "this is a string";
  char s1[7] = {'t', 'h', 'i', 's', ' ', 'i', 's' };
  *(s1+16) = '\n';

  printf ("%s", s1);

  return 0;
}
