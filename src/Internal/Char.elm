module Internal.Char exposing
    ( decoder
    , encoder
    )

import Json.Decode as D
import Json.Encode as E


decoder : D.Decoder Char
decoder =
    D.string
        |> D.andThen
            (\str ->
                D.succeed <| Maybe.withDefault ' ' <| List.head <| String.toList str
            )


encoder : Char -> E.Value
encoder char =
    E.string (String.fromChar char)
