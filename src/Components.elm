module Components exposing
  ( ..
  )

import Util exposing (..)

type alias Appearance =
  { color : String
  }

type alias BoundingBox =
  { x : Float
  , y : Float
  , width : Float
  , height : Float
  }

type alias Physics =
  { velocity : Vector
  , acceleration : Vector

  , grounded : Bool

  , walkSpeed : Float
  , jumpSpeed : Float
  }
