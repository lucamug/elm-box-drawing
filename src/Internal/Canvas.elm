module Internal.Canvas exposing
    ( CanvasGrid
    , CanvasSize
    , initCanvas
    , toString
    )

import Internal.Point


type alias CanvasGrid =
    List (List Internal.Point.Point)


type alias CanvasSize =
    ( Int, Int )


initCanvas : CanvasSize -> CanvasGrid
initCanvas ( x, y ) =
    List.repeat y (List.repeat x (Internal.Point.fromChar ' '))


toString : CanvasGrid -> List String
toString canvas =
    List.map
        (\row ->
            Internal.Point.fromPointsToString row
        )
        canvas
