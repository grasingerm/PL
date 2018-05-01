#include <vector>
#include <iostream>

using bigint = std::vector<unsigned char>;

bigint operator+(const bigint& lhs, const bigint& rhs) {
  bigint sum;
  auto carry = 0;

  auto push_term = [&carry, &sum] (unsigned char lhs, unsigned char rhs) {
    unsigned int value = lhs + rhs + carry;
    unsigned char term = value & 0xff;
    carry = (value - term) ? 1 : 0;
    sum.emplace(sum.begin(), term);
  };

  auto lhs_itr = lhs.rbegin();
  auto rhs_itr = rhs.rbegin();
  while (lhs_itr != lhs.rend() && rhs_itr != rhs.rend())
    push_term(*lhs_itr++, *rhs_itr++);

  while (lhs_itr != lhs.rend()) push_term(*lhs_itr++, 0);
  while (rhs_itr != rhs.rend()) push_term(*rhs_itr++, 0);

  if (carry) push_term(0, 0);
  return sum;
}

int main() {
  bigint a { {5, 0, 2, 4} };
  bigint b { {6, 0, 2, 8} };

  bigint c = a + b;
  //auto citr = c.rbegin();
  //while (citr != c.rend()) std::cout << static_cast<unsigned>(*citr++);
  for (auto ci : c) std::cout << static_cast<unsigned>(ci);
  std::cout << '\n';

  return 0;
}
