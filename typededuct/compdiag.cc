template<typename T> class TD;

int main(void)
{
  const int answer = 42;

  auto x = answer;
  auto y = &answer;

  TD<decltype(x)> xtype;
  TD<decltype(y)> ytype;

  return 0;
}
