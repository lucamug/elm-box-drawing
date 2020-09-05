module Internal.Shape exposing
    ( Form(..)
    , Shape(..)
    , decoder
    , encoder
    , move
    , render
    )

import Internal.ArrowDirection
import Internal.Canvas
import Internal.Char
import Internal.Crss
import Internal.Direction
import Internal.Label
import Internal.Point
import Internal.Weight exposing (Weight(..))
import Json.Decode as D
import Json.Encode as E
import List.Extra


type Shape
    = Shape Int Int Form


type Form
    = Char Char
    | Line Int Internal.Direction.Direction Internal.Weight.Weight
    | Arrow Int Internal.Direction.Direction Internal.Weight.Weight Internal.ArrowDirection.ArrowDirection
    | Rectangle Int Int Internal.Weight.Weight
    | Box Int Int Internal.Weight.Weight Char
    | Words String
    | Group (List Shape)


formToString : Internal.Label.Label -> Form -> String
formToString label form =
    case form of
        Char _ ->
            label.char

        Line _ _ _ ->
            label.line

        Arrow _ _ _ _ ->
            label.arrow

        Rectangle _ _ _ ->
            label.rectangle

        Box _ _ _ _ ->
            label.box

        Words _ ->
            label.words

        Group _ ->
            label.group


encoder : Internal.Label.Label -> Shape -> E.Value
encoder label (Shape x y form) =
    E.object
        ([ ( label.form, E.string <| formToString label form )
         , ( label.x, E.int x )
         , ( label.y, E.int y )
         ]
            ++ otherStuff label form
        )


decoder : Internal.Label.Label -> D.Decoder Shape
decoder label =
    D.field label.form D.string
        |> D.andThen
            (\str ->
                if str == label.char then
                    D.map3 Shape
                        (D.field label.x D.int)
                        (D.field label.y D.int)
                        (D.map Char
                            (D.field label.char Internal.Char.decoder)
                        )

                else if str == label.line then
                    D.map3 Shape
                        (D.field label.x D.int)
                        (D.field label.y D.int)
                        (D.map3 Line
                            (D.field label.length D.int)
                            (D.field label.direction (Internal.Direction.decoder label))
                            (D.field label.weight Internal.Weight.decoder)
                        )

                else if str == label.arrow then
                    D.map3 Shape
                        (D.field label.x D.int)
                        (D.field label.y D.int)
                        (D.map4 Arrow
                            (D.field label.length D.int)
                            (D.field label.direction (Internal.Direction.decoder label))
                            (D.field label.weight Internal.Weight.decoder)
                            (D.field label.arrowDirection (Internal.ArrowDirection.decoder label))
                        )

                else if str == label.rectangle then
                    D.map3 Shape
                        (D.field label.x D.int)
                        (D.field label.y D.int)
                        (D.map3 Rectangle
                            (D.field label.width D.int)
                            (D.field label.height D.int)
                            (D.field label.weight Internal.Weight.decoder)
                        )

                else if str == label.box then
                    D.map3 Shape
                        (D.field label.x D.int)
                        (D.field label.y D.int)
                        (D.map4 Box
                            (D.field label.width D.int)
                            (D.field label.height D.int)
                            (D.field label.weight Internal.Weight.decoder)
                            (D.field label.char Internal.Char.decoder)
                        )

                else if str == label.words then
                    D.map3 Shape
                        (D.field label.x D.int)
                        (D.field label.y D.int)
                        (D.map Words
                            (D.field label.words D.string)
                        )

                else if str == label.group then
                    D.map3 Shape
                        (D.field label.x D.int)
                        (D.field label.y D.int)
                        (D.field label.shapes
                            (D.map Group <|
                                (D.list <| D.lazy <| \_ -> decoder label)
                            )
                        )

                else
                    D.fail "Wrong form"
            )


otherStuff : Internal.Label.Label -> Form -> List ( String, E.Value )
otherStuff label form =
    case form of
        Char char ->
            [ ( label.char, Internal.Char.encoder char )
            ]

        Line length direction weight ->
            [ ( label.length, E.int length )
            , ( label.direction, Internal.Direction.encoder label direction )
            , ( label.weight, Internal.Weight.encoder weight )
            ]

        Arrow length direction weight arrow ->
            [ ( label.length, E.int length )
            , ( label.direction, Internal.Direction.encoder label direction )
            , ( label.weight, Internal.Weight.encoder weight )
            , ( label.arrowDirection, Internal.ArrowDirection.encoder label arrow )
            ]

        Rectangle width length weight ->
            [ ( label.width, E.int width )
            , ( label.height, E.int length )
            , ( label.weight, Internal.Weight.encoder weight )
            ]

        Box width length weight char ->
            [ ( label.width, E.int width )
            , ( label.height, E.int length )
            , ( label.weight, Internal.Weight.encoder weight )
            , ( label.char, Internal.Char.encoder char )
            ]

        Words string ->
            [ ( label.words, E.string string )
            ]

        Group shapes ->
            [ ( label.shapes, E.list (encoder label) shapes )
            ]



