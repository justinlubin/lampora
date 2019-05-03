module Entities exposing (..)

import Dict

import Params
import World exposing (World, EntityId)

player : EntityId -> World -> World
player eid world =
  { world
      | appearance =
          Dict.insert
            eid
            { color = "red" }
            world.appearance
      , boundingBox =
          Dict.insert
            eid
            { x = 20
            , y = 20
            , width = toFloat Params.tileSize
            , height = toFloat Params.tileSize
            }
            world.boundingBox
      , physics =
          Dict.insert
            eid
            { velocity = { x = 15 * 16, y = 0 }
            , acceleration = { x = 0, y = 0 }
            , grounded = False
            , walkSpeed = 15
            , jumpSpeed = 30
            }
            world.physics
  }
