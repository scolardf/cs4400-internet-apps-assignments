-- Main: create reusable socket, open TCP connection on port 4242, max 2 queued connections
module Main where

import Network.Socket
import System.IO
import Control.Exception
import Control.Concurrent
import Control.Monad (when)
import Control.Monad.Fix (fix)

type Msg = (Int, String)

main :: IO ()
main = do
  sock <- socket AF_INET Stream 0 -- creat socket
  setSocketOption sock ReuseAddr 1 -- make socket reusable immediately
  bind sock (SockAddrInet 4242 iNADDR_ANY) -- Listen on TCP port 4242
  listen sock 2
  chan <- newChan
  _ <- forkIO $ fix $ \loop -> do
    (_, _) <- readChan chan
    loop
  mainLoop sock chan 0

-- mainLoop:
mainLoop :: Socket -> Chan Msg -> Int -> IO ()
mainLoop sock chan msgNum = do
  conn <- accept sock -- accept connection and handle
  forkIO (runConn conn chan msgNum) -- run server's logic, split connection into own thread
  mainLoop sock chan $! msgNum + 1 -- repeat

runConn :: (Socket, SockAddr) -> Chan Msg -> Int -> IO ()
runConn (sock, _) chan msgNum = do
  let broadcast msg = writeChan chan (msgNum, msg)
  hdl <- socketToHandle sock ReadWriteMode
  hSetBuffering hdl NoBuffering

  hPutStrLn hdl "What is your name?: \n"
  name <- fmap init (hGetLine hdl)
  broadcast ("--> " ++ name ++ " entered chat.\n")
  hPutStrLn hdl ("Welcome, " ++ name ++ ".\n")

  commLine <- dupChan chan

  -- fork a thread for reading from duplicated channel
  reader <- forkIO $ fix $ \loop -> do
    (nextNum, line) <- readChan commLine
    when (msgNum /= nextNum) $ hPutStrLn hdl line
    loop

  handle (\(SomeException _) -> return ()) $ fix $ \loop -> do
    line <- fmap init (hGetLine hdl)
    case line of
      -- if exception caught, send message and break loop
      "quit" -> hPutStrLn hdl "Goodbye.\n"
      --else continue looping
      _      -> broadcast (name ++ ": " ++ line ++ "\n") >> loop

  killThread reader
  broadcast ("<-- " ++ name ++ " left.\n")
  hClose hdl