-- Transforming


move : Int -> Int -> Shape -> Shape
move dx dy (Shape x y f) =
    Shape (x + dx) (y + dy) f



-- Rendering


render : Shape -> Internal.Canvas.CanvasGrid -> Internal.Canvas.CanvasGrid
render (Shape x y form) canvas =
    case form of
        Char char ->
            renderChar char x y Normal canvas

        Line length direction weight ->
            renderLine (length - 1) direction weight x y Normal canvas

        Arrow length direction weight arrowType ->
            renderArrow (length - 1) direction weight arrowType x y Normal canvas

        Rectangle width height weight ->
            renderRectangle (max 2 width - 1) (max 2 height - 1) weight x y canvas

        Box width height weight char ->
            renderBox (max 2 width - 1) (max 2 height - 1) weight char x y canvas

        Words string ->
            renderWords string x y canvas

        Group shapes ->
            List.foldl (\shape canvas_ -> render (shape |> move x y) canvas_) canvas shapes


renderRectangle : Int -> Int -> Weight -> Int -> Int -> Internal.Canvas.CanvasGrid -> Internal.Canvas.CanvasGrid
renderRectangle width height weight x y canvas =
    canvas
        |> renderLine width Internal.Direction.Horizontal weight x y Normal
        |> renderLine height Internal.Direction.Vertical weight x y Normal
        |> renderLine width Internal.Direction.Horizontal weight x (y + height) Normal
        |> renderLine height Internal.Direction.Vertical weight (x + width) y Normal


renderBox : Int -> Int -> Weight -> Char -> Int -> Int -> Internal.Canvas.CanvasGrid -> Internal.Canvas.CanvasGrid
renderBox width height weight char x y canvas =
    let
        fillAlsoBelowBorder =
            -- -1 -> The filling is contained inside the box with a margin
            --  0 -> The filling is contained inside the box
            --  1 -> The filling go also under the border
            --  2 -> The filling expand outside the border
            0

        emptyLine =
            String.repeat (width - 1 + (fillAlsoBelowBorder * 2)) (String.fromChar char)

        clearingStrategies =
            case Internal.Point.fromChar char of
                Internal.Point.Character _ ->
                    { top = OO, right = OO, bottom = OO, left = OO }

                Internal.Point.Crossroad crss ->
                    crss
    in
    canvas
        |> (\canvas_ ->
                List.foldl
                    (\index acc -> renderWords emptyLine (x + 1 - fillAlsoBelowBorder) (y + 1 + index - fillAlsoBelowBorder) acc)
                    canvas_
                    (List.Extra.initialize (height - 1 + (fillAlsoBelowBorder * 2)) identity)
           )
        |> renderLine width Internal.Direction.Horizontal weight x y (ClearBelow clearingStrategies.top)
        |> renderLine height Internal.Direction.Vertical weight x y (ClearRight clearingStrategies.left)
        |> renderLine width Internal.Direction.Horizontal weight x (y + height) (ClearAbove clearingStrategies.bottom)
        |> renderLine height Internal.Direction.Vertical weight (x + width) y (ClearLeft clearingStrategies.right)


renderArrow : Int -> Internal.Direction.Direction -> Weight -> Internal.ArrowDirection.ArrowDirection -> Int -> Int -> MergeStrategy -> Internal.Canvas.CanvasGrid -> Internal.Canvas.CanvasGrid
renderArrow length direction weight arrowType x y mergeStrategy oldCanvas =
    let
        ( x_, y_, char ) =
            case ( arrowType, direction ) of
                ( Internal.ArrowDirection.Standard, Internal.Direction.Vertical ) ->
                    ( x, y + length, 'v' )

                ( Internal.ArrowDirection.Reversed, Internal.Direction.Vertical ) ->
                    ( x, y, '^' )

                ( Internal.ArrowDirection.Standard, Internal.Direction.Horizontal ) ->
                    ( x + length, y, '>' )

                ( Internal.ArrowDirection.Reversed, Internal.Direction.Horizontal ) ->
                    ( x, y, '<' )

                ( Internal.ArrowDirection.Standard, Internal.Direction.DiagonalUp ) ->
                    ( x + length, y - length, '┐' )

                ( Internal.ArrowDirection.Reversed, Internal.Direction.DiagonalUp ) ->
                    ( x, y, '└' )

                ( Internal.ArrowDirection.Standard, Internal.Direction.DiagonalDown ) ->
                    ( x + length, y + length, '┘' )

                ( Internal.ArrowDirection.Reversed, Internal.Direction.DiagonalDown ) ->
                    ( x, y, '┌' )
    in
    oldCanvas
        |> renderLine length direction weight x y mergeStrategy
        |> renderPoint (Internal.Point.fromChar char) x_ y_ Normal


