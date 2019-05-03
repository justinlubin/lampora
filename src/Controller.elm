module Controller exposing
  ( Msg(..)
  , update
  , subscriptions
  )

import Browser.Events

import Params
import Model exposing (Model)
import System
import Draw.Canvas as Canvas

type Msg
  = Tick Float

updateFixed : Float -> Model -> Model
updateFixed delta model =
  if model.unsimulatedTime >= model.fixedTimestep then
    updateFixed
      (model.unsimulatedTime - model.fixedTimestep)
      { model
          | world =
              List.foldl
                (System.runFixed model.fixedTimestep)
                model.world
                model.world.fixedSystems
      }

  else
    model

updateDynamic : Model -> Model
updateDynamic model =
  { model
      | world =
          List.foldl
            System.runDynamic
            model.world
            model.world.dynamicSystems
  }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick delta ->
      let
        newModel =
          model
            |> updateFixed delta
            |> updateDynamic
      in
        ( newModel
        , Canvas.send <|
            Canvas.Draw
              delta
              newModel.world.renderables
        )

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.batch
    [ Browser.Events.onAnimationFrameDelta Tick
    ]
