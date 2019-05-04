module Controller exposing
  ( Msg(..)
  , update
  , subscriptions
  )

import Browser.Events
import Time
import Json.Decode as D

import KeyManager
import ECS
import Params
import Model exposing (Model)
import Draw.Canvas as Canvas

type Msg
  = Tick Float -- in milliseconds!
  | KeyDown String
  | KeyUp String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick deltaInMs ->
      let
        delta =
          deltaInMs / 1000

        newModel =
          { model
              | game =
                  model.game
                    |> ECS.simulateFixed delta
                    |> ECS.simulateDynamic
          }
      in
        ( newModel
        , Canvas.send <|
            Canvas.Draw
              delta
              newModel.game.world.renderables
        )

    KeyDown s ->
      let
        game =
          model.game

        world =
          game.world
      in
        ( { model
              | game =
                  { game
                      | world =
                          { world
                              | keyManager =
                                  KeyManager.addKey
                                  s
                                  model.game.world.keyManager
                          }
                  }
          }
        , Cmd.none
        )

    KeyUp s ->
      let
        game =
          model.game

        world =
          game.world
      in
        ( { model
              | game =
                  { game
                      | world =
                          { world
                              | keyManager =
                                  KeyManager.removeKey
                                  s
                                  model.game.world.keyManager
                          }
                  }
          }
        , Cmd.none
        )

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch
    [ -- Time.every 1000 (always (Tick 10))
      Browser.Events.onAnimationFrameDelta Tick
    , Browser.Events.onKeyDown (D.map KeyDown <| D.field "key" D.string)
    , Browser.Events.onKeyUp (D.map KeyUp <| D.field "key" D.string)
    ]
