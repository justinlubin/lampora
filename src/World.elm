module World exposing
  ( World
  , destruct
  )

import KeyManager exposing (KeyManager)
import ECS
import Components exposing (..)
import Draw.Renderable exposing (Renderable)
import Tilemap exposing (Tilemap)

type alias World =
  { renderables : List Renderable

  -- Remember to update destruct!
  , appearance : ECS.Components Appearance
  , boundingBox : ECS.Components BoundingBox
  , physics : ECS.Components Physics
  , userControl : ECS.Components UserControl

  , tilemap : Tilemap

  , keyManager : KeyManager

  , followedEntity : Maybe ECS.EntityId

  , zone : Tilemap.Zone
  , previousZone : Tilemap.Zone
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
    }
