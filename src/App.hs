{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module App (runApp, app) where

import           Control.Monad.IO.Class (liftIO)
import           Extract
import           Network.Wai            (Application)
import qualified Web.Scotty             as S

routes :: S.ScottyM ()
routes = do
  S.get "/" $ do
    icons <- liftIO (getIcons "https://stackoverflow.com/")
    S.json icons

app :: IO Application
app = S.scottyApp routes

runApp :: IO ()
runApp = S.scotty 4000 routes
