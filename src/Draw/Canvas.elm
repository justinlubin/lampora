port module Draw.Canvas exposing
  ( Msg(..)
  , send
  )

import Json.Encode as E

import Draw.Renderable as Renderable exposing (Renderable)

port canvas : E.Value -> Cmd msg

type Msg
  = Init Int Int
  | Draw Float (List Renderable)

send : Msg -> Cmd msg
send canvasMsg =
  let
    (name, args) =
      case canvasMsg of
        Init width height ->
          ( "init"
          , [ ("width", E.int width)
            , ("height", E.int height)
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
