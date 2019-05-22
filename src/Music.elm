module Music exposing
  ( tracks
  )

import Tilemap exposing (Zone(..))
import Audio exposing (Track(..))

levelFromScore : Int -> Int
levelFromScore score =
  score // 2

tracks : Int -> Zone -> List Track
tracks score zone =
  let
    level =
      levelFromScore score

    level0 =
      [ Oboe
      , Clarinet
      , Bassoon
      ]

    level1 =
      if level >= 1 then
        [ Violin
        , Violoncello
        ]
      else
        []

    level2 =
      if level >= 2 then
        [ Flute
        , Drumset
        ]
      else
        []

    zoneBased =
      case zone of
        Outside ->
          [ Piano2
          ]

        Winter ->
          [ SleighBells
          , Chimes
          , Piano1
          ]

        Cave ->
          [ Tuba
          , Piano2
          ]

        Unknown ->
          []
  in
    level0 ++ level1 ++ level2 ++ zoneBased
