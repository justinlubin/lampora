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
  = Bassoon
  | Chimes
  | Clarinet
  | Drumset
  | Flute
  | Oboe
  | Piano1
  | Piano2
  | SleighBells
  | Tuba
  | Violin
  | Violoncello

allTracks : List Track
allTracks =
  [ Bassoon
  , Chimes
  , Clarinet
  , Drumset
  , Flute
  , Oboe
  , Piano1
  , Piano2
  , SleighBells
  , Tuba
  , Violin
  , Violoncello
  ]

trackPath : Track -> String
trackPath track =
  case track of
    Bassoon ->
      "music/BG-Bassoon.mp3"

    Chimes ->
      "music/BG-Chimes.mp3"

    Clarinet ->
      "music/BG-Clarinet.mp3"

    Drumset ->
      "music/BG-Drumset.mp3"

    Flute ->
      "music/BG-Flute.mp3"

    Oboe ->
      "music/BG-Oboe.mp3"

    Piano1 ->
      "music/BG-Piano_1.mp3"

    Piano2 ->
      "music/BG-Piano_2.mp3"

    SleighBells ->
      "music/BG-Sleigh_Bells.mp3"

    Tuba ->
      "music/BG-Tuba.mp3"

    Violin ->
      "music/BG-Violin.mp3"

    Violoncello ->
      "music/BG-Violoncello.mp3"


tracklist : List Track -> E.Value
tracklist =
  List.map trackPath >> E.list E.string

type JsMsg
  = Init
  | Set (List Track)

send : JsMsg -> Cmd msg
send audioMsg =
  let
    (name, args) =
      case audioMsg of
        Init ->
          ( "init"
          , [ ("allTracks", tracklist allTracks)
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
