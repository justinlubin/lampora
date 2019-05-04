module Controller exposing
  ( Msg(..)
  , update
  , subscriptions
  )

import Browser.Events
import Time

import ECS
import Params
import Model exposing (Model)
import Draw.Canvas as Canvas

type Msg
  = Tick Float -- in milliseconds!

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

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch
    [ -- Time.every 1000 (always (Tick 10))
      Browser.Events.onAnimationFrameDelta Tick
    ]
