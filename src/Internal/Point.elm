module Internal.Point exposing
    ( Point(..)
    , fromChar
    , fromPointsToString
    )

import Internal.Crss


type Point
    = Crossroad Internal.Crss.Crss
    | Character Char


pointToChar : Point -> Char
pointToChar point =
    case point of
        Crossroad strc ->
            Internal.Crss.toChar strc

        Character char ->
            char


fromPointsToString : List Point -> String
fromPointsToString row =
    String.join ""
        (List.map
            (\point ->
                String.fromChar <| pointToChar point
            )
            row
        )


fromChar : Char -> Point
fromChar char =
    case Internal.Crss.fromChar char of
        Just crss ->
            Crossroad crss

        Nothing ->
            Character char
