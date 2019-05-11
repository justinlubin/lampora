module Utils exposing (..)

for : List a -> (a -> b) -> List b
for list f =
  List.map f list

clamp : (comparable, comparable) -> comparable -> comparable
clamp (low, hi) x =
  if x < low then
    low
  else if x > hi then
    hi
  else
    x
