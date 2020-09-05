module Internal.ArrowDirection exposing
    ( ArrowDirection(..)
    , decoder
    , encoder
    )

import Internal.Label
import Json.Decode as D
import Json.Encode as E


type ArrowDirection
    = Standard
    | Reversed


encoder : Internal.Label.Label -> ArrowDirection -> E.Value
encoder label direction =
    E.string <|
        case direction of
            Standard ->
                label.standard

            Reversed ->
                label.reversed


decoder : Internal.Label.Label -> D.Decoder ArrowDirection
decoder label =
    D.string
        |> D.andThen
            (\str ->
                if str == label.reversed then
                    D.succeed Reversed

                else
                    D.succeed Standard
            )
