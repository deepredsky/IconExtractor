{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module App (runApp, app) where

import           Control.Monad.IO.Class               (liftIO)
import           Extract
import           Network.Wai                          (Application)
import           Network.Wai.Middleware.RequestLogger
import           Network.Wai.Middleware.Static
import qualified Web.Scotty                           as S

import           System.Environment                   (lookupEnv)


routes :: S.ScottyM ()
routes = do
  S.get "/" $ do
    S.file "index.html"

  S.post "/" $ do
    url <- S.param "url"
    icons <- liftIO (getIcons url)
    S.json icons

app :: IO Application
app = S.scottyApp routes

runApp :: IO ()
runApp = do
  p <- getPort
  S.scotty p $ do
    S.middleware logStdoutDev
    S.middleware $ staticPolicy (noDots >-> addBase "static")
    routes

getPort :: IO Int
getPort = do
  m <- lookupEnv "PORT"
  let p = case m of
        Nothing -> 4000
        Just s  -> read s
  return p
