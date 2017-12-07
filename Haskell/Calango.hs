data Animal = Animal { name :: String
               , stomach :: Int
               , energy :: Int
               , life :: Int
               , turns :: Int
               , isSleep :: Bool
               } deriving (Show)

main = do
  putStrLn ("Bem vindo!\n")

  putStrLn ("Qual o nome do seu bichinho?")
  nomeBichinho <- getLine
  let novoAnimal = Animal { name = nomeBichinho, stomach = 75, life = 100, energy = 100, turns = 1, isSleep = False }
  menu novoAnimal

  putStrLn "\nO programa foi encerrado"

menu :: Animal -> IO Animal
menu animal = do
 putStrLn ("")
 putStrLn ("1 - Alimentar")
 putStrLn ("2 - Ir ao Banheiro")
 putStrLn ("3 - Dormir")
 putStrLn ("4 - Sair")
 option <- getLine
 executeOption animal (read option::Int)

executeOption :: Animal -> Int -> IO Animal
executeOption animal 1 = feed ( decreaseByRound animal)
executeOption animal 3 = sleep ( decreaseByRound animal)
executeOption animal 4 = return ( decreaseByRound animal)
executeOption animal _ = do
                           putStrLn("\nOpção Inválida! Tente novamente...")
                           putStr("\nPressione <Enter> para voltar ao menu...")
                           getChar
                           menu animal
      where animal = (decreaseByRound animal)


-- Ainda não há conceito de níveis, nem de experiência
-- As interações ainda não verifica estados dos atributos (se atingiu limite superior ou se chegou abaixo de 0)
feed :: Animal -> IO Animal
feed animal = do
              let updatedAnimal = calcFeed animal
              putStrLn (showStatus updatedAnimal)
              menu updatedAnimal

calcFeed :: Animal -> Animal
calcFeed Animal { name = n, stomach = s, life = l, energy = e, turns = t, isSleep = sleep } = Animal {
  name = n,
  stomach = if(s >= 75) then 100 else (s + 25),
  life = l,
  energy = e,
  turns = t + 1,
  isSleep = sleep}

decreaseByRound :: Animal -> Animal
decreaseByRound (Animal { name = n, stomach = s, life = l, energy = e, turns = t, isSleep = sleep}) = Animal {
  name = n,
  stomach = if(s <= 5) then 0 else (s - 5),
  life = if(s <= 15) then (l - 20) else l,
  energy = e,
  turns = (t + 1),
  isSleep = sleep}

-- Função sleep única: Ainda não há o estado "dormindo"
sleep :: Animal -> IO Animal
sleep animal = do
               let updatedAnimal = calcSleep animal
               putStrLn (showStatus updatedAnimal)
               menu updatedAnimal

calcSleep :: Animal -> Animal
calcSleep (Animal { name = n, stomach = h, life = l, energy = e, turns = t, isSleep = sleep}) = Animal {
  name = n,
  stomach = (h - 20),
  life = l,
  energy = e ,
  turns = (t + 1),
  isSleep = sleep}

-- Sem função de limpar tela, por enquanto
showStatus :: Animal -> String
showStatus (Animal {name = n, stomach = h, life = l, energy = e,
               turns = t, isSleep = sleep})
    | h <= 20 = "PERIGO EMINENTE!!! " ++ n ++ " está a com fome alta, alimente-o já!\n" ++ status
    | otherwise = status
    where status = "Nome: " ++ n ++ "\nVida: " ++ show l ++ " Estomago: " ++ show h ++ "% Energia: "
                      ++ show e ++ "%"
