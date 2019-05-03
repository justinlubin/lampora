module Main exposing (main)

import Browser
import Dict

import Model exposing (Model)
import View
import Controller exposing (Msg)
import Params
import Draw.Canvas as Canvas
import Tilemap
import Systems.Render as Render
import Systems.Movement as Movement
import Systems.Gravity as Gravity
import Entities
import World

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

type alias Flags =
  ()

init : Flags -> (Model, Cmd Msg)
init _ =
  ( { world =
        { uid =
            World.initUId
        , renderables =
            []
        , fixedSystems =
            [ Gravity.system
            , Movement.system
            ]
        , dynamicSystems =
            [ Render.system
            ]
        , appearance =
            Dict.empty
        , boundingBox =
            Dict.empty
        , physics =
            Dict.empty
        , tilemap =
            Tilemap.fromList startLevel
        } |> World.createEntity Entities.player
    , unsimulatedTime =
        0
    , fixedTimestep =
        Params.fixedDelta
    }
  , Canvas.send Canvas.Init
  )

main : Program Flags Model Msg
main =
  Browser.element
    { init = init
    , view = View.view
    , update = Controller.update
    , subscriptions = Controller.subscriptions
    }
