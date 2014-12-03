#include <cstdlib>
#include <cstdio>
#include <cstdint>

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
    
    printf("%40s: %4lu\n", "Size of char", sizeof(c));
    printf("%40s: %4lu\n", "Size of unsigned char", sizeof(uc));
    printf("\n");
    
    printf("%40s: %4lu\n", "Size of short int", sizeof(si));
    printf("%40s: %4lu\n", "Size of unsigned short int", sizeof(usi));
    printf("\n");
    
    printf("%40s: %4lu\n", "Size of int", sizeof(i));
    printf("%40s: %4lu\n", "Size of unsigned int", sizeof(ui));
    printf("\n");
    
    printf("%40s: %4lu\n", "Size of long int", sizeof(li));
    printf("%40s: %4lu\n", "Size of unsigned long int", sizeof(uli));
    printf("\n");
    
    printf("%40s: %4lu\n", "Size of long long int", sizeof(lli));
    printf("%40s: %4lu\n", "Size of unsigned long long int", sizeof(ulli));
    printf("\n");
    
    printf("%40s: %4lu\n", "Size of float", sizeof(f));
    printf("%40s: %4lu\n", "Size of double", sizeof(d));
    printf("%40s: %4lu\n", "Size of long double", sizeof(ld));
    printf("\n");
    
    printf("%40s: %4lu\n", "Size of pointer", sizeof(p));
    printf("\n");
    
    auto ui8 = uint8_t { 42 };
    auto ui16 = uint16_t { 42 };
    auto ui32 = uint32_t { 42 };
    auto ui64 = uint64_t { 42 };
    
    auto i8 = int8_t { 42 };
    auto i16 = int16_t { 42 };
    auto i32 = int32_t { 42 };
    auto i64 = int64_t { 42 };
    
    printf("%40s: %4lu\n", "Size of uint8_t", sizeof(ui8));
    printf("%40s: %4lu\n", "Size of uint16_t", sizeof(ui16));
    printf("%40s: %4lu\n", "Size of uint32_t", sizeof(ui32));
    printf("%40s: %4lu\n", "Size of uint64_t", sizeof(ui64));
    printf("\n");
    
    printf("%40s: %4lu\n", "Size of int8_t", sizeof(i8));
    printf("%40s: %4lu\n", "Size of int16_t", sizeof(i16));
    printf("%40s: %4lu\n", "Size of int32_t", sizeof(i32));
    printf("%40s: %4lu\n", "Size of int64_t", sizeof(i64));
    printf("\n");
    
    auto uli8 = uint_least8_t { 42 };
    auto uli16 = uint_least16_t { 42 };
    auto uli32 = uint_least32_t { 42 };
    auto uli64 = uint_least64_t { 42 };
    
    auto il8 = int_least8_t { 42 };
    auto il16 = int_least16_t { 42 };
    auto il32 = int_least32_t { 42 };
    auto il64 = int_least64_t { 42 };
    
    printf("%40s: %4lu\n", "Size of uint_least8_t", sizeof(uli8));
    printf("%40s: %4lu\n", "Size of uint_least16_t", sizeof(uli16));
    printf("%40s: %4lu\n", "Size of uint_least32_t", sizeof(uli32));
    printf("%40s: %4lu\n", "Size of uint_least64_t", sizeof(uli64));
    printf("\n");
    
    printf("%40s: %4lu\n", "Size of int_least8_t", sizeof(il8));
    printf("%40s: %4lu\n", "Size of int_least16_t", sizeof(il16));
    printf("%40s: %4lu\n", "Size of int_least32_t", sizeof(il32));
    printf("%40s: %4lu\n", "Size of int_least64_t", sizeof(il64));
    printf("\n");
    
    auto ufi8 = uint_fast8_t { 42 };
    auto ufi16 = uint_fast16_t { 42 };
    auto ufi32 = uint_fast32_t { 42 };
    auto ufi64 = uint_fast64_t { 42 };
    
    auto if8 = int_fast8_t { 42 };
    auto if16 = int_fast16_t { 42 };
    auto if32 = int_fast32_t { 42 };
    auto if64 = int_fast64_t { 42 };
    
    printf("%40s: %4lu\n", "Size of uint_fast8_t", sizeof(ufi8));
    printf("%40s: %4lu\n", "Size of uint_fast16_t", sizeof(ufi16));
    printf("%40s: %4lu\n", "Size of uint_fast32_t", sizeof(ufi32));
    printf("%40s: %4lu\n", "Size of uint_fast64_t", sizeof(ufi64));
    printf("\n");
    
    printf("%40s: %4lu\n", "Size of int_fast8_t", sizeof(if8));
    printf("%40s: %4lu\n", "Size of int_fast16_t", sizeof(if16));
    printf("%40s: %4lu\n", "Size of int_fast32_t", sizeof(if32));
    printf("%40s: %4lu\n", "Size of int_fast64_t", sizeof(if64));
    printf("\n");
    
    return 0;
}
