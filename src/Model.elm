module Model exposing
  ( Model
  , renderables
  )

import Renderable exposing (Renderable)
import TileMap exposing (TileMap)

type alias Model =
  { tileMap : TileMap
  }

renderables : Model -> List Renderable
renderables model =
  TileMap.render model.tileMap
