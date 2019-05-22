module Music exposing
  ( tracksFromZone
  )

import Tilemap exposing (Zone(..))
import Audio exposing (Track(..))

tracksFromZone : Zone -> List Track
tracksFromZone zone =
  let
    common =
      [ Oboe
      , Clarinet
      , Bassoon
      ]

    extra =
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
    common ++ extra
