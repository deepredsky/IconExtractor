{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module App (runApp, app) where

import           Control.Monad.IO.Class               (liftIO)
import           Extract
import           Network.Wai                          (Application)
import           Network.Wai.Middleware.RequestLogger
import qualified Web.Scotty                           as S


routes :: S.ScottyM ()
routes = do
  S.post "/" $ do
    url <- S.param "url"
    icons <- liftIO (getIcons url)
    S.json icons

app :: IO Application
app = S.scottyApp routes

runApp :: IO ()
runApp = S.scotty 4000 $ do
  S.middleware logStdoutDev
  routes
