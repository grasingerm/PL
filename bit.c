#include <stdio.h>

#define array_length(arr) (sizeof(arr)/sizeof((arr)[0]))

void print_bits(unsigned int num)
{
  unsigned int i;
  unsigned int size = sizeof (unsigned int);
  unsigned int max_pow = 1 << (size*8-1);

  for(i = 0; i < size*8; ++i)
  {
    // print last bit and shift left.
    printf("%u ", num & max_pow ? 1 : 0);
    num = num << 1;
  }
}

int main ()
{
  unsigned int cs[] = { 8, 4, 2, 7, 132, 94, 251354 };
  int i, j, asize = array_length (cs);

  for (i = 0; i < asize; i++)
  {
    for (j = i; j < asize; j++)
    {
      printf ("%u & %u = %u\n", cs [i], cs [j], cs [i] & cs [j]);
      print_bits (cs [i]);
      fputs (" & ", stdout);
      print_bits (cs [j]);
      fputs (" = ", stdout);
      print_bits (cs [i] & cs [j]);
      puts ("\n");

      printf ("%u | %u = %u\n", cs [i], cs [j], cs [i] | cs [j]);
      print_bits (cs [i]);
      fputs (" | ", stdout);
      print_bits (cs [j]);
      fputs (" = ", stdout);
      print_bits (cs [i] | cs [j]);
      puts ("\n");

      printf ("%u ^ %u = %u\n", cs [i], cs [j], cs [i] ^ cs [j]);
      print_bits (cs [i]);
      fputs (" ^ ", stdout);
      print_bits (cs [j]);
      fputs (" = ", stdout);
      print_bits (cs [i] ^ cs [j]);
      puts ("\n");

      printf ("~%u = %u\n", cs [i], ~cs [i]);
      fputs ("~ ", stdout);
      print_bits (cs [i]);
      fputs (" = ", stdout);
      print_bits (~cs [i]);
      puts ("\n");

      printf ("%u << %u = %u\n", cs [i], cs [j], cs [i] << cs [j]);
      print_bits (cs [i]);
      fputs (" << ", stdout);
      print_bits (cs [j]);
      fputs (" = ", stdout);
      print_bits (cs [i] << cs [j]);
      puts ("\n");

      printf ("%u >> %u = %u\n", cs [i], cs [j], cs [i] >> cs [j]);
      print_bits (cs [i]);
      fputs (" >> ", stdout);
      print_bits (cs [j]);
      fputs (" = ", stdout);
      print_bits (cs [i] >> cs [j]);
      puts ("\n");
    }
  }

  return 0;
}
