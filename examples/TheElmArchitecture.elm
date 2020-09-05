module ExampleRobotPicture exposing (main)

import BoxDrawing exposing (..)


sideBox : String -> Int -> Int -> Shape
sideBox string length shift =
    group
        [ box 13 7 single ' '
        , words string |> move 3 3
        , arrow length horizontal single standard |> move (12 + shift) 1
        , arrow length horizontal single reversed |> move (13 + shift) 5
        ]


main : Program () () ()
main =
    picture
        ( 78, 21 )
        [ group
            [ words "The Elm Architecture"
            , line 25 horizontal single |> move -3 1
            ]
            |> move 27 0
        , group
            [ sideBox "Effects" 16 0
            , sideBox "  DOM  " 16 0 |> move 0 11
            , sideBox "update" 22 -34 |> move 65 0
            , sideBox " view" 22 -34 |> move 65 11
            , group
                [ box 16 18 single ' '
                , words "Elm Runtime" |> move 2 2
                ]
                |> move 28 0
            , group
                [ label "  Model   " double
                ]
                |> move 30 8
            , group
                [ label " Msg " single |> move 17 0
                , label " Cmd " single |> move 17 4
                , label " Event " single |> move 16 11
                , label " HTML  " single |> move 16 15
                , label " Msg " single |> move 47 0
                , label " Model " single |> move 53 0
                , label " Model " single |> move 47 4
                , label " Cmd " single |> move 55 4
                , label " Model " single |> move 50 11
                , label " Html  " single |> move 50 15
                ]
            ]
            |> move 0 3
        ]
