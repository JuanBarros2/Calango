#:- initialization(menuInit(1)).

main:-  write("    CALANGO"), nl, 
        write("    1- Jogar"), nl, 
        write("    2- Instruções"), nl,
        write("    3- Sair"), nl, 
        read(INPUT),
        menuInit(INPUT),
        main.

menuInit(1):- startGame.
menuInit(2):- instructions.
menuInit(3):- halt(0).

instructions:- write("").

startGame:- 
    writeln("Digite o nome do seu calango:"),
    read(NAME),
    mainCircle(NAME, 100, 100, 100, 100, 100).

mainCircle(NAME, C, F, E, L, 0):- write(NAME), write(" morreu").
mainCircle(NAME, CLEAR, FOOD, ENERGY, LOVE, LIFE):- 
    printInfo(CLEAR, FOOD, ENERGY, LOVE, LIFE),
    decreaseLife(LIFE, NEWLIFE),
    mainCircle(NAME, CLEAR, FOOD, ENERGY, LOVE, NEWLIFE).

getOption().

decreaseLife(LIFE, NEWLIFE):- NEWLIFE is LIFE - 10.

printInfo(CLEAR, FOOD, ENERGY, LOVE, LIFE):- 
    writeln(FOOD), 
    writeln(CLEAR),
    writeln(ENERGY),
    writeln(LOVE),
    writeln(LIFE).

decreaseTurn:- write("").
