
#include <iostream>
#include <string>

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

int menu() {
   cout << "=== SELECIONE UMA OPÇÃO ===" << endl << endl;
   cout << "1- Alimentar" << endl
        << "2- Levar ao banheiro" << endl
        << "3- Dormir" << endl
        << "4 - Sair" << endl << endl
        << "Opção >> ";
   int op;
   cin >> op;
   return op;
}

int main() {
    int op;
    while ((op = menu()) != 4) {
        switch (op) {
            case 1:
                break;
            case 2:
                break;
            case 3:
                break;
        }
    }
    return 0;
}
