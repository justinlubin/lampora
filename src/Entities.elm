module Entities exposing (..)

import Dict

import Params
import World exposing (World, EntityId)

player : EntityId -> World -> World
player eid world =
  { world
      | appearances =
          Dict.insert
            eid
            { color = "red" }
            world.appearances
      , boundingBoxes =
          Dict.insert
            eid
            { x = 20
            , y = 20
            , width = Params.tileSize
            , height = Params.tileSize
            }
            world.boundingBoxes
  }
