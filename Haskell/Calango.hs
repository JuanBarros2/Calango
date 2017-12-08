
data Animal = Animal { name :: String
               , stomach :: Int
               , energy :: Int
               , life :: Int
               , cleanness :: Int
               , caress :: Int
               , turns :: Int
               , isSleep :: Bool
               } deriving (Show)

main = do
    putStrLn (" =========================================== \n")
    putStrLn ("|                                           |\n")
    putStrLn ("|                CALANGO                    |\n")
    putStrLn ("|                                           |\n")
    putStrLn ("|           1- Começar jogo                 |\n")
    putStrLn ("|           2- Instruções                   |\n")
    putStrLn ("|           3- Sair                         |\n")
    putStrLn ("|                                           |\n")
    putStrLn (" =========================================== \n")
    opcao <- getLine
    selectStart (read opcao)
    if (read opcao) == 3 then putStr("Fim") else main

selectStart :: Int -> IO ()
selectStart 1 = startGame
selectStart 2 = putStrLn "Aqui ficam as instruções para jogar"
selectStart _ = putStr ""


startGame :: IO ()
startGame = do
  putStrLn ("Qual o nome do seu bichinho?")
  nomeBichinho <- getLine
  let novoAnimal = Animal { name = nomeBichinho, stomach = 75, life = 100, caress = 100, energy = 100, turns = 1, isSleep = False, cleanness = 100 }
  menu novoAnimal False
  putStrLn (("\n" ++ nomeBichinho) ++ " morreu :/")

instructions :: IO ()
instructions = do
  putStrLn "O seu bichinho virtual precisa de ajuda para sobreviver "

menu :: Animal -> Bool -> IO Animal
menu animal False = do
 putStrLn ("")
 putStrLn ("1 - Alimentar")
 putStrLn ("2 - Limpar o ambiente")
 putStrLn ("3 - Desligar a luz")
 putStrLn ("4 - Acariciar/Brincar")
 putStrLn ("0 - Sair")
 option <- getLine
 executeOption animal (read option::Int) False

menu animal True = do
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
executeOption animal 0 anyValue = return (decreaseByRound animal)
executeOption animal _ anyValue = do
                           putStrLn("\nOpção Inválida! Tente novamente...")
                           putStr("\nPressione <Enter> para voltar ao menu...")
                           getChar
                           menu animal anyValue


decreaseByRound :: Animal -> Animal
decreaseByRound (Animal { name = n, stomach = s, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl}) = Animal {
  name = n,
  stomach = if(s <= 5) then 0 else (s - 5),
  life = if calculateLife l s e cl sleep <= 0 then 0 else calculateLife l s e cl sleep,
  caress = if(c <= 10) then 0 else (c - 10),
  energy = if (sleep) then e + 20 else e - 5,
  turns = (t + 1),
  isSleep = sleep,
  cleanness = cl
}

calculateLife:: Int -> Int -> Int -> Int-> Bool -> Int
calculateLife life stomach energy cleanness sleep = life - (calculateLifeDescontByEnergy energy) - (calculateLifeDescontByStomach stomach) - (calculateLifeDescontByCleanness cleanness) + (calculateLifeIncreaseBySleep sleep)

calculateLifeDescontByCleanness:: Int -> Int
calculateLifeDescontByCleanness cleanness = if (cleanness <= 80) then 20 else 0

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
              putStrLn (showStatus updatedAnimal)
              menu updatedAnimal False

calcFeed :: Animal -> Animal
calcFeed Animal { name = n, stomach = s, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl } = Animal {
  name = n,
  stomach = if(s >= 75) then 100 else (s + 25),
  life = l,
  caress = if(c >= 95) then 100 else (c + 5),
  energy = e,
  turns = t + 1,
  cleanness = if (cl <= 5) then 0 else (cl - 5),
  isSleep = sleep}

wakeUp :: Animal -> IO Animal
wakeUp animal = do
    let updatedAnimal = calcWakeUp animal
    putStrLn (showStatus updatedAnimal)
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
    isSleep = False}

-- Função sleep única: Ainda não há o estado "dormindo"
sleep :: Animal -> IO Animal
sleep animal = do
               let updatedAnimal = calcSleep animal
               putStrLn (showStatus updatedAnimal)
               menu updatedAnimal True

calcSleep :: Animal -> Animal
calcSleep (Animal { name = n, stomach = h, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl}) = Animal {
  name = n,
  stomach = h,
  life = l + 2,
  caress = c,
  energy = if(e >= 80) then 100 else (e + 20),
  turns = (t + 1),
  isSleep = True,
  cleanness = cl}


toCaress :: Animal -> IO Animal
toCaress animal = do
                  let updatedAnimal = calcToCaress animal
                  putStrLn (showStatus updatedAnimal)
                  menu updatedAnimal False

calcToCaress :: Animal -> Animal
calcToCaress (Animal { name = n, stomach = h, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl}) = Animal {
  name = n,
  stomach = h,
  life = l,
  caress = c + 40,
  energy = e ,
  turns = (t + 1),
  isSleep = sleep,
  cleanness = cl}

toClean :: Animal -> IO Animal
toClean animal = do
                  let updatedAnimal = calcToClean animal
                  putStrLn (showStatus updatedAnimal)
                  menu updatedAnimal False

calcToClean :: Animal -> Animal
calcToClean (Animal { name = n, stomach = h, life = l, caress = c, energy = e, turns = t, isSleep = sleep, cleanness = cl}) = Animal {
  name = n,
  stomach = h,
  life = l,
  caress = c,
  energy = e ,
  turns = (t + 1),
  isSleep = sleep,
  cleanness = if (cl >= 55) then 100 else cl + 45}

-- Sem função de limpar tela, por enquanto
showStatus :: Animal -> String
showStatus (Animal {name = n, stomach = h, life = l, caress = c, energy = e,
               turns = t, isSleep = sleep, cleanness = cl})
    | h <= 20 = "PERIGO EMINENTE!!! " ++ n ++ " está a com fome alta, alimente-o já!\n" ++ status
    | c <= 20 = "CARÊNCIA CRÍTICA!! Parece que você é um verdadeito BRUTA-MONTES, cuide do seu calango seu(a) cabra da peste!!\n" ++ status
    | e <= 30 = "SONO CRÍTICO!!! " ++ n ++ " precisa de um descanso ou não terá energia para escapar de predadores. Apague a luz!\n" ++ status
    | cl <= 80 = "LIMPE O AMBIENTE!!! " ++ n ++ " está cambaleando no lixo!\n" ++ status
    | otherwise = status
    where status = "Nome: " ++ n
                      ++ "\nVida: " ++ show l
                      ++ "% Estomago: " ++ show h
                      ++ "% Carinho: " ++ show c
                      ++ "% Energia: " ++ show e
                      ++ "% Limpeza do ambiente " ++ show  cl ++ "%"
