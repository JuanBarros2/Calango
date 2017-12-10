
data Animal = Animal {
    name :: String,
    stomach :: Int,
    energy :: Int,
    life :: Int,
    cleanness :: Int,
    caress :: Int,
    turns :: Int,
    isSleep :: Bool
  } deriving (Show)

main = do
  putStrLn (" ================================= ")
  putStrLn ("|                                 |")
  putStrLn ("|       CALANGO                   |")
  putStrLn ("|                                 |")
  putStrLn ("|       1- Começar jogo           |")
  putStrLn ("|       2- Instruções             |")
  putStrLn ("|       3- Sair                   |")
  putStrLn ("|                                 |")
  putStrLn (" ================================= ")
  opcao <- getLine
  selectStart (read opcao)
  if (read opcao) == 3 then putStr("Fim") else main

selectStart :: Int -> IO ()
selectStart 1 = startGame
selectStart 2 = instructions
selectStart _ = putStr ""


startGame :: IO ()
startGame = do
  showDivisor
  putStrLn ("\nQual o nome do seu bichinho?")
  nomeBichinho <- getLine
  let novoAnimal = Animal { name = nomeBichinho, stomach = 75, life = 100, caress = 100, energy = 100, turns = 1, isSleep = False, cleanness = 100 }
  menu novoAnimal False
  showDivisor
  putStrLn (("\n" ++ nomeBichinho) ++ " morreu :/")
  putStrLn "Pressione ENTER para continuar"
  getChar
  putStrLn ""

instructions :: IO ()
instructions = do
  showDivisor
  putStrLn ""
  putStr "O seu bichinho virtual precisa de ajuda para sobreviver. Você precisa manter seus níveis "
  putStr "sempre no máximo. Ao inicilizar o jogo, você verá marcadores que vão de 0% a 100%. Cada "
  putStr "marcador é afetado pela ação que você toma. Para entender como as ações influenciam, segue "
  putStr "abaixo uma tabela de Ações e Reações para cada instrução:"
  tableInstruction

tableInstruction :: IO ()
tableInstruction = do
  putStrLn "\n"
  putStrLn "Alimentar = +25% de Estômago; +5% de Carinho; -10% de Limpeza;"
  putStrLn "Limpar o ambiente = +45% de Limpeza; +5% de Carinho;"
  putStrLn "Desligar a luz/Continuar dormindo = +20% de Energia; +2% de Vida;"
  putStrLn "Brincar = +40% de Carinho;"
  putStrLn "Aplicar injeção = +50% de Vida; -30% de Carinho;"
  putStrLn ""
  putStrLn "Pressione ENTER para continuar"
  cm <- getLine
  showDivisor

menu :: Animal -> Bool -> IO Animal
menu Animal { life = 0 } anyValue = return Animal {name = "", stomach = 0, life = 0, caress = 0, energy = 0, turns = 0, isSleep = False, cleanness = 0}
menu animal False = do
  showDivisor
  putStrLn (showStatus animal)
  putStrLn ("")
  putStrLn ("1 - Alimentar")
  putStrLn ("2 - Limpar o ambiente")
  putStrLn ("3 - Desligar a luz")
  putStrLn ("4 - Brincar")
  putStrLn ("5 - Aplicar injeção")
  putStrLn ("0 - Sair")
  option <- getLine
  executeOption animal (read option::Int) False

menu animal True = do
  putStrLn (showStatus animal)
  putStrLn ("")
  putStrLn ("1 - Ligar luz")
  putStrLn ("2 - Continuar dormindo")
  putStrLn ("0 - Sair")
  option <- getLine
  executeOption animal (read option::Int) True

executeOption :: Animal -> Int -> Bool -> IO Animal
executeOption animal 1 False = feed (decreaseByRound animal)
executeOption animal 1 True = wakeUp (decreaseByRound animal)
executeOption animal 2 True = sleep (decreaseByRound animal)
executeOption animal 2 False = toClean (decreaseByRound animal)
executeOption animal 3 False = sleep (decreaseByRound animal)
executeOption animal 4 False = toCaress (decreaseByRound animal)
executeOption animal 5 False = heal(decreaseByRound animal)
executeOption animal 0 anyValue = return animal
executeOption animal _ anyValue = do
  putStrLn("\nOpção Inválida! Tente novamente...")
  putStr("\nPressione <Enter> para voltar ao menu...")
  getChar
  menu animal anyValue

heal :: Animal -> IO Animal
heal animal = do
  let updatedAnimal = calcHeal animal
  menu updatedAnimal False

calcHeal :: Animal -> Animal
calcHeal Animal { name = n, stomach = s, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl } = Animal {
  name = n,
  stomach = s,
  life = if(l >= 50) then 100 else (l + 50),
  caress = if(c <= 30) then 0 else (c - 30),
  energy = e,
  turns = t + 1,
  cleanness = cl,
  isSleep = sleep}

-- As funções de inscrease e decrease do sleep calculam a energia (por round) de forma que não ultrapasse o range [0, 100] --
increaseSleep :: Int -> Int
increaseSleep energy = if (energy >= 80) then 100 else (energy + 20)

decreaseSleep :: Int -> Int
decreaseSleep energy = if (energy <= 5) then 0 else (energy - 5)

