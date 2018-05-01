#include "world.hpp"
#include <vector>
#include <string>
#include <iostream>

using namespace std;

vector<string> words = { "Yolo", "Nolo", "hello..." };

void say_stuff() {
  for (const auto& word : words) cout << word << ' '; 
  cout << '\n';
}
