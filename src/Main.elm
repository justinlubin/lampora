module Main exposing (main)

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
import Tilemap
import World exposing (World)
import Systems
import Entities

type alias Flags =
  ()

startLevel : List (List Int)
startLevel =
  [ [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0]
  , [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0]
  , [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
  ]

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
  , tilemap =
      Tilemap.fromList startLevel
  , keyManager =
      KeyManager.empty
  , followedEntity =
      Nothing
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
        (Entities.player { x = 4, y = 4 })
        game0

    world1 =
      game1.world

    game =
      { game1 | world = { world1 | followedEntity = Just player }}
  in
    game

init : Flags -> (Model, Cmd Msg)
init _ =
  ( { game =
        initGame
    }
  , Canvas.send <|
      Canvas.Init
        (Params.viewportWidth * Params.tileSize * Params.scale)
        (Params.viewportHeight * Params.tileSize * Params.scale)
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
