
#include <iostream>
#include <sstream>
#include <string>
#include <stdlib.h>
#include <curses.h>

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

string getString() {
    string input;
    nocbreak();
    echo();

    int ch = getch();

    while (ch != '\n') {
        input.push_back(ch);
        ch = getch();
    }
    
    return input;
}

int nextInt() {
	return getch() - '0';
}

char nextChar() {
	return getch();
}

void write(string str) {
	waddstr(stdscr, str.c_str());
	wrefresh(stdscr);
}

void write(stringstream &ss) {
	waddstr(stdscr, ss.str().c_str());
	wrefresh(stdscr);
}

bool verifySleep(){
    if(animal.isSleep){
        stringstream msg;
        msg << animal.nome << " está dormindo! Acorde-o!" << endl << endl;
        write(msg.str());
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
            stringstream ss;
            ss << animal.nome << " foi alimentado" << endl << endl;
            write(ss);
        }else{
        	stringstream ss;

            ss << animal.nome << " não está com fome!" << endl << endl;
            write(ss);
        }
    }
}

void bathroom(){
    if (!verifySleep()) {
        if(animal.bathroom != 0){
            animal.bathroom = 0;
            if(animal.energy != 0)
                animal.energy--;
           	stringstream ss;
            ss << animal.nome << " foi ao banheiro!" << endl << endl;
        }else{
        	stringstream ss;
            ss << animal.nome << " não precisa ir ao banheiro!! Execute outra ação" << endl << endl;
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
	stringstream ss;	
    ss << animal.nome << " está dormindo!" << endl << endl;
    write(ss);
}

void wakeup(){
    animal.isSleep = false;
	stringstream ss;	
    ss << animal.nome << " acabou de acordar!!!" << endl << endl;
    write(ss);
}

void checkStats(){
    if(animal.bathroom > 7){
        animal.life--;
		stringstream ss;	
        ss << animal.nome << " está com vontade de ir ao banheiro!!" << endl
        << "Leve-o antes que ele perca mais vida!" << endl << endl;
        write(ss);
    }

    if(animal.hunger > 7){
        animal.life--;
		stringstream ss;	

        ss << animal.nome << " está com muita fome!!" << endl
        << "Alimente-o antes que ele perca mais vida!" << endl << endl;
        write(ss);
    }

    if(animal.energy < 0){
        animal.life--;
		stringstream ss;	

        ss << animal.nome << " está ficando muito cansando!" << endl
        << "Coloque-o para dormir antes que ele perca mais vida!" << endl << endl;
        write(ss);
    }

}
void upgradeLevel(){

    animal.evolution++;
    maxActions += animal.evolution;
    actions = 0;
    stringstream ss;
    ss << animal.nome << " foi promovido ao nível " << animal.evolution << "!" << endl << endl;
    write(ss);

}
void showInfo(){
    if(actions >= maxActions)
        upgradeLevel();

    checkStats();
    stringstream ss;
    ss << "Vida: " << animal.life << "   " << "Fome: " << animal.hunger << endl;
    write(ss.str());
    ss.str("");

    ss << "Energia: " << animal.energy << "   " << "Banheiro: " << animal.bathroom << endl << endl;
    write(ss.str());
    ss.str("");

    if (animal.isSleep) {
        ss << "Status: " << "dormindo" << endl << endl;
        write(ss.str());
    	ss.str("");
    } else {
        ss << "Status: " << "acordado" << endl << endl;
        write(ss.str());
    	ss.str("");
    }
    ss << "Nível: " << animal.evolution << endl << endl;
    write(ss);
    ss.str("");
}


int menuSleep() {
    write("=== SELECIONE UMA OPÇÃO ===\n\n");
    write("1- Acordar\n2- Continuar dormindo\n4 - Sair\n\nOpção: ");
    int op = nextInt();
    erase();
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
    write("=== SELECIONE UMA OPÇÃO ===\n\n");
    write("1- Alimentar\n2- Levar ao banheiro\n3- Dormir\n4- Sair\n\nOpção: ");
    int op = nextInt();
    erase();
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
	setlocale(LC_ALL, "");
	initscr();
	scrollok(stdscr,TRUE);
	noecho();

    write("Qual o nome do seu bichinho?\n");
    animal.nome = getString();
    erase();
    int op;
    while (menu() != 4 && animal.life > 0) {
        actions++;
        showInfo();
    }
    return 0;
}

