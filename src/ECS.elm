module ECS exposing
  ( EntityId
  , Components
  , empty
  , add
  , remove
  , combine
  , separate
  , map
  , foldl
  , FixedSystem
  , DynamicSystem
  , initUId
  , Game
  , createEntity
  , destroyEntity
  , simulateFixed
  , simulateDynamic
  )

import Dict exposing (Dict)

--------------------------------------------------------------------------------
-- Entities
--------------------------------------------------------------------------------

type alias EntityId =
  Int

--------------------------------------------------------------------------------
-- Components
--------------------------------------------------------------------------------

type Components a =
  C (Dict EntityId a)

empty : Components a
empty =
  C <|
    Dict.empty

add : EntityId -> a -> Components a -> Components a
add eid c (C dict) =
  C <|
    Dict.insert eid c dict

remove : EntityId -> Components a -> Components a
remove eid (C dict) =
  C <|
    Dict.remove eid dict

combine : Components a -> Components b -> Components (a, b)
combine (C dict1) (C dict2) =
  C <|
    Dict.foldl
      ( \eid c1 newDict ->
          case Dict.get eid dict2 of
            Nothing ->
              newDict

            Just c2 ->
              Dict.insert eid (c1, c2) newDict
      )
      Dict.empty
      dict1

separate : Components (a, b) -> (Components a, Components b)
separate (C dict) =
  let
    (newDict1, newDict2) =
      Dict.foldl
        ( \eid (c1, c2) (acc1, acc2) ->
            ( Dict.insert eid c1 acc1
            , Dict.insert eid c2 acc2
            )
        )
        (Dict.empty, Dict.empty)
        dict
  in
    (C newDict1, C newDict2)

map : (a -> a) -> Components a -> Components a
map f (C dict) =
  C <|
    Dict.map (\_ x -> f x) dict

foldl : (EntityId -> a -> acc -> acc) -> acc -> Components a -> acc
foldl f initialAcc (C dict) =
  Dict.foldl f initialAcc dict

--------------------------------------------------------------------------------
-- Systems
--------------------------------------------------------------------------------

-- In seconds!
type alias Delta =
  Float

type alias FixedSystem world =
  Delta -> world -> world

type alias DynamicSystem world =
  world -> world

runFixed : Delta -> FixedSystem world -> world -> world
runFixed dt fs w =
  fs dt w

runDynamic : DynamicSystem world -> world -> world
runDynamic ds w =
  ds w

--------------------------------------------------------------------------------
-- Game
--------------------------------------------------------------------------------

type UId =
  UId Int

initUId : UId
initUId =
  UId 0

type alias Game w =
  { uId : UId

  , fixedSystems : List (FixedSystem w)
  , dynamicSystems : List (DynamicSystem w)
  , unsimulatedTime : Delta
  , fixedTimestep : Delta

  , world : w
  }

createEntity : (EntityId -> world -> world) -> Game world -> Game world
createEntity construct game =
  let
    (UId n) =
      game.uId

    newWorld =
      construct (n + 1) game.world
  in
    { game
        | uId =
            UId (n + 1)
        , world =
            newWorld
    }

destroyEntity :
  (EntityId -> world -> world) -> EntityId -> Game world -> Game world
destroyEntity destruct eid game =
  { game
      | world =
          destruct eid game.world
  }

simulateFixed : Delta -> Game world -> Game world
simulateFixed dt game =
  let
    simulate g =
      if g.unsimulatedTime >= g.fixedTimestep then
        simulate
          { g
              | world =
                  List.foldl
                    (runFixed g.fixedTimestep)
                    g.world
                    g.fixedSystems
              , unsimulatedTime =
                  g.unsimulatedTime - g.fixedTimestep
          }

      else
        g
  in
    simulate
      { game
          | unsimulatedTime =
              game.unsimulatedTime + dt
      }

simulateDynamic : Game world -> Game world
simulateDynamic game =
  { game
      | world =
          List.foldl
            runDynamic
              game.world
              game.dynamicSystems
  }