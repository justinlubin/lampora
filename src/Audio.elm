port module Audio exposing
  ( Track(..)
  , Msg(..)
  , send
  )

import Json.Encode as E

import Params

port audio : E.Value -> Cmd msg

type Track
  = Outside
  | Cave

allTracks : List Track
allTracks =
  [ Outside, Cave ]

trackPath : Track -> String
trackPath track =
  case track of
    Outside ->
      "outside.mp3"

    Cave ->
      "cave.mp3"

tracklist : List Track -> E.Value
tracklist =
  List.map trackPath >> E.list E.string

type Msg
  = Init (List Track)
  | Set (List Track)

send : Msg -> Cmd msg
send canvasMsg =
  let
    (name, args) =
      case canvasMsg of
        Init startingTracklist ->
          ( "init"
          , [ ("allTracks", tracklist allTracks)
            , ("startingTracklist", tracklist startingTracklist)
            ]
          )

        Set theTracklist ->
          ( "set"
          , [ ("tracklist", tracklist theTracklist)
            ]
          )
  in
    audio <|
      E.object
        [ ("name", E.string name)
        , ("args", E.object args)
        ]
