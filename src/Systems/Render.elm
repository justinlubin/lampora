module Systems.Render exposing
  ( system
  )

import Array

import Params
import Draw.Renderable exposing (Renderable(..))
import World exposing (World, DynamicSystem(..))
import Components exposing (..)
import Tilemap exposing (Tile(..))

system : DynamicSystem
system =
  DS <| \world ->
    let
      renderEntity : Appearance -> BoundingBox -> Renderable
      renderEntity appearance boundingBox =
        Rectangle
          { x = boundingBox.x
          , y = boundingBox.y
          , width = boundingBox.width
          , height = boundingBox.height
          , color = appearance.color
          }

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
            { x = toFloat <| Params.tileSize * col
            , y = toFloat <| Params.tileSize * row
            , width = toFloat <| Params.tileSize
            , height = toFloat <| Params.tileSize
            , color = color
            }

      entityRenderables =
        World.foldl2
          ( \_ appearance boundingBox acc ->
              renderEntity appearance boundingBox :: acc
          )
          []
          world.appearance
          world.boundingBox

      tilemapRenderables =
        Tilemap.mapFlatten renderTile world.tilemap
    in
      { world
          | renderables =
              entityRenderables ++ tilemapRenderables
      }
