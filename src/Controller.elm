module Controller exposing
  ( Msg(..)
  , update
  , subscriptions
  )

import Browser.Events

import Model exposing (Model)
import Renderable exposing (Renderable)
import Canvas

type Msg
  = Draw Float

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

subscriptions : Model -> Sub Msg
subscriptions _ =
  Browser.Events.onAnimationFrameDelta Draw
