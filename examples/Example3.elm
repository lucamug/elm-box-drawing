module Example3 exposing (main)

import BoxDrawing exposing (..)
import Html


main =
    Html.pre []
        [ Html.text <|
            render ( 5, 3 )
                [ rectangle 5 3 double ]
        ]
