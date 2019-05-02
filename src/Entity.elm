module Entity exposing
  ( Entity
  , render
  )

import Params
import Renderable exposing (Renderable(..))

type alias Entity =
  { x : Float
  , y : Float
  }

render : Entity -> Renderable
render e =
  Rectangle
    { x = round e.x
    , y = round e.y
    , width = Params.tileSize
    , height = Params.tileSize
    , color = "red"
    }
