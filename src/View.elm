module View exposing
  ( view
  )

import Html exposing (Html)
import Html.Events as Events

import Model exposing (Model)
import Controller exposing (Msg(..))
import Renderable exposing (Renderable(..))

view : Model -> Html Msg
view model =
  let
    testDraw =
      Draw [ Rectangle { x = 10, y = 10, width = 30, height = 50, color = "red"} ]
  in
  Html.div
    [ Events.onClick testDraw
    ]
    [ Html.text "My Game"
    ]
