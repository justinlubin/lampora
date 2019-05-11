module Tilemap exposing
  ( Tilemap
  , Tile(..)
  , fromList
  , mapFlatten
  , blocked
  , size
  , slice
  )

import Array exposing (Array)

import Vector exposing (Vector)

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

mapFlatten : (Vector Int -> Tile -> a) -> Tilemap -> List a
mapFlatten f =
  unwrap
    >> Array.indexedMap
         (\row -> Array.indexedMap (\col -> f { x = col, y = row }))
    >> Array.toList
    >> List.map (Array.toList)
    >> List.concat

tileBlocked : Tile -> Bool
tileBlocked t =
  case t of
    Dirt ->
      True

    Sky ->
      False

    Unknown ->
      True

blocked : Vector Int -> Tilemap -> Bool
blocked { x, y } (TM rows) =
  rows
    |> Array.get y
    |> Maybe.andThen (Array.get x)
    |> Maybe.map (\t -> tileBlocked t)
    |> Maybe.withDefault False

size : Tilemap -> Vector Int
size (TM rows) =
  case Array.get 0 rows of
    Just row ->
      { x = Array.length row
      , y = Array.length rows
      }

    Nothing ->
      Vector.zero

slice : Vector Int -> Vector Int -> Tilemap -> Tilemap
slice start end (TM rows) =
  rows
    |> Array.slice start.y end.y
    |> Array.map (Array.slice start.x end.x)
    |> TM
