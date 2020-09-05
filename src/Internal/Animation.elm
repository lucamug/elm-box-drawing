module Internal.Animation exposing
    ( animation
    , blinking
    , moving
    , toString
    )

import Browser
import Browser.Events
import Html
import Internal.Canvas
import Internal.Picture
import Internal.Shape


toString : (Int -> List Internal.Shape.Shape) -> Internal.Canvas.CanvasSize -> Int -> String
toString v canvasSize counter =
    Internal.Canvas.initCanvas canvasSize
        |> Internal.Picture.render (v counter)
        |> Internal.Canvas.toString
        |> String.join "\n"


animation : ( Int, Int ) -> (Int -> List Internal.Shape.Shape) -> Program () Int ()
animation canvasSize v =
    Browser.element
        { init = \_ -> ( 0, Cmd.none )
        , view = \counter -> Html.pre [] [ Html.text <| toString v canvasSize counter ]
        , update = \_ counter -> ( counter + 1, Cmd.none )
        , subscriptions = \_ -> Browser.Events.onAnimationFrameDelta (\_ -> ())
        }


blinking :
    { counter : Int
    , delay : Int
    , speed : Int
    , offset : Int
    , valueA : a
    , valueB : a
    , modBy : Int
    }
    -> a
blinking args =
    if args.delay > args.counter then
        args.valueA

    else if modBy args.modBy ((args.counter + args.offset) // args.speed) == 0 then
        args.valueA

    else
        args.valueB


moving :
    { counter : Int
    , delay : Int
    , speed : Float
    , offset : Int
    , from : Int
    , to : Int
    }
    -> Int
moving args =
    if args.counter < args.delay then
        args.from

    else
        let
            direction =
                if args.to - args.from < 0 then
                    -1

                else
                    1

            counter_ =
                args.counter - args.delay

            newValue =
                args.from + round ((toFloat (counter_ + args.offset) / args.speed) * direction)
        in
        if direction == 1 then
            min newValue args.to

        else
            max newValue args.to
