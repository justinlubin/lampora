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
import Audio
import Music
import Tilemap exposing (Zone(..))

type Msg
  = Init
  | Tick Float -- in milliseconds!
  | KeyDown String
  | KeyUp String
  | AudioLoaded
  | AudioUnknown
  | PlayClicked

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Init ->
      ( model
      , Cmd.batch
          [ Canvas.send <|
              Canvas.Init
                Params.screenWidth
                Params.screenHeight
          , Audio.send <|
              Audio.Init <|
                Music.tracks
                  model.game.world.score
                  model.game.world.zone
          ]
      )

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
        , Cmd.batch
            [ Canvas.send <|
                Canvas.Draw
                  delta
                  newModel.game.world.renderables
            , if newModel.game.world.musicNeedsUpdate then
                Audio.send <|
                  Audio.Set <|
                    Music.tracks
                      newModel.game.world.score
                      newModel.game.world.zone
              else
                Cmd.none
            ]
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

    AudioLoaded ->
      ( { model | audioLoaded = True }
      , Cmd.none
      )

    AudioUnknown ->
      ( model
      , Cmd.none
      )

    PlayClicked ->
      ( { model | playing = True }
      , Cmd.none
      )

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch <|
    ( if model.playing then
        [ Browser.Events.onAnimationFrameDelta Tick
        ]
      else
        []
    ) ++
    [ Browser.Events.onKeyDown (D.map KeyDown <| D.field "key" D.string)
    , Browser.Events.onKeyUp (D.map KeyUp <| D.field "key" D.string)
    , Audio.listen <| \msg ->
        case msg of
          Audio.Loaded ->
            AudioLoaded

          Audio.Unknown ->
            AudioUnknown
    ]
