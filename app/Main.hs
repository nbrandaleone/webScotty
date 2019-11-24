{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Scotty
import Network.Wai.Middleware.RequestLogger
import Data.Monoid (mconcat)

main = scotty 3000 $ do
  middleware logStdoutDev
  get "/health" $ do
    text "UP"

  get "/:word" $ do
    beam <- param "word"
    html $ mconcat ["<h1>Scotty, ", beam, " me up!</h1>"]
