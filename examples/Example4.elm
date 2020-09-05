module Example4 exposing (main)

import BoxDrawing exposing (..)


main : Program () () ()
main =
    picture ( 17, 3 ) <|
        [ rectangle 7 3 single
        , arrow 4 horizontal single standard
            |> move 6 1
        , group
            [ box 7 3 double ' '
            , words "box" |> move 2 1
            ]
            |> move 10 0
        ]
