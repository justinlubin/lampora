module Vector exposing
  ( Vector
  , zero
  , right
  , up
  , add
  , scale
  )

type alias Vector =
  { x : Float
  , y : Float
  }

zero : Vector
zero =
  { x = 0
  , y = 0
  }

right : Float -> Vector
right x =
  { x = x
  , y = 0
  }

up : Float -> Vector
up y =
  { x = 0
  , y = y
  }

add : Vector -> Vector -> Vector
add v1 v2 =
  { x = v1.x + v2.x
  , y = v1.y + v2.y
  }

scale : Float -> Vector -> Vector
scale c v =
  { x = c * v.x
  , y = c * v.y
  }
