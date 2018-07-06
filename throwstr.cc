#include <iostream>
#include <stdexcept>

using namespace std;

int main() {
  cout << "I'm going to throw an exception, nerd.\n";
  throw runtime_error("yolo sauce");

  return 0;
}
