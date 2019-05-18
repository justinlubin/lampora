module Entities exposing (..)

import Dict

import Vector exposing (Vector)
import Params
import ECS
import World exposing (World)

type alias Constructor =
  ECS.EntityConstructor World

player : Vector Float -> Constructor
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
            , width = 0.875
            , height = 1.5
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

shard : Vector Float -> Constructor
shard pos eid world =
  { world
      | appearance =
          ECS.add eid
            { color = "blue" }
            world.appearance
      , boundingBox =
          ECS.add eid
            { x = pos.x + 0.25
            , y = pos.y + 0.25
            , width = 0.5
            , height = 0.5
            }
            world.boundingBox
      , shard =
          ECS.add eid
            {}
            world.shard
      , winningScore =
          world.winningScore + 1
  }
