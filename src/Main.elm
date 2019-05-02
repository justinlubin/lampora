module Main exposing (main)

import Browser
import Model exposing (Model)
import View
import Controller exposing (Msg)
import Canvas
import TileMap

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
  ( { player =
        { x = 12, y = 12 }
    , tileMap =
        TileMap.fromList startLevel
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
