module Internal.Weight exposing
    ( Weight(..)
    , decoder
    , encoder
    , mergeWeight
    )

import Json.Decode as D
import Json.Encode as E


type Weight
    = OO
    | O1
    | O2


mergeWeight : Weight -> Weight -> Weight
mergeWeight oldWeight newWeight =
    case ( oldWeight, newWeight ) of
        ( _, OO ) ->
            oldWeight

        _ ->
            newWeight


encoder : Weight -> E.Value
encoder direction =
    E.int <|
        case direction of
            OO ->
                0

            O1 ->
                1

            O2 ->
                2


decoder : D.Decoder Weight
decoder =
    D.int
        |> D.andThen
            (\int ->
                case int of
                    0 ->
                        D.succeed OO

                    2 ->
                        D.succeed O2

                    _ ->
                        D.succeed O1
            )
