port module Canvas exposing
  ( Msg(..)
  , send
  )

import Json.Encode as E

import Params
import Renderable exposing (Renderable)

port canvas : E.Value -> Cmd msg

type Msg
  = Init
  | Draw (List Renderable)

send : Msg -> Cmd msg
send canvasMsg =
  let
    (name, args) =
      case canvasMsg of
        Init ->
          ( "init"
          , [ ("width", E.int Params.gameWidth)
            , ("height", E.int Params.gameHeight)
            ]
          )

        Draw renderables ->
          ( "draw"
          , [ ( "renderables"
              , E.list Renderable.encode renderables
              )
            ]
          )
  in
    canvas <|
      E.object
        [ ("name", E.string name)
        , ("args", E.object args)
        ]
