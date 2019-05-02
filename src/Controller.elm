module Controller exposing
  ( Msg(..)
  , update
  , subscriptions
  )

import Browser.Events
import Time

import Params
import Model exposing (Model)
import Renderable exposing (Renderable)
import Canvas

type Msg
  = Draw Float
  | StepPhysics Time.Posix

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Draw delta ->
      ( model
      , Canvas.send <|
          Canvas.Draw
            delta
            (Model.renderables model)
      )

    StepPhysics time ->
      ( model
      , Cmd.none
      )

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch
    [ Browser.Events.onAnimationFrameDelta Draw
    , Time.every Params.fixedDelta StepPhysics
    ]
