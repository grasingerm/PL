#include "stdlib.h"
#include "stdio.h"

int main(int argc, char* argv[])
{
    char c;
    unsigned char uc;
    
    short int si;
    unsigned short int usi;
    
    int i;
    unsigned int ui;
    
    long int li;
    unsigned long int uli;
    
    long long int lli;
    unsigned long long int ulli;
    
    float f;
    double d;
    long double ld;
    
    void* p;
    
    printf("%40s: %4d\n", "Size of char", sizeof(c));
    printf("%40s: %4d\n", "Size of unsigned char", sizeof(uc));
    printf("\n");
    
    printf("%40s: %4d\n", "Size of short int", sizeof(si));
    printf("%40s: %4d\n", "Size of unsigned short int", sizeof(usi));
    printf("\n");
    
    printf("%40s: %4d\n", "Size of int", sizeof(i));
    printf("%40s: %4d\n", "Size of unsigned int", sizeof(ui));
    printf("\n");
    
    printf("%40s: %4d\n", "Size of long int", sizeof(li));
    printf("%40s: %4d\n", "Size of unsigned long int", sizeof(uli));
    printf("\n");
    
    printf("%40s: %4d\n", "Size of long long int", sizeof(lli));
    printf("%40s: %4d\n", "Size of unsigned long long int", sizeof(ulli));
    printf("\n");
    
    printf("%40s: %4d\n", "Size of float", sizeof(f));
    printf("%40s: %4d\n", "Size of double", sizeof(d));
    printf("%40s: %4d\n", "Size of long double", sizeof(ld));
    printf("\n");
    
    printf("%40s: %4d\n", "Size of pointer", sizeof(p));
    printf("\n");
    
    return 0;
}
