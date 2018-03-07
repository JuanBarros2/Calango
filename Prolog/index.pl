:- initialization(mainCircle(juan, 100, 100, 100, 100, 100, false)).

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
    mainCircle(NAME, 100, 100, 100, 100, 100, false).

mainCircle(NAME, F, C, E, L, 0, S):- write(NAME), write(" morreu").
mainCircle(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, true):-
    printInfo(NAME, FOOD, CLEAR, ENERGY, LOVE),
    getActionSleep(ACTION),
    actionSleep(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, true, ACTION).
mainCircle(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, SLEEP):- 
    printInfo(NAME, FOOD, CLEAR, ENERGY, LOVE),
    getAction(ACTION),
    actionGame(FOOD, CLEAR, ENERGY, LOVE, SLEEP, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, ACTION),
    decreaseTurn(NCLEAR, NFOOD, NENERGY, NLOVE, DCLEAR, DFOOD, DENERGY, DLOVE),
    mainCircle(NAME, DCLEAR, DFOOD, DENERGY, DLOVE, LIFE, NSLEEP).

getAction(ACTION):- writeln("1- Alimentar"),
    writeln("2- Limpar"),
    writeln("3- Dormir"),
    writeln("4- Dar carinho"),
    read(ACTION).

actionGame(FOOD, CLEAR, ENERGY, LOVE, SLEEP, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, 1):- NFOOD is FOOD + 25, NCLEAR is CLEAR, NENERGY is ENERGY, NLOVE is LOVE + 5, NSLEEP=false.
actionGame(FOOD, CLEAR, ENERGY, LOVE, SLEEP, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, 2):- NFOOD is FOOD, NCLEAR is 100, NENERGY is ENERGY, NLOVE is LOVE + 5, NSLEEP=false.
actionGame(FOOD, CLEAR, ENERGY, LOVE, SLEEP, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, 4):- NFOOD is FOOD, NCLEAR is CLEAR, NENERGY is ENERGY, NLOVE is LOVE + 40, NSLEEP=false.
actionGame(FOOD, CLEAR, ENERGY, LOVE, SLEEP, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, 3):- NFOOD is FOOD, NCLEAR is CLEAR, NENERGY is ENERGY + 20, NLOVE is LOVE, NSLEEP=true.

actionSleep(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, SLEEP, 2):-
    actionGame(FOOD, CLEAR, ENERGY, LOVE, SLEEP, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, 3),
    decreaseTurn(NCLEAR, NFOOD, NENERGY, NLOVE, DCLEAR, DFOOD, DENERGY, DLOVE),
    mainCircle(NAME, DCLEAR, DFOOD, DENERGY, DLOVE, LIFE, NSLEEP).
actionSleep(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, SLEEP, 1):-
    NFOOD is FOOD, NCLEAR is CLEAR, NENERGY is ENERGY, NLOVE is LOVE + 5, NSLEEP=false,
    decreaseTurn(NCLEAR, NFOOD, NENERGY, NLOVE, DCLEAR, DFOOD, DENERGY, DLOVE),
    mainCircle(NAME, DCLEAR, DFOOD, DENERGY, DLOVE, LIFE, NSLEEP).

getActionSleep(ACTION):- writeln("1- Acordar"),
    writeln("2- Continuar dormindo"),
    read(ACTION).

decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, NFOOD, NCLEAR, NENERGY, NLOVE):- NFOOD is FOOD - 5, NCLEAR is CLEAR - 10, NENERGY is ENERGY, NLOVE is LOVE.

printInfo(CLEAR, FOOD, ENERGY, LOVE, LIFE):- 
    writeln(FOOD), 
    writeln(CLEAR),
    writeln(ENERGY),
    writeln(LOVE),
    writeln(LIFE).

decreaseTurn:- write("").
