module View exposing
  ( view
  )

import Html exposing (Html)

import Model exposing (Model)
import Controller exposing (Msg)

view : Model -> Html Msg
view model =
  Html.div
    []
    [ Html.text "My Game"
    ]
