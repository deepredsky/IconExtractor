{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Icon where


import           Data.Aeson
import qualified Data.Text    as T
import           GHC.Generics

data IconType = FavIcon | AppleIcon deriving (Show, Generic)

data Icon = Icon { source   :: T.Text
                 , iconType :: IconType
                 } deriving (Show, Generic)

instance ToJSON Icon where
    toEncoding = genericToEncoding defaultOptions

instance ToJSON IconType
