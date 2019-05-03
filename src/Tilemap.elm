module Tilemap exposing
  ( Tilemap
  , Tile(..)
  , fromList
  , mapFlatten
  )

import Array exposing (Array)

import Params

type Tile
  = Dirt
  | Sky
  | Unknown

type Tilemap =
  TM (Array (Array Tile))

unwrap : Tilemap -> Array (Array Tile)
unwrap (TM inner) =
  inner

wrap : Array (Array Tile) -> Tilemap
wrap =
  TM

fromList : List (List Int) -> Tilemap
fromList rows =
  let
    fromInt i =
      case i of
        0 ->
          Dirt

        1 ->
          Sky

        _ ->
          Unknown
  in
    rows
      |> List.map (List.map fromInt)
      |> List.map Array.fromList
      |> Array.fromList
      |> wrap

mapFlatten : (Int -> Int -> Tile -> a) -> Tilemap -> List a
mapFlatten f =
  unwrap
    >> Array.indexedMap (\row -> Array.indexedMap (f row))
    >> Array.toList
    >> List.map (Array.toList)
    >> List.concat
