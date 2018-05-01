#include <cstdio>

template<typename T, std::size_t N>
constexpr std::size_t arraySize(T (&)[N]) noexcept
{
  return N;
}

int main(void)
{
  int arr1[] = {1, 2, 3, 4, 5, 6, 7};
  char arr2[] = "This is a character array!";
  double arr3[] = {-0.4, -0.2, 0.0, 0.1, 0.2};

  printf("The size of `arr1` is %zu\n", arraySize(arr1));
  printf("The size of `arr2` is %zu\n", arraySize(arr2));
  printf("The size of `arr3` is %zu\n", arraySize(arr3));

  return 0;
}
