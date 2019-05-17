module Systems exposing
  ( gravity
  , Axis(..)
  , movement
  , tilemapCollision
  , input
  , zone

  , render
  )

import Utils
import KeyManager
import ECS
import Params
import Vector exposing (Vector)
import World exposing (World)
import Components exposing (..)
import Draw.Renderable exposing (Renderable(..))
import Tilemap exposing (Tilemap, Tile)

--------------------------------------------------------------------------------
-- Fixed Systems
--------------------------------------------------------------------------------

gravity : ECS.FixedSystem World
gravity dt world =
  let
    newPhysics =
      ECS.map
        ( \phys ->
            { phys
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
            ECS.merge newPhysics world.physics
        , boundingBox =
            ECS.merge newBoundingBox world.boundingBox
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
                    ( Vector.map floor
                        { x =
                            if vel.x < 0 then
                              bbox.x
                            else -- vel.x > 0
                              bbox.x + bbox.width
                        , y =
                            bbox.y + bbox.height * modifier
                        }
                    )
                    world.tilemap

              Vertical ->
                if vel.y == 0 then
                  False
                else
                  Tilemap.blocked
                    ( Vector.map floor
                        { x =
                            bbox.x + bbox.width * modifier
                        , y =
                            if vel.y < 0 then
                              bbox.y
                            else -- vel.y > 0
                              bbox.y + bbox.height
                        }
                    )
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
                      else if vel.x > 0 then
                        (toFloat << floor <| bbox.x + bbox.width) - bbox.width
                      else
                        bbox.x
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
                        (toFloat << floor <| bbox.y + bbox.height) - bbox.height
                      else
                        bbox.y
              }
            )

    (newPhysics, newBoundingBox) =
      ECS.separate <|
        ECS.map
          ( \(phys, bbox) ->
              let
                pair =
                  ( { phys | grounded = False }
                  , bbox
                  )
              in
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
            ECS.merge newPhysics world.physics
        , boundingBox =
            ECS.merge newBoundingBox world.boundingBox
    }

input : ECS.FixedSystem World
input _ world =
  let
    (_, newPhysics) =
      ECS.separate <|
        ECS.map
          ( \(uc, phys) ->
              let
                rightVel =
                  if KeyManager.isDown Params.keyRight world.keyManager then
                    phys.walkSpeed
                  else
                    0

                leftVel =
                  if KeyManager.isDown Params.keyLeft world.keyManager then
                    -phys.walkSpeed
                  else
                    0

                jumpVel =
                  if
                    phys.grounded
                      && KeyManager.isDown Params.keyJump world.keyManager
                  then
                    -phys.jumpSpeed
                  else
                    phys.velocity.y

                newVelocity =
                  { x =
                      rightVel + leftVel
                  , y =
                      jumpVel
                  }
              in
                ( uc
                , { phys | velocity = newVelocity }
                )
          )
          ( ECS.combine
              world.userControl
              world.physics
          )
  in
    { world | physics = ECS.merge newPhysics world.physics }

zone : ECS.FixedSystem World
zone _ world =
  { world
      | previousZone =
          world.zone

      , zone =
          case world.followedEntity of
            Just eid ->
              case ECS.get eid world.boundingBox of
                Just bb ->
                  let
                    pos =
                      Vector.map round
                        { x = bb.x + bb.width / 2
                        , y = bb.y + bb.height / 2
                        }
                  in
                    case Tilemap.zone pos world.tilemap of
                      Just z ->
                        z

                      Nothing ->
                        world.zone

                Nothing ->
                  world.zone

            Nothing ->
              world.zone
  }

--------------------------------------------------------------------------------
-- Dynamic Systems
--------------------------------------------------------------------------------

type alias Camera =
  { xMin : Int
  , yMin : Int
  , xMax : Int
  , yMax : Int
  , xOffset : Float
  , yOffset : Float
  }

worldCamera : Int -> Int -> World -> Camera
worldCamera viewportWidth viewportHeight world =
  let
    size =
      Tilemap.size world.tilemap

    (x, y) =
      case world.followedEntity of
        Just eid ->
          case ECS.get eid world.boundingBox of
            Just bb ->
              ( Utils.clamp
                  (0, toFloat <| size.x - viewportWidth)
                  (bb.x + bb.width / 2 - toFloat viewportWidth / 2)
              , Utils.clamp
                  (0, toFloat <| size.y - viewportHeight)
                  (bb.y + bb.height / 2 - toFloat viewportHeight / 2)
              )

            Nothing ->
              (0, 0)

        Nothing ->
          (0, 0)

    xMin =
      floor x

    yMin =
      floor y

    xMax =
      xMin + viewportWidth

    yMax =
      yMin + viewportHeight

    xOffset =
      x - toFloat xMin

    yOffset =
      y - toFloat yMin
  in
    { xMin = xMin
    , yMin = yMin
    , xMax = xMax
    , yMax = yMax
    , xOffset = xOffset
    , yOffset = yOffset
    }

render : Float -> Int -> Int -> ECS.DynamicSystem World
render scale viewportWidth viewportHeight world =
  let
    camera : Camera
    camera =
      worldCamera viewportWidth viewportHeight world

    unitLength : Float
    unitLength =
      Params.tileSize * scale

    renderTile : Vector Int -> Tile -> Renderable
    renderTile { x, y } t =
      Rectangle
        { x = (toFloat x - camera.xOffset) * unitLength
        , y = (toFloat y - camera.yOffset) * unitLength
        , width = unitLength
        , height = unitLength
        , color = t.color
        }

    tilemapRenderables : List Renderable
    tilemapRenderables =
      world.tilemap
        |> Tilemap.slice
             { x = camera.xMin, y = camera.yMin }
             { x = camera.xMax + 1, y = camera.yMax + 1 }
        |> Tilemap.mapFlatten renderTile

    renderEntity : Appearance -> BoundingBox -> Renderable
    renderEntity a bb =
      Rectangle
        { x = (bb.x - toFloat camera.xMin - camera.xOffset) * unitLength
        , y = (bb.y - toFloat camera.yMin - camera.yOffset) * unitLength
        , width = bb.width * unitLength
        , height = bb.height * unitLength
        , color = a.color
        }

    entityRenderables : List Renderable
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

  in
    { world
        | renderables =
            entityRenderables ++ tilemapRenderables
    }
