module Internal.Picture exposing
    ( decoder
    , encoder
    , picture
    , render
    , toString
    )

import Browser
import Html
import Internal.Canvas
import Internal.Label
import Internal.Shape
import Json.Decode as D
import Json.Encode as E


type alias Canvas =
    ( Int, Int )


render : List Internal.Shape.Shape -> Internal.Canvas.CanvasGrid -> Internal.Canvas.CanvasGrid
render picture_ canvas =
    List.foldl (\shape canvas_ -> Internal.Shape.render shape canvas_) canvas picture_


toString : Canvas -> List Internal.Shape.Shape -> String
toString canvasSize shapes =
    Internal.Canvas.initCanvas canvasSize
        |> render shapes
        |> Internal.Canvas.toString
        |> String.join "\n"



-- picture : Internal.Canvas.CanvasSize -> List Internal.Shape.Shape -> Html.Html msg
-- picture canvasSize view =
--     Html.pre []
--         [ Html.text <|
--             toString
--                 view
--                 canvasSize
--         ]


picture : Internal.Canvas.CanvasSize -> List Internal.Shape.Shape -> Program () () ()
picture canvasSize shapes =
    Browser.element
        { init = \_ -> ( (), Cmd.none )
        , view = \_ -> Html.pre [] [ Html.text <| toString canvasSize shapes ]
        , update = \_ _ -> ( (), Cmd.none )
        , subscriptions = \_ -> Sub.none
        }


decoder : Internal.Label.Label -> D.Decoder (List Internal.Shape.Shape)
decoder label =
    D.list (Internal.Shape.decoder label)


encoder : Internal.Label.Label -> List Internal.Shape.Shape -> E.Value
encoder label picture_ =
    E.list (Internal.Shape.encoder label) picture_