decreaseByRound :: Animal -> Animal
decreaseByRound (Animal { name = n, stomach = s, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl}) = Animal {
  name = n,
  stomach = if(s <= 5) then 0 else (s - 5),
  life = if calculateLife l s e cl sleep <= 0 then 0 else if (calculateLife l s e cl sleep >= 100) then 100 else calculateLife l s e cl sleep,
  caress = if(c <= 10) then 0 else (c - 10),
  energy = if (sleep) then increaseSleep e else decreaseSleep e,
  turns = (t + 1),
  isSleep = sleep,
  cleanness = cl
}

calculateLife:: Int -> Int -> Int -> Int-> Bool -> Int
calculateLife life stomach energy cleanness sleep = life - (calculateLifeDescontByEnergy energy) - (calculateLifeDescontByStomach stomach) - (calculateLifeDescontByCleanness cleanness) + (calculateLifeIncreaseBySleep sleep)

calculateLifeDescontByCleanness:: Int -> Int
calculateLifeDescontByCleanness cleanness = if (cleanness <= 70) then 20 else 0

calculateLifeDescontByStomach:: Int -> Int
calculateLifeDescontByStomach stomach = if (stomach <= 15) then 20 else 0

calculateLifeDescontByEnergy:: Int -> Int
calculateLifeDescontByEnergy energy = if (energy <= 30) then 20 else 0

calculateLifeIncreaseBySleep:: Bool -> Int
calculateLifeIncreaseBySleep isSleep = if isSleep then 2 else 0

-- Ainda não há conceito de níveis, nem de experiência
-- As interações ainda não verifica estados dos atributos (se atingiu limite superior ou se chegou abaixo de 0)

feed :: Animal -> IO Animal
feed animal = do
  let updatedAnimal = calcFeed animal
  menu updatedAnimal False

calcFeed :: Animal -> Animal
calcFeed Animal { name = n, stomach = s, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl } = Animal {
  name = n,
  stomach = if(s >= 75) then 100 else (s + 25),
  life = l,
  caress = if(c >= 95) then 100 else (c + 5),
  energy = e,
  turns = t + 1,
  cleanness = if (cl <= 10) then 0 else (cl - 10),
  isSleep = sleep}

wakeUp :: Animal -> IO Animal
wakeUp animal = do
  let updatedAnimal = calcWakeUp animal
  menu updatedAnimal False

calcWakeUp :: Animal -> Animal
calcWakeUp Animal { name = n, stomach = s, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl} = Animal {
    name = n,
    stomach = s,
    life = l,
    caress = if(c >= 95) then 100 else (c + 5),
    energy = e,
    turns = t + 1,
    cleanness = cl,
    isSleep = False
  }

-- Função sleep única: Ainda não há o estado "dormindo"
sleep :: Animal -> IO Animal
sleep animal = do
  let updatedAnimal = calcSleep animal
  menu updatedAnimal True

calcSleep :: Animal -> Animal
calcSleep (Animal { name = n, stomach = h, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl}) = Animal {
  name = n,
  stomach = h,
  life = if (l > 98) then 100 else (l + 2),
  caress = c,
  energy = if(e >= 80) then 100 else (e + 20),
  turns = (t + 1),
  isSleep = True,
  cleanness = cl}


toCaress :: Animal -> IO Animal
toCaress animal = do
  let updatedAnimal = calcToCaress animal
  menu updatedAnimal False

calcToCaress :: Animal -> Animal
calcToCaress (Animal { name = n, stomach = h, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl}) = Animal {
    name = n,
    stomach = h,
    life = l,
    caress = if (c >= 60) then 100 else (c + 40),
    energy = e ,
    turns = (t + 1),
    isSleep = sleep,
    cleanness = cl
  }

toClean :: Animal -> IO Animal
toClean animal = do
  let updatedAnimal = calcToClean animal
  menu updatedAnimal False

calcToClean :: Animal -> Animal
calcToClean (Animal { name = n, stomach = h, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl}) = Animal {
  name = n,
  stomach = h,
  life = l,
  caress = if(c >= 95) then 100 else (c + 5),
  energy = e ,
  turns = (t + 1),
  isSleep = sleep,
  cleanness = if (cl >= 55) then 100 else cl + 45}

-- Sem função de limpar tela, por enquanto
showStatus :: Animal -> String
showStatus (Animal {name = n, stomach = h, life = l, caress = c, energy = e,
               turns = t, isSleep = sleep, cleanness = cl})
  | h <= 20 = "\nPERIGO EMINENTE!!! " ++ n ++ " está a com fome alta, alimente-o já!\n" ++ status
  | c <= 20 = "\nCARÊNCIA CRÍTICA!! Parece que você é um verdadeito BRUTA-MONTES, cuide do seu calango seu(a) cabra da peste!!\n" ++ status
  | e <= 30 = "\nSONO CRÍTICO!!! " ++ n ++ " precisa de um descanso ou não terá energia para escapar de predadores. Apague a luz!\n" ++ status
  | cl <= 70 = "\nQUE SUJEIRA!!! " ++ n ++ " está cambaleando no lixo!\n" ++ status
  | otherwise = status
  where status = "\nNome: " ++ n
              ++ "\nVida: " ++ show l
              ++ "%, Estomago: " ++ show h
              ++ "%, Carinho: " ++ show c
              ++ "%,\nEnergia: " ++ show e
              ++ "%, Limpeza do ambiente " ++ show  cl ++ "%"

showDivisor = do
  putStrLn ("\n=========================================================")
