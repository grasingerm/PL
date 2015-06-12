#include <stdio.h>

int main()
{
  FILE* fp;

  fp = fopen("file.txt", "w");

  fprintf(fp, "%s\n", "this is a super fun text file!");
  fflush(fp);

  fclose(fp);

  return 0;
}
