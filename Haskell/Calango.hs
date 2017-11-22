main = do

  print ("Bem vindo!")
  print ("Qual o nome do seu bichinho?")
  input <- getLine
  putStrLn ("Nome do bichinho: " ++ input)
