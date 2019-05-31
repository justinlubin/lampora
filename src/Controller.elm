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
import Sfx
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
          , Audio.send Audio.Init
          , Sfx.send Sfx.Init
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

        -- SFX Hooks
        sfxs =
          let
            grounded : Model -> Bool
            grounded m =
              m.game.world.followedEntity
                |> Maybe.andThen (\e -> ECS.get e m.game.world.physics)
                |> Maybe.map (.grounded)
                |> Maybe.withDefault True

            yVel : Model -> Float
            yVel m =
              m.game.world.followedEntity
                |> Maybe.andThen (\e -> ECS.get e m.game.world.physics)
                |> Maybe.map (.velocity >> .y)
                |> Maybe.withDefault 0

            score : Model -> Int
            score m =
              m.game.world.score

            (beforeGrounded, nowGrounded) =
              (grounded model, grounded newModel)

            nowYVel =
              yVel newModel

            (beforeScore, nowScore) =
              (score model, score newModel)
          in
            ( if not nowGrounded && beforeGrounded && nowYVel < 0 then
                [ Sfx.Jump
                ]
              else
                []
            ) ++
            ( if nowScore > beforeScore then
                [ Sfx.Shard
                ]
              else
                []
            )
      in
        ( newModel
        , Cmd.batch <|
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
            ] ++
            ( List.map (Sfx.send << Sfx.Play) sfxs
            )
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
