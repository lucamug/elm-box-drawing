module Internal.Crss exposing
    ( Crss
    , fromChar
    , mergeCrss
    , toChar
    )

import Internal.Weight exposing (..)


type Zeros
    = Z0
    | Z1
    | Z2
    | Z3
    | Z4


type alias Crss =
    { top : Weight
    , right : Weight
    , bottom : Weight
    , left : Weight
    }


mergeCrss : Crss -> Crss -> Crss
mergeCrss old new =
    Crss
        (Internal.Weight.mergeWeight old.top new.top)
        (Internal.Weight.mergeWeight old.right new.right)
        (Internal.Weight.mergeWeight old.bottom new.bottom)
        (Internal.Weight.mergeWeight old.left new.left)


toChar : Crss -> Char
toChar crss =
    let
        zeros =
            List.foldl
                (\weight acc ->
                    if weight == OO then
                        acc + 1

                    else
                        acc
                )
                0
                [ crss.top, crss.right, crss.bottom, crss.left ]

        z =
            case zeros of
                0 ->
                    Z0

                1 ->
                    Z1

                2 ->
                    Z2

                3 ->
                    Z3

                _ ->
                    Z4
    in
    case ( z, [ crss.top, crss.right, crss.bottom, crss.left ] ) of
        --
        -- Z4
        --
        ( Z4, _ ) ->
            ' '

        --
        -- Z3
        --
        ( Z3, _ ) ->
            ' '

        --
        -- Z2
        --
        ( Z2, [ O1, OO, O1, OO ] ) ->
            '│'

        ( Z2, [ OO, O1, OO, O1 ] ) ->
            '─'

        --
        ( Z2, [ _, OO, _, OO ] ) ->
            '║'

        ( Z2, [ OO, _, OO, _ ] ) ->
            '═'

        --
        ( Z2, [ O1, O1, OO, OO ] ) ->
            '└'

        ( Z2, [ OO, O1, O1, OO ] ) ->
            '┌'

        ( Z2, [ OO, OO, O1, O1 ] ) ->
            '┐'

        ( Z2, [ O1, OO, OO, O1 ] ) ->
            '┘'

        --
        ( Z2, [ O2, O2, OO, OO ] ) ->
            '╚'

        ( Z2, [ OO, O2, O2, OO ] ) ->
            '╔'

        ( Z2, [ OO, OO, O2, O2 ] ) ->
            '╗'

        ( Z2, [ O2, OO, OO, O2 ] ) ->
            '╝'

        --
        ( Z2, [ OO, OO, O2, O1 ] ) ->
            '╖'

        ( Z2, [ OO, OO, O1, O2 ] ) ->
            '╕'

        ( Z2, [ O2, OO, OO, O1 ] ) ->
            '╜'

        ( Z2, [ O1, OO, OO, O2 ] ) ->
            '╛'

        --
        --
        ( Z2, [ O2, O1, OO, OO ] ) ->
            '╙'

        ( Z2, [ O1, O2, OO, OO ] ) ->
            '╘'

        ( Z2, [ OO, O2, O1, OO ] ) ->
            '╒'

        ( Z2, [ OO, O1, O2, OO ] ) ->
            '╓'

        ( Z2, _ ) ->
            '2'

        --
        -- Z1
        --
        ( Z1, [ OO, O1, O1, O1 ] ) ->
            '┬'

        ( Z1, [ O1, OO, O1, O1 ] ) ->
            '┤'

        ( Z1, [ O1, O1, OO, O1 ] ) ->
            '┴'

        ( Z1, [ O1, O1, O1, OO ] ) ->
            '├'

        --
        ( Z1, [ OO, O1, O2, O1 ] ) ->
            '╥'

        ( Z1, [ O1, OO, O1, O2 ] ) ->
            '╡'

        ( Z1, [ O2, O1, OO, O1 ] ) ->
            '╨'

        ( Z1, [ O1, O2, O1, OO ] ) ->
            '╞'

        --
        ( Z1, [ OO, O2, O1, O2 ] ) ->
            '╤'

        ( Z1, [ O2, OO, O2, O1 ] ) ->
            '╢'

        ( Z1, [ O1, O2, OO, O2 ] ) ->
            '╧'

        ( Z1, [ O2, O1, O2, OO ] ) ->
            '╟'

        --
        ( Z1, [ OO, O2, O2, O2 ] ) ->
            '╦'

        ( Z1, [ O2, OO, O2, O2 ] ) ->
            '╣'

        ( Z1, [ O2, O2, OO, O2 ] ) ->
            '╩'

        ( Z1, [ O2, O2, O2, OO ] ) ->
            '╠'

        -- Here we replace non-existing pieces with approximations
        ( Z1, [ OO, _, _, _ ] ) ->
            '╦'

        ( Z1, [ _, OO, _, _ ] ) ->
            '╣'

        ( Z1, [ _, _, OO, _ ] ) ->
            '╩'

        ( Z1, [ _, _, _, OO ] ) ->
            '╠'

        --
        ( Z1, _ ) ->
            '1'

        --
        -- Z0
        --
        ( Z0, [ O1, O1, O1, O1 ] ) ->
            '┼'

        ( Z0, [ O2, O1, O2, O1 ] ) ->
            '╫'

        ( Z0, [ O1, O2, O1, O2 ] ) ->
            '╪'

        ( Z0, [ O2, O2, O2, O2 ] ) ->
            '╬'

        --
        ( Z0, _ ) ->
            '╬'


