﻿
#include <iostream>
#include <sstream>
#include <string>
#include <stdlib.h>
#include <curses.h>
#include <math.h>

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

void drawBorders() {
    int y, x;
    getyx(stdscr, y, x);
    wborder(stdscr, '|', '|', '-', '-', '+', '+', '+', '+');
    move(y+1,x+1);
}

string getString() {
    // Move o cursor
    int y, x;
    getyx(stdscr, y, x);
    move(y+1,x+1);

    // Pega o input
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
    drawBorders();
	waddstr(stdscr, str.c_str());
	wrefresh(stdscr);
}

void write(stringstream &ss) {
    drawBorders();
	waddstr(stdscr, ss.str().c_str());
	ss.str("");
	wrefresh(stdscr);
}

int getLevelInfluencer(){
    return floor(animal.evolution * 0.5);
}

void cleanErrorValues(){
    if (animal.hunger < 0) {
        animal.hunger = 0;
    }
    if (animal.energy < 0) {
        animal.energy = 0;
    }
    if (animal.life < 0) {
        animal.life = 0;
    }
}

void feed(){
    stringstream ss;
    const int LEVEL_INFLUENCER = getLevelInfluencer();
    if(animal.hunger != 0){
        animal.hunger -= 2 + (1 * LEVEL_INFLUENCER);
        if (animal.life <= 9)
            animal.life += 1 + (floor(0.5 * LEVEL_INFLUENCER));
        if (animal.energy != 0)
            animal.energy -= 1 + LEVEL_INFLUENCER;
        animal.bathroom += 1 + LEVEL_INFLUENCER;
        ss << animal.nome << " foi alimentado" << endl << endl;
        write(ss);
        actions++;
    } else{
        ss << animal.nome << " não está com fome!" << endl << endl;
        write(ss);
    }
}

void bathroom(){
    stringstream ss;
    const int LEVEL_INFLUENCER = getLevelInfluencer();
    if(animal.bathroom != 0){
        animal.bathroom = 0;
        if(animal.energy != 0)
            animal.energy -= 1 + LEVEL_INFLUENCER;
        ss << animal.nome << " foi ao banheiro!" << endl << endl;
        write(ss);
        actions++;
    } else{
        ss << animal.nome << " não precisa ir ao banheiro!! Execute outra ação" << endl << endl;
        write(ss);
    }
}

void sleep(){
    const int LEVEL_INFLUENCER = getLevelInfluencer();
    animal.hunger += 1 + LEVEL_INFLUENCER;
    animal.bathroom += 1 + floor(1 * LEVEL_INFLUENCER);
    if(animal.energy < 10 + (2 * LEVEL_INFLUENCER)){
        animal.energy += 2 + (1 * LEVEL_INFLUENCER);
    }
    if(animal.life < 10 + (2 * LEVEL_INFLUENCER)){
        animal.life++;
    }
    animal.isSleep = true;
	  stringstream ss;
    ss << animal.nome << " está dormindo!" << endl << endl;
    write(ss);
    actions++;
}

void wakeup(){
    animal.isSleep = false;
	  stringstream ss;
    ss << animal.nome << " acabou de acordar!!!" << endl << endl;
    write(ss);
    actions++;
}

void checkStats(){
    if(animal.bathroom > 7){
        animal.life -= (animal.bathroom - 7);
		    stringstream ss;
        ss << animal.nome << " está com vontade de ir ao banheiro!!" << endl
        << "Leve-o antes que ele perca mais vida!" << endl << endl;
        write(ss);
    }

    if(animal.hunger > 7){
        animal.life -= (animal.hunger - 7);
		    stringstream ss;

        ss << animal.nome << " está com muita fome!!" << endl
        << "Alimente-o antes que ele perca mais vida!" << endl << endl;
        write(ss);
    }

    if(animal.energy <= 0){
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
    write(ss);

    ss << "Energia: " << animal.energy << "   " << "Banheiro: " << animal.bathroom << endl << endl;
    write(ss);

    ss << "Status: " << (animal.isSleep ? "dormindo" : "acordado") << endl << endl;
    write(ss);

    ss << "Nível: " << animal.evolution << endl << endl;
    write(ss);

}

int menuSleep() {
    write("=== SELECIONE UMA OPÇÃO ===\n\n");
    write("1- Acordar\n2- Continuar dormindo\n4 - Sair\n\nOpção: ");
    int op = nextInt();
    getch();
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
    getch();
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

void deathScreen() {
    erase();
    stringstream ss;
    ss << "Você perdeu no nível " << animal.evolution << " D:" << endl;
    write(ss);
    write("Pressione qualquer tecla para sair...");
    getch();
}

int menu() {
    return !animal.isSleep ? menuAwake() : menuSleep();
}

void showCalango() {
    write("                     _.....---..._\n      _..-'-.   _.--'             '--.._\n  _.-' (  0) Y''                        ''-.._\n (---.._,                                     '-._\n  `---.,___.-\\  \\----......./  /..------...____   '-.\n     _/  /  _/  /         __\\  \\   __\\  \\      `-.   \\\n    (((-'  (((-'         (((---'  (((---`         )  /\n                                               .-'.-'\n                                              (__`-,\n                                                 ``\n");
}

int main() {
    setlocale(LC_ALL, "");
    initscr();
    scrollok(stdscr,TRUE);
    noecho();
    start_color();

    showCalango();
    write("Qual o nome do seu bichinho?\n");
    animal.nome = getString();
    erase();
    showInfo();

    int op;
    while ( animal.life > 0 && menu() != 4) {
        cleanErrorValues();
        showInfo();
    }
    
    deathScreen();

    endwin();
    return 0;
}

