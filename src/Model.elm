module Model exposing
  ( Model
  , loaded
  )

import ECS exposing (Game)
import World exposing (World)

type alias Model =
  { game : Game World
  , audioLoaded : Bool
  , playing : Bool
  }

loaded : Model -> Bool
loaded =
  .audioLoaded
