module Model exposing
  ( Model
  , renderables
  )

import Renderable exposing (Renderable)
import TileMap exposing (TileMap)
import Entity exposing (Entity)

type alias Model =
  { tileMap : TileMap
  , player : Entity
  }

renderables : Model -> List Renderable
renderables model =
  Entity.render model.player :: TileMap.render model.tileMap

entities : Model -> Entities
entities model =
  [ player
  ]
