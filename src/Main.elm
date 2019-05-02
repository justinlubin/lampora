port module Main exposing (main)

import Browser
import Html exposing (Html)
import Html.Events as Events
import Json.Encode as E
import Json.Decode as D

-- MODEL

gameWidth : Int
gameWidth =
  600

gameHeight : Int
gameHeight =
  600

-- MODEL

type Renderable
  = Rectangle
      { x : Int
      , y : Int
      , width : Int
      , height : Int
      , color : String
      }

type alias Flags =
  ()

type alias Model =
  {}

init : Flags -> (Model, Cmd Msg)
init _ =
  ( {}
  , send Init
  )

-- UPDATE

type Msg
  = Draw1 (List Renderable)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Draw1 rs ->
      (model, send (Draw rs))


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  let
    testDraw =
      Draw1 [ Rectangle { x = 10, y = 10, width = 30, height = 50, color = "red"} ]
  in
  Html.div
    [ Events.onClick testDraw
    ]
    [ Html.text "My Game"
    ]


-- PORTS

port canvas : E.Value -> Cmd msg

type CanvasMsg
  = Init
  | Draw (List Renderable)

encodeRenderable : Renderable -> E.Value
encodeRenderable renderable =
  case renderable of
    Rectangle { x, y, width, height, color } ->
      E.object
        [ ("kind", E.string "rectangle")
        , ("x", E.int x)
        , ("y", E.int y)
        , ("width", E.int width)
        , ("height", E.int height)
        , ("color", E.string color)
        ]

send : CanvasMsg -> Cmd msg
send canvasMsg =
  let
    (name, args) =
      case canvasMsg of
        Init ->
          ( "init"
          , [ ("width", E.int gameWidth)
            , ("height", E.int gameHeight)
            ]
          )

        Draw renderables ->
          ( "draw"
          , [ ( "renderables"
              , E.list encodeRenderable renderables
              )
            ]
          )
  in
    canvas <|
      E.object
        [ ("name", E.string name)
        , ("args", E.object args)
        ]

-- MAIN

main : Program Flags Model Msg
main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
