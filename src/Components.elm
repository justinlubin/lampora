module Components exposing
  ( Appearance
  , BoundingBox
  , Physics
  , UserControl
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
  { velocity : Vector Float
  , acceleration : Vector Float

  , grounded : Bool

  , walkSpeed : Float
  , jumpSpeed : Float
  }

type alias UserControl =
  {}
