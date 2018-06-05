{-# LANGUAGE OverloadedStrings #-}

module Extract where

import qualified Data.Text            as T
import           Network.HTTP.Conduit (simpleHttp)
import           Text.HTML.DOM        (parseLBS)
import           Text.XML.Cursor      (Cursor, attribute, attributeIs, child,
                                       content, element, fromDocument, ($//),
                                       (&.//), (&//), (&|), (>=>))

data IconType = FavIcon | AppleIcon deriving (Show)

data Icon = Icon { source   :: T.Text
                 , iconType :: IconType
                 } deriving (Show)

processData = putStrLn . T.unpack . T.concat

cursorFor u = do
  page <- simpleHttp u
  return $ fromDocument $ parseLBS page

createIcon iconType source = Icon { source = source, iconType = iconType }

getIcon iconType cursor rel =
  map (createIcon iconType) $
  cursor
    $// element "link"
    >=> attributeIs "rel" rel
    &.// attribute "href"

getIcons :: String -> IO [Icon]
getIcons url = do
  cursor <- cursorFor url
  return $
    (getIcon AppleIcon cursor "apple-touch-icon")
    ++ (getIcon FavIcon cursor "shortcut icon")
