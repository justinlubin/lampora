module World exposing
  ( State(..)
  , World
  , destruct
  , win
  )

import KeyManager exposing (KeyManager)
import ECS
import Components exposing (..)
import Draw.Renderable exposing (Renderable)
import Tilemap exposing (Tilemap)

type State
  = Playing
  | Won

type alias World =
  { renderables : List Renderable

  -- Remember to update destruct!
  , appearance : ECS.Components Appearance
  , boundingBox : ECS.Components BoundingBox
  , physics : ECS.Components Physics
  , userControl : ECS.Components UserControl
  , shard : ECS.Components Shard

  , tilemap : Tilemap

  , keyManager : KeyManager

  , followedEntity : Maybe ECS.EntityId

  , zone : Tilemap.Zone
  , previousZone : Tilemap.Zone

  , score : Int
  , winningScore : Int

  , state : State
  }

destruct : ECS.EntityId -> World -> World
destruct eid world =
  let
    destroyIn =
      ECS.remove eid
  in
    { world
        | appearance =
            destroyIn world.appearance
        , boundingBox =
            destroyIn world.boundingBox
        , physics =
            destroyIn world.physics
        , userControl =
            destroyIn world.userControl
        , shard =
            destroyIn world.shard
    }

win : World -> World
win world =
  { world
      | physics = ECS.empty
      , userControl = ECS.empty
      , state = Won
  }
