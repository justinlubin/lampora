port module Audio exposing
  ( Msg(..)
  , send
  )

import Json.Encode as E

import Params

port audio : E.Value -> Cmd msg

type Msg
  = Init (List String) String
  | Play String
  | Stop String

send : Msg -> Cmd msg
send canvasMsg =
  let
    (name, args) =
      case canvasMsg of
        Init tracks startingTrack ->
          ( "init"
          , [ ("tracks", E.list E.string tracks)
            , ("startingTrack", E.string startingTrack)
            ]
          )

        Play track ->
          ( "play"
          , [ ( "track"
              , E.string track
              )
            ]
          )

        Stop track ->
          ( "stop"
          , [ ( "track"
              , E.string track
              )
            ]
          )
  in
    audio <|
      E.object
        [ ("name", E.string name)
        , ("args", E.object args)
        ]
