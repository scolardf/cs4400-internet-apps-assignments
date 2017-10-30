import System.Environment

-- main function
main :: IO ()
main = getArgs >>= print . haqify . head

haqify s = "HaQ! " ++ s
