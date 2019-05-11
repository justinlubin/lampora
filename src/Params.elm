module Params exposing (..)

import KeyManager exposing (Key(..))

fixedTimestep : Float
fixedTimestep =
  1 / 60

tileSize : number
tileSize =
  16

viewportWidth : number
viewportWidth =
  16

viewportHeight : number
viewportHeight =
  16

scale : number
scale =
  2

gravity : number
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
