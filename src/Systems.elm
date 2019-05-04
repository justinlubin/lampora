module Systems exposing
  ( gravity
  , movement

  , render
  )

import ECS
import Params
import Vector
import World exposing (World)
import Components exposing (..)
import Draw.Renderable exposing (Renderable(..))
import Tilemap exposing (Tile(..))

--------------------------------------------------------------------------------
-- Fixed Systems
--------------------------------------------------------------------------------

gravity : ECS.FixedSystem World
gravity dt world=
  let
    newPhysics =
      ECS.map
        ( \physics ->
            { physics
                | acceleration =
                    { x = 0, y = Params.gravity }
            }
        )
        world.physics
  in
    { world | physics = newPhysics }

movement : ECS.FixedSystem World
movement dt world =
  let
    (newPhysics, newBoundingBox) =
      ECS.separate <|
        ECS.map
          ( \(p, bb) ->
              let
                newP =
                  { p |
                      velocity =
                        Vector.add
                          p.velocity
                          (Vector.scale dt p.acceleration)
                  }

                newBB =
                  { bb
                      | x = bb.x + newP.velocity.x * dt
                      , y = bb.y + newP.velocity.y * dt
                  }
              in
                ( newP
                , newBB
                )
          )
          ( ECS.combine
              world.physics
              world.boundingBox
          )
  in
    { world
        | physics =
            newPhysics
        , boundingBox =
            newBoundingBox
    }

--------------------------------------------------------------------------------
-- Dynamic Systems
--------------------------------------------------------------------------------

render : ECS.DynamicSystem World
render world =
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
      ECS.foldl
        ( \_ (appearance, boundingBox) acc ->
            renderEntity appearance boundingBox :: acc
        )
        []
        ( ECS.combine
            world.appearance
            world.boundingBox
        )

    tilemapRenderables =
      Tilemap.mapFlatten renderTile world.tilemap
  in
    { world
        | renderables =
            entityRenderables ++ tilemapRenderables
    }
