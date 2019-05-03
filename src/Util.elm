module Util exposing
  ( Vector
  )

type alias Vector =
  { x : Float
  , y : Float
  }

zeroVector : Vector
zeroVector =
  { x = 0, y = 0 }
