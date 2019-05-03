module Systems.Movement exposing
  ( system
  )

import Dict

import Params
import World exposing (World, FixedSystem(..))
import Components exposing (..)

system : FixedSystem
system =
  FS <| \dt world ->
    let
      (newBoundingBoxDict, newPhysicsDict) =
        World.foldl2
          ( \eid boundingBox physics (bbAcc, pAcc) ->
              let
                oldVelocity =
                  physics.velocity

                newPhysics =
                  { physics
                      | velocity =
                          { oldVelocity
                              | x = oldVelocity.x + physics.acceleration.x * dt
                              , y = oldVelocity.y + physics.acceleration.y * dt
                          }
                  }

                newBoundingBox =
                  { boundingBox
                      | x = boundingBox.x + newPhysics.velocity.x * dt
                      , y = boundingBox.y + newPhysics.velocity.y * dt
                  }

              in
                ( Dict.insert eid newBoundingBox bbAcc
                , Dict.insert eid newPhysics pAcc
                )
          )
          (Dict.empty, Dict.empty)
          world.boundingBox
          world.physics
    in
      { world
          | boundingBox =
              newBoundingBoxDict
          , physics =
              newPhysicsDict
      }
