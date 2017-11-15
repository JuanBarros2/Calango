
#include <iostream>
#include <string>
#include <stdlib.h>

using namespace std;

struct Animal {
  int life = 0;
  int hunger = 5;
  int energy = 5;
  int evolution = 0;
  int bathroom = 0;
  string nome;
  bool isSleep = false;
};

typedef struct Animal Animal ;

Animal animal;
int actions = 0;
int maxActions = 5;
int level = 1;

int menu() {
   cout << "=== SELECIONE UMA OPÇÃO ===" << endl << endl;
   cout << "1- Alimentar" << endl
        << "2- Levar ao banheiro" << endl
        << "3- Dormir/Acordar" << endl
        << "4 - Sair" << endl << endl
        << "Opção: ";
   int op;
   cin >> op;
   return op;
}

void feed(){

    system("clear || cls");

    if(animal.isSleep){

        cout << animal.nome << " está dormindo! Acorde-o!" << endl << endl;
        return;
    }

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
void bathroom(){

    system("clear || cls");

    if(animal.isSleep){

        cout << animal.nome << " está dormindo! Acorde-o!" << endl << endl;
        return;
    }

    if(animal.bathroom != 0){

        animal.bathroom = 0;
        if(animal.energy != 0)
            animal.energy--;
        cout << animal.nome << " foi ao banheiro!" << endl << endl;
    }else{
        cout << animal.nome << " não precisa ir ao banheiro!! Execute outra ação" << endl << endl;
    }

}
void setSleep(){

    system("clear || cls");

    if(animal.isSleep == false){

        if(animal.energy < 6)
            animal.energy = 6;
        if(animal.hunger < 8)
            animal.hunger+= 3;
        if(animal.bathroom < 10)
            animal.bathroom++;
        if(animal.life < 10)
            animal.life++;

        animal.isSleep = true;
        cout << animal.nome << " foi dormir!" << endl << endl;
    }else{

        animal.isSleep = false;
        cout << animal.nome << " acabou de acordar!!!" << endl << endl;
    }

}
void checkStats(){

    if(animal.bathroom > 7)
        cout << animal.nome << " está com vontade de ir ao banheiro!! Leve-o!" << endl << endl;
    if(animal.hunger > 7)
        cout << animal.nome << " está com muita fome!! Alimente-o" << endl << endl;
    if(animal.energy < 4)
        cout << animal.nome << " está ficando muito cansando! Coloque-o para dormir" << endl << endl;
}
void upgradeLevel(){

    level++;
    maxActions += level;
    actions = 0;

    cout << animal.nome << " foi promovido ao nível " << level << "!" << endl << endl;

}
void showInfo(){
    if(actions >= maxActions)
        upgradeLevel();

    checkStats();

    cout << "Vida: " << animal.life << endl;
    cout << "Fome: " << animal.hunger << endl;
    cout << "Energia: " << animal.energy << endl;
    cout << "Banheiro: " << animal.bathroom << endl << endl;

    if(animal.isSleep){
        cout << "Status: " << "dormindo" << endl << endl;
    }else{
        cout << "Status: " << "acordado" << endl << endl;
    }
    cout << "Nível: " << level << endl << endl;
}

int main() {

    cout << "Qual o nome do seu bichinho?" << endl;
    cin >> animal.nome;
    int op;
    while ((op = menu()) != 4) {
        switch (op) {
            case 1:
                feed();
                actions++;
                showInfo();
                break;
            case 2:
                bathroom();
                actions++;
                showInfo();
                break;
            case 3:
                setSleep();
                actions++;
                showInfo();
                break;
        }
    }
    return 0;
}

