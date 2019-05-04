module Params exposing (..)

import KeyManager exposing (Key(..))

fixedTimestep : Float
fixedTimestep =
  1 / 60

tileSize : Int
tileSize =
  32

canvasWidth : Int
canvasWidth =
  600

canvasHeight : Int
canvasHeight =
  600

gravity : Float
gravity =
  120

keyLeft : Key
keyLeft =
  Left

keyRight : Key
keyRight =
  Right

keyJump : Key
keyJump =
  Space
