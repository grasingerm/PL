#include "stdio.h"

void g()
{
    int a;
    printf("%d\n", a);
}

void f()
{
    int b = 7;
}

int main()
{
    f();
    g();
    return 0;
}
