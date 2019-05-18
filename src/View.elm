module View exposing
  ( view
  )

import Html exposing (Html)
import Html.Attributes as Attr
import Html.Events as Events

import Model exposing (Model)
import Controller exposing (Msg(..))

import ECS
import Vector
import Tilemap exposing (Zone(..))
import World

import Params

empty : Html msg
empty =
  Html.text ""

zoneString : Zone -> String
zoneString z =
  case z of
    Outside ->
      "Outside"

    Cave ->
      "Cave"

    Unknown ->
      "Unknown"

score : Model -> Html Msg
score model =
  Html.div
    [ Attr.id "score"
    ]
    [ Html.text <|
        "Score: "
          ++ String.fromInt model.game.world.score
          ++ "/"
          ++ String.fromInt model.game.world.winningScore
    ]

screen : Model -> Html Msg
screen model =
  let
    showWhen : World.State -> Html.Attribute Msg
    showWhen state =
      if state == model.game.world.state then
        Attr.style "opacity" "1"
      else
        Attr.style "opacity" "0"
  in
    Html.div
      [ Attr.id "screen"
      , Attr.style "width" <|
          String.fromInt Params.screenWidth ++ "px"
      , Attr.style "height" <|
          String.fromInt Params.screenHeight ++ "px"
      ]
      [ Html.canvas
          [ Attr.id "game"
          ]
          []
      , Html.div
          [ Attr.id "won-overlay"
          , Attr.class "overlay"
          , showWhen World.Won
          ]
          [ Html.text "You win!"
          ]
      ]

playButton : Model -> Html Msg
playButton model =
  let
    loaded =
      Model.loaded model
  in
    Html.button
      ( [ Attr.id "play-button"
        ] ++
        ( if model.playing then
            [ Attr.class "hidden"
            ]
          else if loaded then
            [ Events.onClick PlayClicked
            ]
          else
            [ Attr.disabled True
            ]
        )
      )
      ( if loaded then
          [ Html.text "Play!"
          ]
        else
          [ Html.text "Loading..."
          ]
      )

view : Model -> Html Msg
view model =
  Html.div
    [ Attr.id "arcade"
    ]
    [ score model
    , screen model
    , playButton model
    ]
