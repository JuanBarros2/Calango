
#include <iostream>
#include <string>
#include <stdlib.h>

using namespace std;

struct Animal {
  int life = 5;
  int hunger = 2;
  int energy = 6;
  int evolution = 1;
  int bathroom = 0;
  string nome;
  bool isSleep = false;
};

typedef struct Animal Animal ;

Animal animal;
int actions = 0;
int maxActions = 5;

bool verifySleep(){
    if(animal.isSleep){
        cout << animal.nome << " está dormindo! Acorde-o!" << endl << endl;
        return true;
    }
    return false;
}

void feed(){

    if (!verifySleep()) {
        if(animal.hunger != 0){

            if(animal.hunger < 2){
                animal.hunger = 0;
            }else{
                animal.hunger -= 2;
            }
            if(animal.life <= 9)
                animal.life++;
            if(animal.energy != 0)
                animal.energy--;
            animal.bathroom += 2;
            cout << animal.nome << " foi alimentado" << endl << endl;
        }else{
            cout << animal.nome << " não está com fome!" << endl << endl;
        }
    }
}

void bathroom(){
    if (!verifySleep()) {
        if(animal.bathroom != 0){
            animal.bathroom = 0;
            if(animal.energy != 0)
                animal.energy--;
            cout << animal.nome << " foi ao banheiro!" << endl << endl;
        }else{
            cout << animal.nome << " não precisa ir ao banheiro!! Execute outra ação" << endl << endl;
        }
    }

}

void sleep(){
    animal.energy += 2;
    animal.hunger += 1;
    animal.bathroom += 1;
    if(animal.energy < 6){
        animal.energy = 6;
    }
    if(animal.life < 10){
        animal.life++;
    }
    animal.isSleep = true;
    cout << animal.nome << " está dormindo!" << endl << endl;
}

void wakeup(){
    animal.isSleep = false;
    cout << animal.nome << " acabou de acordar!!!" << endl << endl;
}

void checkStats(){
    if(animal.bathroom > 7){
        animal.life--;
        cout << animal.nome << " está com vontade de ir ao banheiro!!" << endl
        << "Leve-o antes que ele perca mais vida!" << endl << endl;
    }

    if(animal.hunger > 7){
        animal.life--;
        cout << animal.nome << " está com muita fome!!" << endl
        << "Alimente-o antes que ele perca mais vida!" << endl << endl;
    }

    if(animal.energy < 0){
        animal.life--;
        cout << animal.nome << " está ficando muito cansando!" << endl
        << "Coloque-o para dormir antes que ele perca mais vida!" << endl << endl;
    }

}
void upgradeLevel(){

    animal.evolution++;
    maxActions += animal.evolution;
    actions = 0;

    cout << animal.nome << " foi promovido ao nível " << animal.evolution << "!" << endl << endl;

}
void showInfo(){
    if(actions >= maxActions)
        upgradeLevel();

    checkStats();

    cout << "Vida: " << animal.life << "   " << "Fome: " << animal.hunger << endl;
    cout << "Energia: " << animal.energy << "   " << "Banheiro: " << animal.bathroom << endl << endl;

    if(animal.isSleep){
        cout << "Status: " << "dormindo" << endl << endl;
    }else{
        cout << "Status: " << "acordado" << endl << endl;
    }
    cout << "Nível: " << animal.evolution << endl << endl;
}


int menuSleep() {
    cout << "=== SELECIONE UMA OPÇÃO ===" << endl << endl;
    cout << "1- Acordar" << endl
        << "2- Continuar dormindo" << endl
        << "4 - Sair" << endl << endl
        << "Opção: ";
    int op;
    cin >> op;
    system("clear || cls");
    switch (op) {
        case 1:
            wakeup();
            break;
        case 2:
            sleep();
            break;
    }
    return op;
}

int menuAwake() {
    cout << "=== SELECIONE UMA OPÇÃO ===" << endl << endl;
    cout << "1- Alimentar" << endl
        << "2- Levar ao banheiro" << endl
        << "3- Dormir" << endl
        << "4- Sair" << endl << endl
        << "Opção: ";
    int op;
    cin >> op;
    system("clear || cls");
    switch (op) {
        case 1:
            feed();
            break;
        case 2:
            bathroom();
            break;
        case 3:
            sleep();
            break;
    }
    return op;
}

int menu() {
    return !animal.isSleep ? menuAwake() : menuSleep();
}

int main() {

    cout << "Qual o nome do seu bichinho?" << endl;
    cin >> animal.nome;
    system("clear || cls");
    int op;
    while (menu() != 4 && animal.life > 0) {
        actions++;
        showInfo();
    }
    return 0;
}

