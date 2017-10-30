import System.environment

-- main function
main :: IO ()
main = getArgs >>= print . haqify . head

haqify s = "HaQ! " ++ s
