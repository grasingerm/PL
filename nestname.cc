#include <iostream>

namespace ns1
{

namespace ns2
{

void foo() { std::cout << "ns1::ns2::foo()\n"; }

} // namespace ns1

} // namespace ns2


int main()
{
  ns1::ns2::foo();
  using namespace ns1::ns2;
  foo();
  return 0;
}
