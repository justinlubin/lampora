module Model exposing
  ( Model
  )

import ECS exposing (Game)
import World exposing (World)

type alias Model =
  { game : Game World
  , playing : Bool
  }
