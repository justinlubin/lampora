module System exposing
  ( ..
  )

import World exposing (World, FixedSystem(..), DynamicSystem(..))

runFixed : Float -> FixedSystem -> World -> World
runFixed dt (FS fs) world =
  fs dt world

runDynamic : DynamicSystem -> World -> World
runDynamic (DS ds) world =
  ds world
