module Main exposing (main)

import Browser
import Dict

import Model exposing (Model)
import View
import Controller exposing (Msg)

import Draw.Canvas as Canvas

import ECS

import Params
import Tilemap
import World exposing (World)
import Systems
import Entities

type alias Flags =
  ()

startLevel : List (List Int)
startLevel =
  [ [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  , [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  , [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  , [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  , [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  , [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  , [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  , [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
  , tilemap =
      Tilemap.fromList startLevel
  }

initGame : ECS.Game World
initGame =
  { uId =
      ECS.initUId
  , fixedSystems =
      [ Systems.gravity
      , Systems.movement
      ]
  , dynamicSystems =
      [ Systems.render
      ]
  , unsimulatedTime =
      0
  , fixedTimestep =
      Params.fixedTimestep
  , world =
      initWorld
  } |> ECS.createEntity Entities.player

init : Flags -> (Model, Cmd Msg)
init _ =
  ( { game =
        initGame
    }
  , Canvas.send Canvas.Init
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
