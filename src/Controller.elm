module Controller exposing
  ( Msg(..)
  , update
  , subscriptions
  )

import Browser.Events
import Time

import Params
import Model exposing (Model)
import System
import Draw.Canvas as Canvas

type Msg
  = Tick Float

updateFixed : Float -> Model -> Model
updateFixed delta model =
  let
    simulate m =
      if m.unsimulatedTime >= m.fixedTimestep then
        simulate
          { m
              | world =
                  List.foldl
                    (System.runFixed (m.fixedTimestep / 1000))
                    m.world
                    m.world.fixedSystems
              , unsimulatedTime =
                  m.unsimulatedTime - m.fixedTimestep
          }

      else
        m
  in
    simulate
      { model
          | unsimulatedTime =
              model.unsimulatedTime + delta
      }


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
    [ -- Time.every 1000 (always (Tick 10))
      Browser.Events.onAnimationFrameDelta Tick
    ]
