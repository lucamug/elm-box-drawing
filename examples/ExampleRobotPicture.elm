module ExampleRobotPicture exposing (main)

import BoxDrawing exposing (..)


main : Program () () ()
main =
    picture
        ( 13, 7 )
        [ rectangle 11 7 double |> move 1 0
        , rectangle 2 2 single |> move 11 2
        , rectangle 2 2 single |> move 0 2
        , words "~~~/~~~" |> move 3 1
        , words " o   O " |> move 3 2
        , words "   └   " |> move 3 3
        , words " _   _ " |> move 3 4
        , words " └───┘ " |> move 3 5
        ]
