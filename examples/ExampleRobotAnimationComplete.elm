module ExampleRobotAnimation exposing (main)

import BoxDrawing exposing (..)


main : Program () Int ()
main =
    animation
        ( 43, 32 )
        robot


heartBeatStart : number
heartBeatStart =
    280


wakeup : number
wakeup =
    400


smileStart : number
smileStart =
    500


heartAppear : number
heartAppear =
    550


eyesClose : String
eyesClose =
    " _   _ "


eyesOpen : String
eyesOpen =
    " o   O "


mouthClose1 : String
mouthClose1 =
    "       "


mouthClose2 : String
mouthClose2 =
    "  ───  "


mouthSmile1 : String
mouthSmile1 =
    " _   _ "


mouthSmile2 : String
mouthSmile2 =
    " └───┘ "


robot : Int -> List Shape
robot counter =
    [ rectangle 43 32 double
    , group
        -- Neck
        [ rectangle 5 2 single |> move 3 6

        -- Head
        , rectangle 11 7 double

        -- Hears
        , rectangle 2 2 single |> move 10 2
        , rectangle 2 2 single |> move -1 2

        -- Unibrow
        , words "~~~/~~~" |> move 2 1

        -- Eyes
        , words
            (blinking
                { speed = 5
                , valueA = eyesClose
                , valueB = eyesOpen
                , counter = counter
                , modBy = 30
                , delay = wakeup
                , offset = 0
                }
            )
            |> move 2 2

        -- Nose
        , words "   └   " |> move 2 3

        -- Mouth
        , words
            (if counter < smileStart then
                mouthClose1

             else
                mouthSmile1
            )
            |> move 2 4
        , words
            (if counter < smileStart then
                mouthClose2

             else
                mouthSmile2
            )
            |> move 2 5

        -- Antenna
        , line 4 vertical single |> move 5 -3
        , rectangle 3 2 single |> move 4 -3
        , words "\\" |> move 5 -1

        -- Heart
        , words
            (if heartAppear > counter then
                " "

             else
                "/"
            )
            |> move 11 -1
        , words
            (if heartAppear + 50 > counter then
                " "

             else
                "❤️"
            )
            |> move 12 -2
        ]
        |> move 15 (moving { from = -10, to = 5, counter = counter, delay = 200, speed = 5, offset = 0 })

    -- Body
    , group
        [ -- Arms axis
          rectangle 23 2 single |> move -5 1
        , box 13 8 double ' '
        , rectangle 2 2 (blinking { speed = 30, valueA = single, valueB = double, counter = counter, modBy = 3, delay = heartBeatStart, offset = 0 }) |> move 6 1
        , rectangle 2 2 (blinking { speed = 30, valueA = single, valueB = double, counter = counter, modBy = 3, delay = heartBeatStart, offset = 10 }) |> move 8 1
        , rectangle 2 2 (blinking { speed = 30, valueA = single, valueB = double, counter = counter, modBy = 3, delay = heartBeatStart, offset = 20 }) |> move 10 1
        , group (arm 0) |> move (moving { from = 70, to = -5, counter = counter, delay = 0, speed = 2, offset = 0 }) 0
        , group (arm 4) |> move (moving { from = -30, to = 14, counter = counter, delay = 50, speed = 3, offset = 0 }) 0
        ]
        |> move 14 (moving { from = 30, to = 12, counter = counter, delay = 0, speed = 8, offset = 0 })

    --Leg
    , group leg |> move (moving { from = 80, to = 15, counter = counter, delay = 50, speed = 2, offset = 0 }) (moving { from = 0, to = 20, counter = counter, delay = 80, speed = 4, offset = 0 })
    , group leg |> move (moving { from = 80, to = 21, counter = counter, delay = 50, speed = 3, offset = 0 }) 20
    ]


leg : List Shape
leg =
    [ box 3 2 single ' ' |> move 1 -1
    , box 5 9 double ' '
    , box 5 3 single ' ' |> move 0 4
    , words "X" |> move 2 5

    -- foot
    , box 5 2 single ' ' |> move 0 8
    ]


arm : Int -> List Shape
arm shift =
    -- [ rectangle 3 2 single |> move 1 -1
    [ box 4 9 double ' '
    , box 4 3 single ' ' |> move 0 -1
    , box 1 3 single ' ' |> move (-1 + shift) 4
    , box 4 3 single ' ' |> move 0 8
    , words "~~" |> move 1 5
    ]
