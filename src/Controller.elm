module Controller exposing
  ( Msg(..)
  , update
  , subscriptions
  )

import Model exposing (Model)
import Renderable exposing (Renderable)
import Canvas

type Msg
  = Draw (List Renderable)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Draw rs ->
      (model, Canvas.send (Canvas.Draw rs))

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none
