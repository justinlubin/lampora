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
  Html.div
    []
    [ Html.text "My Game"
    ]
