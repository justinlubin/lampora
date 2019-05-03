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
            { x = Params.tileSize * col
            , y = Params.tileSize * row
            , width = Params.tileSize
            , height = Params.tileSize
            , color = color
            }

      entityRenderables =
        World.foldl2
          ( \entity appearance boundingBox acc ->
              renderEntity appearance boundingBox :: acc
          )
          []
          world.appearances
          world.boundingBoxes

      tilemapRenderables =
        Tilemap.mapFlatten renderTile world.tilemap
    in
      { world
          | renderables =
              tilemapRenderables ++ entityRenderables
      }
