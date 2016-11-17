#include <iostream>
#include <vector>
#include <string>

int main() {
  std::vector<std::string> words = { "Yolo", "Nolo", "Foo" };
  for (const auto& word : words) std::cout << word << '\n';
  return 0;
}
