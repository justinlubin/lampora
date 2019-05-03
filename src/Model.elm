module Model exposing
  ( Model
  )

import World exposing (World)

type alias Model =
  { world : World
  , unsimulatedTime : Float
  , fixedTimestep : Float
  }
