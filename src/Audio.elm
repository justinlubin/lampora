port module Audio exposing
  ( Track(..)
  , JsMsg(..)
  , ElmMsg(..)
  , send
  , listen
  )

import Json.Encode as E
import Json.Decode as D

import Params

port audioToJs : E.Value -> Cmd msg
port audioToElm : (E.Value -> msg) -> Sub msg

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
      "music/outside.mp3"

    Cave ->
      "music/cave.mp3"

tracklist : List Track -> E.Value
tracklist =
  List.map trackPath >> E.list E.string

type JsMsg
  = Init (List Track)
  | Set (List Track)

send : JsMsg -> Cmd msg
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
    audioToJs <|
      E.object
        [ ("name", E.string name)
        , ("args", E.object args)
        ]

type ElmMsg
  = Loaded
  | Unknown

listen : (ElmMsg -> msg) -> Sub msg
listen handler =
  audioToElm <| \val ->
    case D.decodeValue (D.field "name" D.string) val of
      Ok "loaded" ->
        handler Loaded

      _ ->
        handler Unknown
