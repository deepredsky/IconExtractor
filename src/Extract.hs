{-# LANGUAGE OverloadedStrings #-}

module Extract where

import           Icon
import           Network.HTTP.Conduit (simpleHttp)
import           Text.HTML.DOM        (parseLBS)
import           Text.XML.Cursor      (Cursor, attribute, attributeIs, child,
                                       content, element, fromDocument, ($//),
                                       (&.//), (&//), (&|), (>=>))

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
