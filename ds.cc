#include <stack>
#include <queue>
#include <iostream>
#include <string>

using namespace std;

int main() {
  stack<string> s;
  s.push(string("this is a stack"));
  s.push(string("one"));
  s.push(string("two"));
  cout << "Popping off stack...\n";
  while (!s.empty()) {
    cout << s.top() << "\n";
    s.pop();
  }

  queue<int> q;
  for (int i = -1; i < 10; ++i) q.push(i);
  cout << "Queue front, first value entered in queue = " << q.front() << '\n';
  cout << "Queue back, last value entered in queue = " << q.back() << '\n';
  cout << "Popping off queue...\n";
  while (!q.empty()) {
    cout << q.front() << "\n";
    q.pop();
  }

  return 0;
}
