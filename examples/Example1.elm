module Example1 exposing (main)

import BoxDrawing exposing (..)


main : Program () () ()
main =
    picture ( 28, 8 ) <|
        [ group
            [ rectangle 11 3 single
            , words "box 1" |> move 3 1
            , line 3 vertical single |> move 5 2
            , arrow 6 horizontal double standard |> move 10 1
            ]
            |> move 1 0
        , group
            [ rectangle 11 3 single
            , words "box 2" |> move 3 1
            ]
            |> move 17 0
        , group
            [ rectangle 13 3 single
            , box 13 3 double ' ' |> move 1 1
            , words "boxes" |> move 5 2
            ]
            |> move 0 4
        ]
