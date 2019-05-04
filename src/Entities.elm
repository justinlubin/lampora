module Entities exposing (..)

import Dict

import Vector
import Params
import ECS
import World exposing (World)

player : ECS.EntityId -> World -> World
player eid world =
  { world
      | appearance =
          ECS.add eid
            { color = "red" }
            world.appearance
      , boundingBox =
          ECS.add eid
            { x = 20
            , y = 20
            , width = toFloat Params.tileSize
            , height = toFloat Params.tileSize
            }
            world.boundingBox
      , physics =
          ECS.add eid
            { velocity = Vector.right (15 * 16)
            , acceleration = Vector.zero
            , grounded = False
            , walkSpeed = 15
            , jumpSpeed = 30
            }
            world.physics
  }
