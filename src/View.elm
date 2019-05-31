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

    Winter ->
      "Winter"

    Cave ->
      "Cave"

    Unknown ->
      "Unknown"

title : Html Msg
title =
  Html.h1
    [ Attr.id "main-title"
    ]
    [ Html.text "The Shards of Mt. Lampora"
    ]

score : Model -> Html Msg
score model =
  let
    shard class =
      Html.div
        [ Attr.class <|
            "shard " ++ class
        ]
        []
  in
    Html.div
      [ Attr.id "score"
      ] <|
      ( List.map
        (\_ -> shard "obtained")
        (List.range 1 model.game.world.score)
      ) ++
      ( List.map
        (\_ -> shard "remaining")
        (List.range (model.game.world.score + 1) model.game.world.winningScore)
      )

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
    Html.div
      ( [ Attr.id "play-button"
        ] ++
        ( if model.playing then
            [ Attr.class "hidden"
            ]
          else if loaded then
            [ Events.onClick PlayClicked
            ]
          else
            [ Attr.class "disabled"
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
    [ title
    , score model
    , screen model
    , playButton model
    ]
