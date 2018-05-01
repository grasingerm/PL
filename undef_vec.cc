#include <vector>
#include <iostream>

int main ()
{
    std::vector < int > v = {0, 0};
    int i = 0;
    v[i++] = i++;
    std::cout << v[0] << v[1] << std::endl;

    return 0;
}