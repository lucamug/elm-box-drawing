module Example2 exposing (main)

import BoxDrawing exposing (..)


main : Program () Int ()
main =
    animation
        ( 150, 40 )
        (\counter ->
            [ rectangle
                (min 150 counter)
                (min 40 counter)
                double
            ]
        )
