module TileMap exposing
  ( TileMap
  , fromList
  , render
  )

import Array exposing (Array)

import Params
import Renderable exposing (Renderable(..))

type Tile
  = Dirt
  | Sky
  | Unknown

type TileMap =
  TM (Array (Array Tile))

fromList : List (List Int) -> TileMap
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
      |> TM

renderTile : Int -> Int -> Tile -> Renderable
renderTile row col t =
  let
    color =
      case t of
        Dirt ->
          "brown"

        Sky ->
          "blue"

        Unknown ->
          "red"
  in
    Rectangle
      { x = Params.tileSize * col
      , y = Params.tileSize * row
      , width = Params.tileSize
      , height = Params.tileSize
      , color = color
      }

render : TileMap -> List Renderable
render (TM rows) =
  rows
    |> Array.indexedMap
         (\row -> Array.indexedMap (renderTile row))
    |> Array.toList
    |> List.map Array.toList
    |> List.concat
