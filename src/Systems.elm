module Systems exposing
  ( gravity
  , Axis(..)
  , movement
  , tilemapCollision

  , render
  )

import Utils
import ECS
import Params
import Vector
import World exposing (World)
import Components exposing (..)
import Draw.Renderable exposing (Renderable(..))
import Tilemap exposing (Tilemap, Tile(..))

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

type Axis
  = Horizontal
  | Vertical

movement : Axis -> ECS.FixedSystem World
movement axis dt world =
  let
    updater (phys, bbox) =
      case axis of
        Horizontal ->
          let
            newPhys =
              { phys |
                  velocity =
                    Vector.add
                      phys.velocity
                      (Vector.right <| phys.acceleration.x * dt)
              }

            newBbox =
              { bbox | x = bbox.x + newPhys.velocity.x * dt }
          in
            (newPhys, newBbox)

        Vertical ->
          let
            newPhys =
              { phys |
                  velocity =
                    Vector.add
                      phys.velocity
                      (Vector.up <| phys.acceleration.y * dt)
              }

            newBbox =
              { bbox | y = bbox.y + newPhys.velocity.y * dt }
          in
            (newPhys, newBbox)

    (newPhysics, newBoundingBox) =
      ECS.separate <|
        ECS.map
          updater
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

tilemapCollision : Axis -> ECS.FixedSystem World
tilemapCollision axis _ world =
  let
    collides : Tilemap -> (Physics, BoundingBox) -> Bool
    collides tilemap (phys, bbox) =
      let
        vel =
          phys.velocity
      in
        List.any ((==) True) <|
          Utils.for [0.01, 0.5, 0.99] <| \modifier ->
            case axis of
              Horizontal ->
                if vel.x == 0 then
                  False
                else
                  Tilemap.blocked
                    { x =
                        if vel.x < 0 then
                          bbox.x
                        else -- vel.x > 0
                          bbox.x + bbox.width
                    , y =
                        bbox.y + bbox.height * modifier
                    }
                    world.tilemap

              Vertical ->
                if vel.y == 0 then
                  False
                else
                  Tilemap.blocked
                    { x =
                        bbox.x + bbox.width * modifier
                    , y =
                        if vel.y < 0 then
                          bbox.y
                        else -- vel.y > 0
                          bbox.y + bbox.height
                    }
                    world.tilemap

    correctCollision : (Physics, BoundingBox) -> (Physics, BoundingBox)
    correctCollision (phys, bbox) =
      let
        vel =
          phys.velocity
      in
        case axis of
          Horizontal ->
            ( { phys
                  | velocity =
                      { vel | x = 0 }
              }
            , { bbox
                  | x =
                      if vel.x < 0 then
                        toFloat <| ceiling bbox.x
                      else if vel.y > 0 then
                        toFloat <| floor bbox.x
                      else
                        bbox.y
              }
            )

          Vertical ->
            ( { phys
                  | velocity =
                      { vel | y = 0 }
                  , grounded =
                      phys.grounded || vel.y > 0
              }
            , { bbox
                  | y =
                      if vel.y < 0 then
                        toFloat <| ceiling bbox.y
                      else if vel.y > 0 then
                        toFloat <| floor bbox.y
                      else
                        bbox.y
              }
            )

    (newPhysics, newBoundingBox) =
      ECS.separate <|
        ECS.map
          ( \pair ->
              if collides world.tilemap pair then
                correctCollision pair
              else
                pair
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
        { x = boundingBox.x * toFloat Params.tileSize
        , y = boundingBox.y * toFloat Params.tileSize
        , width = boundingBox.width * toFloat Params.tileSize
        , height = boundingBox.height * toFloat Params.tileSize
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
          { x = toFloat <| col * Params.tileSize
          , y = toFloat <| row * Params.tileSize
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
