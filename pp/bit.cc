#include <iostream>

inline auto clear_last_bit(unsigned x) {
  return x & (x - 1);
}

inline auto lowest_set_bit(unsigned x) {
  return x & ~(x - 1);
}

auto fold_over(unsigned x) {
  x |= (x >> 1);
  x |= (x >> 2);
  x |= (x >> 4);
  x |= (x >> 8);
  x |= (x >> 16);
  return x;
}

auto highest_set_bit(unsigned x) {
  x = fold_over(x);
  return (x & ~(x >> 1));
}

auto log_2(unsigned x) {
  x = x - 1;
  x = fold_over(x);
  x = x + 1;
  for (auto index = 0; index < 32; ++index)
    if (x == (0x1 << index)) return index;

  return 0;
}

auto multiply(const int x, int y) {
  int product = 0;
  while (y) {
    product += x << log_2(lowest_set_bit(y));
    y = clear_last_bit(y);
  }

  return product;
}

using namespace std;

int main() {
  cout << "fold_over(1) = " << fold_over(1) << ", highest_set_bit(1) = " << 
          highest_set_bit(1) << '\n';
  cout << "fold_over(2) = " << fold_over(2) << ", highest_set_bit(2) = " << 
          highest_set_bit(2) << '\n';
  cout << "fold_over(4) = " << fold_over(4) << ", highest_set_bit(4) = " << 
          highest_set_bit(4) << '\n';
  cout << "fold_over(8) = " << fold_over(8) << ", highest_set_bit(8) = " << 
          highest_set_bit(8) << '\n';
  cout << "fold_over(18) = " << fold_over(18) << ", highest_set_bit(18) = " << 
          highest_set_bit(18) << '\n';

  cout << '\n';
  
  cout << "log_2(4) = " << log_2(4) << '\n';
  cout << "log_2(48) = " << log_2(48) << '\n';
  cout << "log_2(1003204) = " << log_2(1003204) << '\n';
  cout << "log_2(15) = " << log_2(15) << '\n';

  cout << '\n';

  cout << "2 * 4 = " << multiply(2, 4) << '\n';
  cout << "8 * 3 = " << multiply(8, 3) << '\n';
  cout << "99 * 34 = " << multiply(99, 34) << '\n';
  cout << "1 * 4 = " << multiply(1, 4) << '\n';

  return 0;
}
