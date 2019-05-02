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
  | Draw Float (List Renderable)

send : Msg -> Cmd msg
send canvasMsg =
  let
    (name, args) =
      case canvasMsg of
        Init ->
          ( "init"
          , [ ("width", E.int Params.canvasWidth)
            , ("height", E.int Params.canvasHeight)
            ]
          )

        Draw delta renderables ->
          ( "draw"
          , [ ( "delta"
              , E.float delta
              )
            , ( "renderables"
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
