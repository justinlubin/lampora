module Systems.Gravity exposing
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
      newPhysicsDict =
        World.foldl
          ( \eid physics ->
              Dict.insert
                eid
                { physics
                    | acceleration =
                        { x = 0, y = Params.gravity }
                }
          )
          Dict.empty
          world.physics
    in
      { world | physics = newPhysicsDict }
