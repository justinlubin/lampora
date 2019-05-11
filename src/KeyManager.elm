module KeyManager exposing
  ( KeyManager
  , Key(..)
  , empty
  , addKey
  , removeKey
  , isDown
  )

import Set exposing (Set)

type KeyManager =
  KM (Set String)

type Key
  = Up
  | Right
  | Down
  | Left
  | Space
  | Z

keyString : Key -> String
keyString k =
  case k of
    Up ->
      "ArrowUp"

    Right ->
      "ArrowRight"

    Down ->
      "ArrowDown"

    Left ->
      "ArrowLeft"

    Space ->
      " "

    Z ->
      "z"

empty : KeyManager
empty =
  KM Set.empty

addKey : String -> KeyManager -> KeyManager
addKey s (KM set) =
  KM <|
    Set.insert s set

removeKey : String -> KeyManager -> KeyManager
removeKey s (KM set) =
  KM <|
    Set.remove s set

isDown : Key -> KeyManager -> Bool
isDown k (KM set) =
  Set.member (keyString k) set
