module World exposing
  ( World
  , destruct
  )

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

    , tilemap : Tilemap
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
    }
