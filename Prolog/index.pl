:- initialization(mainCircle(juan, 100, 100, 100, 100, 100)).

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

mainCircle(NAME, F, C, E, L, 0):- write(NAME), write(" morreu").
mainCircle(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE):- 
    printInfo(NAME, FOOD, CLEAR, ENERGY, LOVE),
    getAction(ACTION),
    actionGame(FOOD, CLEAR, ENERGY, LOVE, NFOOD, NCLEAR, NENERGY, NLOVE, ACTION),
    FOOD is NFOOD,
    decreaseTurn(NCLEAR, NFOOD, NENERGY, NLOVE, DCLEAR, DFOOD, DENERGY, DLOVE),
    mainCircle(NAME, DCLEAR, DFOOD, DENERGY, DLOVE, LIFE).

getAction(ACTION):- writeln("1- Alimentar"),
    writeln("2- Limpar"),
    writeln("3- Dormir"),
    writeln("4- Dar carinho"),
    read(ACTION).

actionGame(FOOD, CLEAR, ENERGY, LOVE, NEFOOD, NECLEAR, NENERGY, NLOVE, 1):- NEFOOD is FOOD + 25, NECLEAR is CLEAR, NENERGY is ENERGY, NLOVE is LOVE + 5.
actionGame(FOOD, CLEAR, ENERGY, LOVE, NEFOOD, NECLEAR, NENERGY, NLOVE, 2):- NEFOOD is FOOD, NECLEAR is 100, NENERGY is ENERGY, NLOVE is LOVE + 5.
actionGame(FOOD, CLEAR, ENERGY, LOVE, NEFOOD, NECLEAR, NENERGY, NLOVE, 4):- NEFOOD is FOOD, NECLEAR is CLEAR, NENERGY is ENERGY, NLOVE is LOVE + 40.

decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, NFOOD, NCLEAR, NENERGY, NLOVE):- NFOOD is FOOD - 5, NCLEAR is CLEAR - 10, NENERGY is ENERGY, NLOVE is LOVE.

printInfo(CLEAR, FOOD, ENERGY, LOVE, LIFE):- 
    writeln(FOOD), 
    writeln(CLEAR),
    writeln(ENERGY),
    writeln(LOVE),
    writeln(LIFE).

decreaseTurn:- write("").
