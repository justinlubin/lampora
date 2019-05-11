module Vector exposing
  ( Vector
  , zero
  , right
  , up
  , add
  , scale
  , map
  )

type alias Vector a =
  { x : a
  , y : a
  }

zero : Vector number
zero =
  { x = 0
  , y = 0
  }

right : number -> Vector number
right x =
  { x = x
  , y = 0
  }

up : number -> Vector number
up y =
  { x = 0
  , y = y
  }

add : Vector number -> Vector number -> Vector number
add v1 v2 =
  { x = v1.x + v2.x
  , y = v1.y + v2.y
  }

scale : number -> Vector number -> Vector number
scale c v =
  { x = c * v.x
  , y = c * v.y
  }

map : (a -> b) -> Vector a -> Vector b
map f { x, y } =
  { x = f x
  , y = f y
  }
