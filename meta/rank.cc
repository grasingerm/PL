#include <iostream>

template<class T>
struct rank { static constexpr size_t value = 0u; };

template<class U, size_t N>
struct rank<U[N]> {
  static constexpr size_t value = 1u + rank<U>::value;
};

int main()
{
  using array_t = int[10][20][30];
  std::cout << "Rank of array_t = " << rank<array_t>::value << '\n';

  return 0;
}
