#include <iostream>
#include <vector>

using namespace std;

inline auto clear_last_bit(unsigned x) {
  return x & (x - 1);
}

inline auto lowest_set_bit(unsigned x) {
  return x & ~(x - 1);
}

auto ones_count(unsigned x) {
  auto ocount = 0;
  for (auto index = 0; index < 32; ++index) {
    if (0x1 & x) ++ocount;
    x = x >> 1;
  }

  return ocount;
}

auto count_bits_set(unsigned x) {
  auto count = unsigned{0};
  while (x) {
    x = clear_last_bit(x);
    ++count;
  }

  return count;
}

auto my_power_of_two(unsigned x) {
  auto once_fl = false;
  for (auto index = 0; index < 32; ++index) {
    if (0x1 & x) {
      if (once_fl)
        return false;
      else
        once_fl = true;
    }
    x = x >> 1;
  }

  return once_fl;
}

auto power_of_two(unsigned x) {
  if (!x) return false;
  return 0 == (x & (x-1));
}

int main() {
  vector<unsigned> xs({2, 4, 1, 11, 39, 28, 16, 32, 128, 2048});
  for (auto x : xs) {
    cout << "x = " << x << "; bits_set = " << count_bits_set(x) <<
            "; power of two? = " << power_of_two(x) << ", " << 
            my_power_of_two(x) << '\n';
  }
  return 0;
}
