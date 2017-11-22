menu :: Int -> Int
menu 1 = feed 3
menu 2 = bathroom
menu 3 = sleep 3
menu 4 = 4
menu n = n

-- Assume-se que as funções receberão como entrada o valor atual
-- dos atributos e retornar o novo valor

feed :: Int -> Int
feed n = n+2

bathroom :: Int
bathroom = 0

sleep :: Int -> Int
sleep s = s-2

showMenu = do
  putStrLn ("")
  putStrLn ("1 - Alimentar")
  putStrLn ("2 - Ir ao Banheiro")
  putStrLn ("3 - Dormir")
  putStrLn ("4 - Sair")
  option <- getLine
  if menu(read option) == 4
        then return ()
        else do{
            showMenu
          }

main = do

  putStrLn ("Bem vindo!")
  putStrLn ("")
  putStrLn ("Qual o nome do seu bichinho?")
  nomeBichinho <- getLine
  showMenu
  putStrLn ("")
  putStrLn "O programa foi encerrado"