fromChar : Char -> Maybe Crss
fromChar char =
    case char of
        '│' ->
            Just <| Crss O1 OO O1 OO

        '─' ->
            Just <| Crss OO O1 OO O1

        '║' ->
            Just <| Crss O2 OO O2 OO

        '═' ->
            Just <| Crss OO O2 OO O2

        '┌' ->
            Just <| Crss OO O1 O1 OO

        '┐' ->
            Just <| Crss OO OO O1 O1

        '┘' ->
            Just <| Crss O1 OO OO O1

        '└' ->
            Just <| Crss O1 O1 OO OO

        --
        --
        '┬' ->
            Just <| Crss OO O1 O1 O1

        '┤' ->
            Just <| Crss O1 OO O1 O1

        '┴' ->
            Just <| Crss O1 O1 OO O1

        '├' ->
            Just <| Crss O1 O1 O1 OO

        --
        --
        '╥' ->
            Just <| Crss OO O1 O2 O1

        '╡' ->
            Just <| Crss O1 OO O1 O2

        '╨' ->
            Just <| Crss O2 O1 OO O1

        '╞' ->
            Just <| Crss O1 O2 O1 OO

        --
        --
        '┼' ->
            Just <| Crss O1 O1 O1 O1

        '╫' ->
            Just <| Crss O2 O1 O2 O1

        '╪' ->
            Just <| Crss O1 O2 O1 O2

        '╬' ->
            Just <| Crss O2 O2 O2 O2

        --
        --
        '╔' ->
            Just <| Crss OO O2 O2 OO

        '╗' ->
            Just <| Crss OO OO O2 O2

        '╝' ->
            Just <| Crss O2 OO OO O2

        '╚' ->
            Just <| Crss O2 O2 OO OO

        --
        --
        '╦' ->
            Just <| Crss OO O2 O2 O2

        '╣' ->
            Just <| Crss O2 OO O2 O2

        '╩' ->
            Just <| Crss O2 O2 OO O2

        '╠' ->
            Just <| Crss O2 O2 O2 OO

        --
        --
        '╤' ->
            Just <| Crss OO O2 O1 O2

        '╢' ->
            Just <| Crss O2 OO O2 O1

        '╧' ->
            Just <| Crss O1 O2 OO O2

        '╟' ->
            Just <| Crss O2 O1 O2 OO

        --
        --
        '╖' ->
            Just <| Crss OO OO O2 O1

        '╕' ->
            Just <| Crss OO OO O1 O2

        '╜' ->
            Just <| Crss O2 OO OO O1

        '╛' ->
            Just <| Crss O1 OO OO O2

        '╙' ->
            Just <| Crss O2 O1 OO OO

        '╘' ->
            Just <| Crss O1 O2 OO OO

        '╒' ->
            Just <| Crss OO O2 O1 OO

        '╓' ->
            Just <| Crss OO O1 O2 OO

        _ ->
            Nothing
