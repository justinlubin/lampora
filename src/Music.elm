module Music exposing
  ( tracksFromZone
  )

import Tilemap exposing (Zone(..))
import Audio exposing (Track)

tracksFromZone : Zone -> List Track
tracksFromZone zone =
  case zone of
    Outside ->
      [ Audio.Outside ]

    Cave ->
      [ Audio.Cave ]

    Unknown ->
      []
