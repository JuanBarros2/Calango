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

mainCircle(NAME, _, _, _, _, 0, _):- write(NAME), write(" morreu").
mainCircle(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, true):-
    printInfo(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE),
    getActionSleep(ACTION),
    actionSleep(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, true, ACTION).
mainCircle(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, SLEEP):-
    printInfo(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE),
    getAction(ACTION),
    actionGame(FOOD, CLEAR, ENERGY, LOVE, SLEEP, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, NLIFE, ACTION),
    decreaseTurn(NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE, DFOOD, DCLEAR, DENERGY, DLOVE, DLIFE),
    mainCircle(NAME, DCLEAR, DFOOD, DENERGY, DLOVE, DLIFE, NSLEEP).

getAction(ACTION):-
    writeln("1- Alimentar"),
    writeln("2- Limpar"),
    writeln("3- Dormir"),
    writeln("4- Dar carinho"),
    read(ACTION).

actionGame(FOOD, CLEAR, ENERGY, LOVE, _, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, LIFE, 1):- % alimentar
    NFOOD is FOOD + 25,
    NCLEAR is CLEAR,
    NENERGY is ENERGY,
    NLOVE is LOVE + 5,
    NSLEEP=false.
actionGame(FOOD, _, ENERGY, LOVE, _, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, LIFE, 2):- % limpar
    NFOOD is FOOD,
    NCLEAR is 100,
    NENERGY is ENERGY,
    NLOVE is LOVE + 5,
    NSLEEP=false.
actionGame(FOOD, CLEAR, ENERGY, LOVE, _, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, NLIFE, 3):- % dormir
    NFOOD is FOOD,
    NCLEAR is CLEAR,
    NENERGY is ENERGY + 25,
    NLOVE is LOVE,
    NLIFE is LIFE + 2,
    NSLEEP=true.
actionGame(FOOD, CLEAR, ENERGY, LOVE, _, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, LIFE, 4):- % dar carinho
    NFOOD is FOOD,
    NCLEAR is CLEAR,
    NENERGY is ENERGY,
    NLOVE is LOVE + 40,
    NSLEEP=false.

actionSleep(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, SLEEP, 2):- % continuar dormindo
    actionGame(FOOD, CLEAR, ENERGY, LOVE, SLEEP, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, NLIFE, 3),
    decreaseTurn(NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE, DFOOD, DCLEAR, DENERGY, DLOVE, DLIFE),
    mainCircle(NAME, DCLEAR, DFOOD, DENERGY, DLOVE, DLIFE, NSLEEP).
actionSleep(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, _, 1):- % acordar
    NFOOD is FOOD,
    NCLEAR is CLEAR,
    NENERGY is ENERGY,
    NLOVE is LOVE + 5,
    NSLEEP=false,
    decreaseTurn(NFOOD, NCLEAR, NENERGY, NLOVE, LIFE, DFOOD, DCLEAR, DENERGY, DLOVE, DLIFE),
    mainCircle(NAME, DCLEAR, DFOOD, DENERGY, DLOVE, DLIFE, NSLEEP).

getActionSleep(ACTION):-
    writeln("1- Acordar"),
    writeln("2- Continuar dormindo"),
    read(ACTION).


decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE):-
    NFOOD is FOOD - 5,
    NCLEAR is CLEAR - 10,
    NENERGY is ENERGY - 5,
    NLOVE is LOVE - 10,
    NLIFE is LIFE - 20,
    criticalLove(NLOVE).
decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE):-
    NFOOD is FOOD - 5,
    NCLEAR is CLEAR - 10,
    NENERGY is ENERGY - 5,
    NLOVE is LOVE - 10,
    NLIFE is LIFE - 20,
    criticalFood(NFOOD).
decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE):-
    NFOOD is FOOD - 5,
    NCLEAR is CLEAR - 10,
    NENERGY is ENERGY - 5,
    NLOVE is LOVE - 10,
    NLIFE is LIFE - 20,
    criticalEnergy(NENERGY).
decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE):-
    NFOOD is FOOD - 5,
    NCLEAR is CLEAR - 10,
    NENERGY is ENERGY - 5,
    NLOVE is LOVE - 10,
    NLIFE is LIFE - 20,
    criticalTrash(NCLEAR).
decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, LIFE):-
    NFOOD is FOOD - 5,
    NCLEAR is CLEAR - 10,
    NENERGY is ENERGY - 5,
    NLOVE is LOVE - 10,
    valid(NFOOD, NCLEAR, NENERGY, NLOVE, LIFE),
    not(critical(NLOVE, NFOOD, NENERGY, NCLEAR)).

%%%%% critical messages %%%%%
critical(L, F, E, C):-
  criticalLove(L),
  criticalFood(F),
  criticalEnergy(E),
  criticalTrash(C).
criticalLove(LOVE):-
  LOVE =< 20,
  writeln("CARÊNCIA CRÍTICA!! Parece que você é um verdadeiro BRUTA-MONTES, cuide do seu calango seu(a) cabra da peste!!").
criticalFood(FOOD):-
  FOOD =< 20,
  writeln("PERIGO EMINENTE!!! Seu calango está a com fome alta, alimente-o já!").
criticalEnergy(ENERGY):-
  ENERGY =< 30,
  writeln("SONO CRÍTICO!!! Seu calango precisa de um descanso ou não terá energia para escapar de predadores. Apague a luz!").
criticalTrash(CLEAR):-
  CLEAR =< 70,
  writeln("PERIGO EMINENTE!!! Seu calango está a com fome alta, alimente-o já!").
%%%%% critical messages %%%%%


printInfo(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE):-
    writeln(NAME),
    write("Comida: "),
    writeln(FOOD),
    write("Limpeza: "),
    writeln(CLEAR),
    write("Energia: "),
    writeln(ENERGY),
    write("Carinho: "),
    writeln(LOVE),
    write("Vida: "),
    writeln(LIFE).

decreaseTurn:- write("").
