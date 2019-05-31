module Tilemap exposing
  ( Zone(..)
  , Tile
  , Tilemap
  , fromList
  , mapFlatten
  , blocked
  , size
  , slice
  , zone
  )

import Array exposing (Array)

import Vector exposing (Vector)

type Zone
  = Outside
  | Winter
  | Cave
  | Unknown

type alias Tile =
  { name : String
  , blocked : Bool
  , color : String
  , zone : Maybe Zone
  }

sky : Tile
sky =
  { name = "Sky"
  , blocked = False
  , color = "#5DADE2"
  , zone = Just Outside
  }

thinSky : Tile
thinSky =
  { name = "Thin Sky"
  , blocked = False
  , color = "#A1C9E3"
  , zone = Just Winter
  }

caveSky : Tile
caveSky =
  { name = "Cave Sky"
  , blocked = False
  , color = "#273746"
  , zone = Just Cave
  }

dirt : Tile
dirt =
  { name = "Dirt"
  , blocked = True
  , color = "#6E2C00"
  , zone = Nothing
  }

grass : Tile
grass =
  { name = "Grass"
  , blocked = True
  , color = "#2ECC71"
  , zone = Nothing
  }

snow : Tile
snow =
  { name = "Snow"
  , blocked = True
  , color = "#FFFFFF"
  , zone = Nothing
  }

rock : Tile
rock =
  { name = "Rock"
  , blocked = True
  , color = "#5D6D7E"
  , zone = Nothing
  }

unknown : Tile
unknown =
  { name = "Unknown"
  , blocked = True
  , color = "magenta"
  , zone = Just Unknown
  }

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
        0   -> sky
        81  -> thinSky
        78  -> caveSky
        41  -> dirt
        25  -> grass
        101 -> snow
        123 -> rock
        _   -> unknown
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

blocked : Vector Int -> Tilemap -> Bool
blocked { x, y } (TM rows) =
  rows
    |> Array.get y
    |> Maybe.andThen (Array.get x)
    |> Maybe.map .blocked
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

get : Vector Int -> Tilemap -> Tile
get {x, y} (TM rows) =
  rows
    |> Array.get y
    |> Maybe.andThen (Array.get x)
    |> Maybe.withDefault unknown

zone : Vector Int -> Tilemap -> Maybe Zone
zone pos =
  get pos >> .zone
