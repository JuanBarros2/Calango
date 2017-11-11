#include <iostream>

using namespace std;

struct Animal {
  int life = 0;
  int hunger = 0;
  int energy = 0;
  int evolution = 0;
  int bathroom = 0;
  bool isSleep = false;
};
typedef struct Animal Animal ;

int main(){
    Animal animal;
    cout << animal.hunger;
    return 0;
}
