module ExampleRobotAnimation exposing (main)

import BoxDrawing exposing (..)


main : Program () Int ()
main =
    animation
        ( 13, 7 )
        (\counter ->
            -- Head
            [ rectangle 11 7 double |> move 1 0

            -- Hears
            , rectangle 2 2 single |> move 11 2
            , rectangle 2 2 single |> move 0 2

            -- Unibrow
            , words "~~~/~~~" |> move 3 1

            -- Eyes
            , words
                (blinking
                    { speed = 5
                    , valueA = " _   _ "
                    , valueB = " o   O "
                    , counter = counter
                    , modBy = 30
                    , delay = 0
                    , offset = 0
                    }
                )
                |> move 3 2

            -- Nose
            , words "   └   " |> move 3 3

            -- Mouth
            , words " _   _ " |> move 3 4
            , words " └───┘ " |> move 3 5
            ]
        )
