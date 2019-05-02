port module Main exposing (main)

import Browser
import Model exposing (Model)
import View
import Controller exposing (Msg)
import Canvas

type alias Flags =
  ()

init : Flags -> (Model, Cmd Msg)
init _ =
  ( {}
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
