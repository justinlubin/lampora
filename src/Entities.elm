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
            { x = 1
            , y = 1
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
  }
