module Main exposing (main)

import Browser
import Html exposing (Html)

-- MODEL

type alias Flags =
  ()

type alias Model =
  {}

init : Flags -> (Model, Cmd Msg)
init _ =
  ( {}
  , Cmd.none
  )

-- UPDATE

type Msg
  = Basic

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Basic ->
      (model, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none


-- VIEW

view : Model -> Html Msg
view model =
  Html.div
    []
    [ Html.text "Hello, world!"
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
