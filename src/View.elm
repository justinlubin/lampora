module View exposing
  ( view
  )

import Html exposing (Html)
import Html.Events as Events

import Model exposing (Model)
import Controller exposing (Msg(..))

import ECS
import Vector
import Tilemap exposing (Zone(..))

zoneString : Zone -> String
zoneString z =
  case z of
    Outside ->
      "Outside"

    Cave ->
      "Cave"

    Unknown ->
      "Unknown"

view : Model -> Html Msg
view model =
  if model.playing then
    let
      (xString, yString) =
        case
          Maybe.andThen
            (\eid -> ECS.get eid model.game.world.boundingBox)
            model.game.world.followedEntity
        of
          Just { x, y } ->
            (String.fromFloat x, String.fromFloat y)

          Nothing ->
            ("?", "?")

    in
      Html.div
        []
        [ Html.text <|
            "Welcome to the "
              ++ zoneString model.game.world.zone
              ++ " Zone. Get ready! Score: "
              ++ (String.fromInt model.game.world.score)
              ++ "/"
              ++ (String.fromInt model.game.world.winningScore)
              ++ "."
        ]
  else
    Html.button
      [ Events.onClick PlayClicked
      ]
      [ Html.text "Play!"
      ]
