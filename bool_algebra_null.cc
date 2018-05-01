#include <iostream>

int main()
{
  if (nullptr)
    std::cout << "nullptr is true?\n";
  else
    std::cout << "nullptr is false!\n";

  void* p = nullptr;

  if (!p)
    std::cout << "nullptr is not true!\n";
  else
    std::cout << "nullptr is not not true?\n";

  return 0;
}
