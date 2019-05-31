port module Sfx exposing
  ( Sfx(..)
  , JsMsg(..)
  , send
  )

import Json.Encode as E
import Json.Decode as D

import Params

port sfxToJs : E.Value -> Cmd msg

type Sfx
  = Jump
  | Shard

allSfx : List Sfx
allSfx =
  [ Jump
  , Shard
  ]

sfxPath : Sfx -> String
sfxPath sfx =
  case sfx of
    Jump ->
      "sfx/jump.wav"

    Shard ->
      "sfx/shard.wav"

sfxList : List Sfx -> E.Value
sfxList =
  List.map sfxPath >> E.list E.string

type JsMsg
  = Init
  | Play Sfx

send : JsMsg -> Cmd msg
send sfxMsg =
  let
    (name, args) =
      case sfxMsg of
        Init ->
          ( "init"
          , [ ("allSfx", sfxList allSfx)
            ]
          )

        Play sfx ->
          ( "play"
          , [ ("sfx", E.string <| sfxPath sfx)
            ]
          )
  in
    sfxToJs <|
      E.object
        [ ("name", E.string name)
        , ("args", E.object args)
        ]
