module Entities exposing (..)

import Dict

import Vector exposing (Vector)
import Params
import ECS
import World exposing (World)

player : Vector Float -> ECS.EntityId -> World -> World
player pos eid world =
  { world
      | appearance =
          ECS.add eid
            { color = "red" }
            world.appearance
      , boundingBox =
          ECS.add eid
            { x = pos.x
            , y = pos.y
            , width = 1
            , height = 1
            }
            world.boundingBox
      , physics =
          ECS.add eid
            { velocity = Vector.zero
            , acceleration = Vector.zero
            , grounded = False
            , walkSpeed = 15
            , jumpSpeed = 30
            }
            world.physics
      , userControl =
          ECS.add eid
            {}
            world.userControl
  }