renderLine : Int -> Internal.Direction.Direction -> Weight -> Int -> Int -> MergeStrategy -> Internal.Canvas.CanvasGrid -> Internal.Canvas.CanvasGrid
renderLine length direction weight x y mergeStrategy oldCanvas =
    let
        char =
            case ( direction, weight ) of
                ( Internal.Direction.Vertical, O2 ) ->
                    '║'

                ( Internal.Direction.Horizontal, O2 ) ->
                    '═'

                ( Internal.Direction.Vertical, O1 ) ->
                    '│'

                ( Internal.Direction.Horizontal, O1 ) ->
                    '─'

                ( Internal.Direction.DiagonalUp, _ ) ->
                    '/'

                ( Internal.Direction.DiagonalDown, _ ) ->
                    '\\'

                _ ->
                    ' '

        point =
            Internal.Point.fromChar char

        multiplier =
            if length < 0 then
                -1

            else
                1

        drawLinesWihtoutExtremes =
            \canvas ->
                List.foldl (\( x_, y_ ) -> renderPoint point x_ y_ mergeStrategy) canvas <|
                    case direction of
                        Internal.Direction.Vertical ->
                            List.Extra.initialize (abs (length - 1)) (\index -> ( x, y + (multiplier * index) + 1 ))

                        Internal.Direction.Horizontal ->
                            List.Extra.initialize (abs (length - 1)) (\index -> ( x + (multiplier * index) + 1, y ))

                        Internal.Direction.DiagonalUp ->
                            List.Extra.initialize (abs (length - 1)) (\index -> ( x + (multiplier * index), y - (multiplier * index) ))

                        Internal.Direction.DiagonalDown ->
                            List.Extra.initialize (abs (length - 1)) (\index -> ( x + (multiplier * index), y + (multiplier * index) ))

        drawLinesExtremes =
            \canvas ->
                case direction of
                    Internal.Direction.Vertical ->
                        canvas
                            |> renderPoint (Internal.Point.Crossroad <| Internal.Crss.Crss OO OO weight OO) x y Normal
                            |> renderPoint (Internal.Point.Crossroad <| Internal.Crss.Crss weight OO OO OO) x (y + length) Normal

                    Internal.Direction.Horizontal ->
                        canvas
                            |> renderPoint (Internal.Point.Crossroad <| Internal.Crss.Crss OO weight OO OO) x y Normal
                            |> renderPoint (Internal.Point.Crossroad <| Internal.Crss.Crss OO OO OO weight) (x + length) y Normal

                    _ ->
                        canvas
    in
    oldCanvas
        |> drawLinesWihtoutExtremes
        |> drawLinesExtremes


renderChar : Char -> Int -> Int -> MergeStrategy -> Internal.Canvas.CanvasGrid -> Internal.Canvas.CanvasGrid
renderChar char x y mergeStrategy canvas =
    renderPoint (Internal.Point.fromChar char) x y mergeStrategy canvas


addPoint : Internal.Point.Point -> Internal.Point.Point -> MergeStrategy -> Internal.Point.Point
addPoint old new mergeStrategy =
    case new of
        Internal.Point.Crossroad newCrss ->
            let
                oldCrss =
                    case old of
                        Internal.Point.Crossroad crss ->
                            crss

                        Internal.Point.Character _ ->
                            Internal.Crss.Crss OO OO OO OO

                oldCrss2 =
                    case mergeStrategy of
                        Normal ->
                            oldCrss

                        ClearAbove weight ->
                            { oldCrss | top = weight }

                        ClearRight weight ->
                            { oldCrss | right = weight }

                        ClearBelow weight ->
                            { oldCrss | bottom = weight }

                        ClearLeft weight ->
                            { oldCrss | left = weight }
            in
            -- We have two crossreads, we need to be smart here
            -- and merge them
            Internal.Point.Crossroad (Internal.Crss.mergeCrss oldCrss2 newCrss)

        Internal.Point.Character _ ->
            new


renderPoint : Internal.Point.Point -> Int -> Int -> MergeStrategy -> Internal.Canvas.CanvasGrid -> Internal.Canvas.CanvasGrid
renderPoint newPoint x y mergeStrategy canvas =
    case List.Extra.getAt y canvas of
        Just row ->
            let
                newRow =
                    List.indexedMap
                        (\index oldPoint ->
                            if index == x then
                                addPoint oldPoint newPoint mergeStrategy

                            else
                                oldPoint
                        )
                        row
            in
            List.Extra.setAt y newRow canvas

        Nothing ->
            canvas


type MergeStrategy
    = Normal
    | ClearAbove Internal.Weight.Weight
    | ClearRight Internal.Weight.Weight
    | ClearBelow Internal.Weight.Weight
    | ClearLeft Internal.Weight.Weight


renderWords : String -> Int -> Int -> Internal.Canvas.CanvasGrid -> Internal.Canvas.CanvasGrid
renderWords string x y canvas =
    List.Extra.indexedFoldl
        (\index char canvas_ ->
            renderPoint (Internal.Point.fromChar char) (x + index) y Normal canvas_
        )
        canvas
        (String.toList <| String.replace "\n" " " string)
