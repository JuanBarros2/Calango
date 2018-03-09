:- initialization(mainCircle(juan, 100, 100, 100, 100, 100, false)).
nome(juan).

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

instructions:-
  write("O seu bichinho virtual precisa de ajuda para sobreviver. Você precisa manter seus níveis "),
  write("sempre no máximo. Ao inicilizar o jogo, você verá marcadores que vão de 0% a 100%. Cada "),
  write("marcador é afetado pela ação que você toma. Para entender como as ações influenciam, segue "),
  write("abaixo uma tabela de Ações e Reações para cada instrução:"),
  tableInstruction.

tableInstruction:-
  writeln("\n"),
  writeln("Alimentar = +25% de Estômago; +5% de Carinho; -10% de Limpeza;"),
  writeln("Limpar o ambiente = +45% de Limpeza; +5% de Carinho;"),
  writeln("Desligar a luz/Continuar dormindo = +20% de Energia; +2% de Vida;"),
  writeln("Brincar = +40% de Carinho;"),
  writeln("Aplicar injeção = +50% de Vida; -30% de Carinho;"),
  writeln("").

startGame:-
    writeln("Digite o nome do seu calango:"),
    read(NAME),
    assert(nome(NAME)),
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
    mainCircle(NAME, DFOOD, DCLEAR, DENERGY, DLOVE, DLIFE, NSLEEP).

getAction(ACTION):-
    writeln("1- Alimentar"),
    writeln("2- Limpar"),
    writeln("3- Dormir"),
    writeln("4- Dar carinho"),
    writeln("5- Aplicar injeção"),
    writeln("0- Matar calango"),
    read(ACTION).

actionGame(FOOD, CLEAR, ENERGY, LOVE, _, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, LIFE, 1):- % alimentar
    checkUpperLimits(FOOD + 25, Z),
    NFOOD is Z + 5,
    NCLEAR is CLEAR,
    NENERGY is ENERGY,
    NLOVE is LOVE + 5,
    NSLEEP=false.
actionGame(FOOD, CLEAR, ENERGY, LOVE, _, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, LIFE, 2):- % limpar
    NFOOD is FOOD,
    NCLEAR is 110,
    NENERGY is ENERGY,
    NLOVE is LOVE + 5,
    NSLEEP=false.
actionGame(FOOD, CLEAR, ENERGY, LOVE, _, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, NLIFE, 3):- % dormir
    checkUpperLimits(ENERGY + 25, Z),
    NFOOD is FOOD,
    NCLEAR is CLEAR,
    NENERGY is Z + 5,
    NLOVE is LOVE,
    NLIFE is LIFE + 2,
    NSLEEP=true.
actionGame(FOOD, CLEAR, ENERGY, LOVE, _, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, LIFE, 4):- % dar carinho
    checkUpperLimits(LOVE + 40, Z),
    NFOOD is FOOD,
    NCLEAR is CLEAR,
    NENERGY is ENERGY,
    NLOVE is Z + 10,
    NSLEEP=false.
actionGame(FOOD, CLEAR, ENERGY, LOVE, _, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, NLIFE, 5):- % dar injecao
    checkUpperLimits(LIFE + 50, Z),
    NFOOD is FOOD,
    NCLEAR is CLEAR,
    NENERGY is ENERGY,
    NLOVE is LOVE - 30,
    NLIFE is Z + 20,
    NSLEEP=false.
actionGame(_, _, _, _, _, _, _, _, _, _, _, _, ACTION):- nome(NAME), mainCircle(JUAN, _, _, _, _, ACTION, _). % matar


actionSleep(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, SLEEP, 2):- % continuar dormindo
    actionGame(FOOD, CLEAR, ENERGY, LOVE, SLEEP, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NSLEEP, NLIFE, 3),
    decreaseTurn(NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE, DFOOD, DCLEAR, DENERGY, DLOVE, DLIFE),
    mainCircle(NAME, DFOOD, DCLEAR, DENERGY, DLOVE, DLIFE, NSLEEP).
actionSleep(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE, _, 1):- % acordar
    NFOOD is FOOD,
    NCLEAR is CLEAR,
    NENERGY is ENERGY,
    NLOVE is LOVE + 5,
    NSLEEP=false,
    decreaseTurn(NFOOD, NCLEAR, NENERGY, NLOVE, LIFE, DFOOD, DCLEAR, DENERGY, DLOVE, DLIFE),
    mainCircle(NAME, DFOOD, DCLEAR, DENERGY, DLOVE, DLIFE, NSLEEP).

getActionSleep(ACTION):-
    writeln("1- Acordar"),
    writeln("2- Continuar dormindo"),
    read(ACTION).

hasDiscounted(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE):-
    checkLowerLimits(FOOD - 5,ZFOOD),
    checkLowerLimits(CLEAR - 10,ZCLEAR),
    checkLowerLimits(ENERGY - 5,ZENERGY),
    checkLowerLimits(LOVE - 10,ZLOVE),
    checkLowerLimits(LIFE - 20,ZLIFE),
    NFOOD is ZFOOD,
    NCLEAR is ZCLEAR,
    NENERGY is ZENERGY,
    NLOVE is ZLOVE,
    NLIFE is ZLIFE.
decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE):-
    hasDiscounted(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE),
    criticalLove(NLOVE).
decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE):-
    hasDiscounted(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE),
    criticalFood(NFOOD).
decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE):-
    hasDiscounted(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE),
    criticalEnergy(NENERGY).
decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE):-
    hasDiscounted(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, NLIFE),
    criticalTrash(NCLEAR).
decreaseTurn(FOOD, CLEAR, ENERGY, LOVE, LIFE, NFOOD, NCLEAR, NENERGY, NLOVE, LIFE):-
    NFOOD is FOOD - 5,
    NCLEAR is CLEAR - 10,
    NENERGY is ENERGY - 5,
    NLOVE is LOVE - 10,
    not(critical(NLOVE, NFOOD, NENERGY, NCLEAR)).

checkUpperLimits(X,Z) :-
    (  X > 100
    -> Z = 100
    ;  Z = X
    ).

checkLowerLimits(X,Z) :-
    (  X < 0
    -> Z = 0
    ;  Z = X
    ).

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
  CLEAR =< 50,
  writeln("QUE SUJEIRA!!! Seu calango está cambaleando no lixo!").
%%%%% critical messages %%%%%


printInfo(NAME, FOOD, CLEAR, ENERGY, LOVE, LIFE):-
    writeln(NAME),
    write("Comida: "), writeln(FOOD),
    write("Limpeza: "), writeln(CLEAR),
    write("Energia: "), writeln(ENERGY),
    write("Carinho: "), writeln(LOVE),
    write("Vida: "), writeln(LIFE).

decreaseTurn:- write("").