:- initialization(main).

main:- write("              CALANGO"), nl, 
    write("    1- Jogar"), nl, 
    write("    2- Instruções"), nl,
    write("     3- Sair"), nl, 
    read(INPUT),
    menuInit(INPUT).

menuInit(1):- starGame.

starGame:- write("Qual o nome do seu calango?"),
    read(NAME), mainCircle(NAME, 100, 100, 100, 100, 100).

mainCircle(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE):- 
    decreaseTurn,
    printInfo(FOOD, CLEAR, ENERGY, LOVE, LIFE).

mainCircle(NAME, FOOD, CLEAR, ENERGY, LOVE, 0):- 
    write(DEAD + " morreu"), main.

printInfo(F, C, E, L, LI):- write(F), nl, 
                        write(C), nl,
                        write(E), nl,
                        write(L), nl,
                        write(LI), nl.

decreaseTurn:- write("").