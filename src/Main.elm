module Main exposing (main)

import Process
import Time
import Task
import Browser
import Dict

import Model exposing (Model)
import View
import Controller exposing (Msg)

import Draw.Canvas as Canvas

import KeyManager

import ECS

import Vector
import Params
import Tilemap exposing (Zone(..))
import World exposing (World)
import Systems
import Entities
import Level

-- Inspired by:
-- https://stackoverflow.com/questions/40599512/how-to-achieve-behavior-of-settimeout-in-elm
delay : Float -> msg -> Cmd msg
delay ms msg =
  Process.sleep ms
    |> Task.perform (\_ -> msg)

type alias Flags =
  ()

initWorld : World
initWorld =
  { renderables =
      []
  , appearance =
      ECS.empty
  , boundingBox =
      ECS.empty
  , physics =
      ECS.empty
  , userControl =
      ECS.empty
  , shard =
      ECS.empty
  , tilemap =
      Tilemap.fromList Level.level
  , keyManager =
      KeyManager.empty
  , followedEntity =
      Nothing
  , zone =
      Outside
  , score =
      0
  , winningScore =
      0
  , state =
      World.Playing
  , musicNeedsUpdate =
      True
  }

initGame : ECS.Game World
initGame =
  let
    game0 =
      { uId =
          ECS.initUId
      , fixedSystems =
          [ Systems.gravity
          , Systems.input
          , Systems.movement Systems.Horizontal
          , Systems.tilemapCollision Systems.Horizontal
          , Systems.movement Systems.Vertical
          , Systems.tilemapCollision Systems.Vertical
          , Systems.zone
          , Systems.userCollision
          ]
      , dynamicSystems =
          [ Systems.render
              Params.scale
              Params.viewportWidth
              Params.viewportHeight
          ]
      , unsimulatedTime =
          0
      , fixedTimestep =
          Params.fixedTimestep
      , world =
          initWorld
      }

    (player, game1) =
      ECS.createEntity
        (Entities.player { x = 5, y = 103 })
        game0

    world1 =
      game1.world

    game2 =
      { game1 | world = { world1 | followedEntity = Just player }}

    game =
      let
        shardAdder pos =
          ECS.createEntity (Entities.shard pos) >> Tuple.second
      in
        List.foldl
          shardAdder
          game2
          [ { x = 125, y = 102 }
          , { x = 130, y = 80 }
          , { x = 76,  y = 67 }
          , { x = 48,  y = 61 }
          , { x = 45,  y = 81 }
          , { x = 57,  y = 99 }
          ]
  in
    game

init : Flags -> (Model, Cmd Msg)
init _ =
  ( { game =
        initGame
    , audioLoaded =
        False
    , playing =
        False
    }
    -- Give JavaScript time to listen to the ports
  , delay 500 Controller.Init
  )

main : Program Flags Model Msg
main =
  Browser.element
    { init =
        init
    , view =
        View.view
    , update =
        Controller.update
    , subscriptions =
        Controller.subscriptions
    }
