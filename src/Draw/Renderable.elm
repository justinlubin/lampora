module Draw.Renderable exposing
  ( Renderable(..)
  , encode
  )

import Json.Encode as E

type Renderable
  = Rectangle
      { x : Float
      , y : Float
      , width : Float
      , height : Float
      , color : String
      }

encode : Renderable -> E.Value
encode renderable =
  case renderable of
    Rectangle { x, y, width, height, color } ->
      E.object
        [ ("kind", E.string "rectangle")
        , ("x", E.float x)
        , ("y", E.float y)
        , ("width", E.float width)
        , ("height", E.float height)
        , ("color", E.string color)
        ]
