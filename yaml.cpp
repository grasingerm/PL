#include "yaml-cpp/yaml.h"
#include <iostream>

using namespace std;

int main() {
  auto test = YAML::LoadFile("test.yaml");
  cout << test << '\n';
  cout << '\n';

  for (const auto &data : test)
    cout << data.first << ": " << data.second << '\n';

  return 0;
}
