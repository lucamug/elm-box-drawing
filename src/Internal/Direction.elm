module Internal.Direction exposing
    ( Direction(..)
    , decoder
    , encoder
    )

import Internal.Label
import Json.Decode as D
import Json.Encode as E


type Direction
    = Vertical
    | Horizontal
    | DiagonalDown
    | DiagonalUp


encoder : Internal.Label.Label -> Direction -> E.Value
encoder label direction =
    E.string <|
        case direction of
            Vertical ->
                label.vertical

            Horizontal ->
                label.horizontal

            DiagonalUp ->
                label.diagonalUp

            DiagonalDown ->
                label.diagonalDown


decoder : Internal.Label.Label -> D.Decoder Direction
decoder label =
    D.string
        |> D.andThen
            (\str ->
                if str == label.vertical then
                    D.succeed Vertical

                else if str == label.horizontal then
                    D.succeed Horizontal

                else if str == label.diagonalUp then
                    D.succeed DiagonalUp

                else if str == label.diagonalDown then
                    D.succeed DiagonalDown

                else
                    D.succeed Horizontal
            )
