data Animal = Animal { nome :: String  
               , hunger :: Int 
               , energy :: Int
               , evolution :: Int  
               , bathroom :: Int
               , isSleep :: Bool
               } deriving (Show) 


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
executeOption animal 1 = feed animal
executeOption animal 2 = goToBathroom animal
executeOption animal 3 = sleep animal
executeOption animal 4 = return animal
executeOption animal _ = do
                            putStrLn("\nOpção Inválida! Tente novamente...")
                            putStr("\nPressione <Enter> para voltar ao menu...")
                            getChar
                            menu animal

-- Ainda não há conceito de níveis, nem de experiência                          
-- As interações ainda não verifica estados dos atributos (se atingiu limite superior ou se chegou abaixo de 0)                            
feed :: Animal -> IO Animal
feed (Animal {nome = n, hunger = h, energy = e,
              evolution = ev, bathroom = b,
              isSleep = sleep}) = do 
                                      let updatedAnimal = Animal {nome = n, hunger = h-2, energy = e-1, evolution = ev,bathroom = b+1,isSleep = sleep} 
                                      putStrLn (showStatus updatedAnimal)
                                      menu updatedAnimal

goToBathroom :: Animal -> IO Animal
goToBathroom (Animal {nome = n, hunger = h, energy = e,
              evolution = ev, bathroom = b,
              isSleep = sleep}) = do 
                                      let updatedAnimal = Animal {nome = n, hunger = h, energy = e-1, evolution = ev,bathroom = 0,isSleep = sleep}
                                      putStrLn (showStatus updatedAnimal)
                                      menu updatedAnimal

-- Função sleep única: Ainda não há o estado "dormindo"                                      
sleep :: Animal -> IO Animal
sleep (Animal {nome = n, hunger = h, energy = e,
              evolution = ev, bathroom = b,
              isSleep = sleep}) = do 
                                      let updatedAnimal = Animal {nome = n, hunger = h+1, energy = e+2, evolution = ev,bathroom = b+1,isSleep = sleep}
                                      putStrLn (showStatus updatedAnimal)
                                      menu updatedAnimal

-- Sem função de limpar tela, por enquanto                                      
showStatus :: Animal -> String
showStatus (Animal {nome = n, hunger = h, energy = e,
              evolution = ev, bathroom = b,
              isSleep = sleep}) = "Nome: " ++ n ++ "\nFome: " ++ show h ++ " Energia: "
                                  ++ show e ++ " Evolucao: " ++ show ev ++ " Banheiro " ++
                                  show b                         
  
          
main = do

  putStrLn ("Bem vindo!")
  putStrLn ("")
  putStrLn ("Qual o nome do seu bichinho?")
  nomeBichinho <- getLine
  let novoAnimal = Animal {nome=nomeBichinho, hunger = 2, energy = 6, evolution = 1,bathroom = 0,isSleep = False}  
  menu novoAnimal
  putStrLn ("")
  putStrLn "O programa foi encerrado"
