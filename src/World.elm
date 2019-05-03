module World exposing
  ( ..
  )

import Dict exposing (Dict)

import Components exposing (..)
import Draw.Renderable exposing (Renderable)
import Tilemap exposing (Tilemap)

type alias Entity =
  Int

type alias World =
  { uid : Int

  , renderables : List Renderable

  , fixedSystems : List FixedSystem
  , dynamicSystems : List DynamicSystem

  , appearances : Dict Entity Appearance
  , boundingBoxes : Dict Entity BoundingBox

  , tilemap : Tilemap
  }

type FixedSystem =
  FS (Float -> World -> World)

type DynamicSystem =
  DS (World -> World)

createEntity : World -> World
createEntity world =
  Debug.todo "createEntity"

destroyEntity : Entity -> World -> World
destroyEntity e world =
  Debug.todo "destroyEntity"

foldl : (Entity -> a -> acc -> acc) -> acc -> Dict Entity a -> acc
foldl =
  Dict.foldl

foldl2 : (Entity -> a -> b -> acc -> acc) -> acc -> Dict Entity a -> Dict Entity b -> acc
foldl2 f initialAcc cs1 cs2 =
  Dict.foldl
    ( \entity c1 ->
        cs2
          |> Dict.get entity
          |> Maybe.map (f entity c1)
          |> Maybe.withDefault identity
    )
    initialAcc
    cs1
