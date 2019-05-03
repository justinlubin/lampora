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
          { x = round boundingBox.x
          , y = round boundingBox.y
          , width = round boundingBox.width
          , height = round boundingBox.height
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
            { x = Params.tileSize * col
            , y = Params.tileSize * row
            , width = Params.tileSize
            , height = Params.tileSize
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
