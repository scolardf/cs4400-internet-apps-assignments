{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_A1_Chat_Server (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "P:\\College\\cs4400-internet-apps-assignments\\A1 - Chat Server\\.cabal-sandbox\\bin"
libdir     = "P:\\College\\cs4400-internet-apps-assignments\\A1 - Chat Server\\.cabal-sandbox\\x86_64-windows-ghc-8.2.1\\A1-Chat-Server-0.1.0.0-Al3BetJyEjwBoZ8e8I2lTF"
dynlibdir  = "P:\\College\\cs4400-internet-apps-assignments\\A1 - Chat Server\\.cabal-sandbox\\x86_64-windows-ghc-8.2.1"
datadir    = "P:\\College\\cs4400-internet-apps-assignments\\A1 - Chat Server\\.cabal-sandbox\\x86_64-windows-ghc-8.2.1\\A1-Chat-Server-0.1.0.0"
libexecdir = "P:\\College\\cs4400-internet-apps-assignments\\A1 - Chat Server\\.cabal-sandbox\\A1-Chat-Server-0.1.0.0-Al3BetJyEjwBoZ8e8I2lTF\\x86_64-windows-ghc-8.2.1\\A1-Chat-Server-0.1.0.0"
sysconfdir = "P:\\College\\cs4400-internet-apps-assignments\\A1 - Chat Server\\.cabal-sandbox\\etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "A1_Chat_Server_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "A1_Chat_Server_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "A1_Chat_Server_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "A1_Chat_Server_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "A1_Chat_Server_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "A1_Chat_Server_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
