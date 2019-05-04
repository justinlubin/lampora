module Components exposing
  ( Appearance
  , BoundingBox
  , Physics
  )

import Vector exposing (Vector)

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
