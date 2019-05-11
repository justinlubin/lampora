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
    Html.div
      []
      [ Html.text "Welcome to the "
      , Html.text <|
          case model.game.world.followedEntity of
            Just eid ->
              case ECS.get eid model.game.world.boundingBox of
                Just bb ->
                  let
                    pos =
                      Vector.map round
                        { x = bb.x + bb.width / 2
                        , y = bb.y + bb.height / 2
                        }
                  in
                    zoneString <|
                      Tilemap.zone
                        pos
                        model.game.world.tilemap

                Nothing ->
                  ""

            Nothing ->
              ""
      , Html.text " Zone! Get ready!"
      ]
  else
    Html.button
      [ Events.onClick PlayClicked
      ]
      [ Html.text "Play!"
      ]
