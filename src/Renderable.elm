module Renderable exposing
  ( Renderable(..)
  , encode
  )

import Json.Encode as E

type Renderable
  = Rectangle
      { x : Int
      , y : Int
      , width : Int
      , height : Int
      , color : String
      }

encode : Renderable -> E.Value
encode renderable =
  case renderable of
    Rectangle { x, y, width, height, color } ->
      E.object
        [ ("kind", E.string "rectangle")
        , ("x", E.int x)
        , ("y", E.int y)
        , ("width", E.int width)
        , ("height", E.int height)
        , ("color", E.string color)
        ]
