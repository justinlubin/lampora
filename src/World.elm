module World exposing
  ( World
  , EntityId
  , FixedSystem(..)
  , DynamicSystem(..)
  , initUId
  , createEntity
  , destroyEntity
  , foldl
  , foldl2
  )

import Dict exposing (Dict)

import Components exposing (..)
import Draw.Renderable exposing (Renderable)
import Tilemap exposing (Tilemap)

type alias EntityId =
  Int

type UId =
  UId Int

initUId : UId
initUId =
  UId 0

uIdToInt : UId -> Int
uIdToInt (UId n) =
  n

type alias World =
  { uid : UId

  , renderables : List Renderable

  , fixedSystems : List FixedSystem
  , dynamicSystems : List DynamicSystem

  -- Remember to update destroyEntity!
  , appearance : Dict EntityId Appearance
  , boundingBox : Dict EntityId BoundingBox
  , physics : Dict EntityId Physics

  , tilemap : Tilemap
  }

type FixedSystem =
  FS (Float -> World -> World)

type DynamicSystem =
  DS (World -> World)

createEntity : (EntityId -> World -> World) -> World -> World
createEntity construct world =
  construct (uIdToInt world.uid + 1) world

destroyEntity : EntityId -> World -> World
destroyEntity e world =
  let
    destroyIn =
      Dict.remove e
  in
    { world
        | appearance =
            destroyIn world.appearance
        , boundingBox =
            destroyIn world.boundingBox
        , physics =
            destroyIn world.physics
    }

foldl : (EntityId -> a -> acc -> acc) -> acc -> Dict EntityId a -> acc
foldl =
  Dict.foldl

foldl2 : (EntityId -> a -> b -> acc -> acc) -> acc -> Dict EntityId a -> Dict EntityId b -> acc
foldl2 f initialAcc cs1 cs2 =
  Dict.foldl
    ( \eid c1 ->
        cs2
          |> Dict.get eid
          |> Maybe.map (f eid c1)
          |> Maybe.withDefault identity
    )
    initialAcc
    cs1
