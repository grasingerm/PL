#include <iostream>
#include <vector>

class Animal
{
public:
  virtual void speak() const = 0;
  void eat() const { std::cout << "Yummm nummm numm \n"; }
  virtual void walk() const = 0;
};

class Cat : public Animal {
public:
  void speak() const { std::cout << "Meow...\n"; }
  void eat() const { std::cout << "I'm a cat eating...\n"; }
  void walk() const { std::cout << "walking softly...\n"; }
};

class Dog : public Animal {
public:
  void speak() const { std::cout << "Wolf..\n"; }
  void eat() const { std::cout << "I'm a dog eating...\n"; }
  void walk() const { std::cout << "running..\n"; }
};

int main(){
  std::vector<Animal*> pets;
  pets.reserve(5);

  pets.push_back(new Cat);
  pets.push_back(new Cat);
  pets.push_back(new Dog);
  pets.push_back(new Dog);
  pets.push_back(new Cat);

  //std::cout << "Let's speak\n";
  //for (const auto& ppet : pets) ppet->speak();
  std::cout << "Let's eat\n";
  for (const auto& ppet : pets) ppet->eat();
  //std::cout << "Let's go for a walk\n";
  //for (const auto& ppet : pets) ppet->walk();

  for (const auto& ppet : pets) delete ppet;
  
  return 0;
}
