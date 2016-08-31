#include <iostream>
#include <string>
#include <unordered_set>

using namespace std;

int main () {
  unordered_set<string> first { {"red", "blue", "green", "red"} };
  unordered_set<string> second { {"blue", "red", "green"} };
  unordered_set<string> third { {"yellow", "blue", "green", "red", "black"} };

  cout << "first: ";
  for (auto& elem : first) cout << elem << " ";
  cout << '\n';

  cout << "second: ";
  for (auto& elem : second) cout << elem << " ";
  cout << '\n';

  cout << "third: ";
  for (auto& elem : third) cout << elem << " ";
  cout << '\n';

  cout << "first == second ? " << (first == second) << '\n';
  cout << "second == first ? " << (second == first) << '\n';
  cout << "first == third ? " << (first == third) << '\n';
  cout << "third == first ? " << (third == first) << '\n';
  cout << "second == third ? " << (second == third) << '\n';
  cout << "third == second ? " << (third == second) << '\n';
  cout << "third == third ? " << (third == third) << '\n';
  cout << "second == second ? " << (second == second) << '\n';

  return 0;
}
