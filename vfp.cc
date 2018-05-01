#include <iostream>
#include <vector>

using namespace std;

void hello_world(const char* name) { cout << "hello " << name << '\n'; }
void eat_shit(const char* name) { cout << "eat shit, " << name << '\n'; }
void best(const char* name) { cout << "you're the best, " << name << '\n'; }

int main() {
  vector<void (*)(const char*)> phrases;
  phrases.push_back(&hello_world);
  phrases.push_back(&eat_shit);
  phrases.push_back(&best);

  for (const auto& p : phrases) p("matt");

  return 0;
}
