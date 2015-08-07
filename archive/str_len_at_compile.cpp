#include <cstdio>

int constexpr length(const char* str)
{
    return *str ? 1 + length(str + 1) : 0;
}

int main()
{
    printf("%d %d\n", length("abcd"), length("abcdefgh"));
    return 0;
}
