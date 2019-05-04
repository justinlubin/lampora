module Utils exposing (..)

for : List a -> (a -> b) -> List b
for list f =
  List.map f list
