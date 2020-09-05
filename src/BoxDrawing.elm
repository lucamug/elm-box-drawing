module BoxDrawing exposing
    ( picture, animation, render, move, group, CanvasSize
    , line, arrow, rectangle, box, words, paragraph, label, Shape
    , moving, blinking
    , Weight, none, single, double
    , Direction, horizontal, vertical, diagonalUp, diagonalDown
    , ArrowDirection, standard, reversed
    , shapesEncoder, shapesDecoder
    , shapesEncoderMinified, shapesDecoderMinified
    )

{-|


# Basic Elements

@docs picture, animation, render, move, group, CanvasSize


# Shapes

@docs line, arrow, rectangle, box, words, paragraph, label, Shape


# Animations

@docs moving, blinking


# Attributes


## Weight

@docs Weight, none, single, double


# Direction

@docs Direction, horizontal, vertical, diagonalUp, diagonalDown


## Arrow Direction

@docs ArrowDirection, standard, reversed


# Encoders and Decoders

To serialize a list of shapes.

Useful if you want to send a list of shapes via HTTP requests or to save them in the local storage.

The minified versions have a smaller footprint but are less human-readable.

@docs shapesEncoder, shapesDecoder

The minified versions output a smaller but less less human-readable.

@docs shapesEncoderMinified, shapesDecoderMinified

-}

import Internal.Animation exposing (..)
import Internal.ArrowDirection exposing (..)
import Internal.Crss exposing (..)
import Internal.Direction exposing (..)
import Internal.Label exposing (..)
import Internal.Picture exposing (..)
import Internal.Point exposing (..)
import Internal.Shape exposing (..)
import Internal.Weight exposing (..)
import Json.Decode
import Json.Encode


{-| Creates a picture using box-drawing characters.

For example, to get this:

     ┌─────────┐     ┌─────────┐
     │  box 1  ╞════>│  box 2  │
     └────┬────┘     └─────────┘
          │
    ┌─────┴─────┐
    │╔══════════╧╗
    └╢   boxes   ║
     ╚═══════════╝

You can write

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

The first argument is the canvas size, the second is a list of `Shape`.

The (0, 0) coordinates are at the top left corner of the screen. Positive quantities move objects toward the bottom right corner.

If you see gaps between characters, you need to adjust the style, for example, in CSS:

    pre { line-height: 19px }

-}
picture : CanvasSize -> List Shape -> Program () () ()
picture =
    Internal.Picture.picture


{-| Creates animated pictures using box-drawing characters.

For example, to draw a rectangle that expands like this:

    ╔═══╗
    ║   ║ ⇨
    ╚═══╝
      ⇩

You can write

    import BoxDrawing exposing (..)

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

The first argument is the canvas size, the second is a function that gets an `Int` and returns a list of `Shape`.

The `Int` is a counter that increases by one 60 times per second making the drawing expand.

-}
animation : CanvasSize -> (Int -> List Shape) -> Program () Int ()
animation =
    Internal.Animation.animation


{-| Transforms a list of `Shape` into a `String` using box-drawing characters.

This is what is used internally by [`picture`](#picture) and [`animation`](#animation).

Use [`render`](#render) instead of [`picture`](#picture) and [`animation`](#animation) if you want to embed this library in a larger application so that you can control your "Elm Architecture".

These two examples are equivalent:

Example with [`picture`](#picture)

    import BoxDrawing exposing (..)

    main =
        picture ( 5, 3 ) <|
            [ rectangle 5 3 double ]

Example with [`render`](#render)

    import BoxDrawing exposing (..)
    import Html

    main =
        Html.pre []
            [ Html.text <|
                render ( 5, 3 )
                    [ rectangle 5 3 double ]
            ]

-}
render : CanvasSize -> List Shape -> String
render =
    Internal.Picture.toString



-- Shape transformation


{-| Move shapes around the canvas.

`move` takes, in order, the horizontal and vertical quantity of how many characters the object should move.

Remember that the coordinates (0, 0) are at the top left corner of the screen.

Positive quantities move objects toward the bottom right corner.

-}
move : Int -> Int -> Shape -> Shape
move =
    Internal.Shape.move


{-| Groups shapes together. Particularly useful when you need to move shapes of the same amount:

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

Result:

    ┌─────┐   ╔═════╗
    │     ├──>║ box ║
    └─────┘   ╚═════╝

-}
group : List Shape -> Shape
group shapes =
    Internal.Shape.Shape 0 0 (Internal.Shape.Group shapes)


{-| The size of the canvas
-}
type alias CanvasSize =
    ( Int, Int )


{-| Make lines:

    import BoxDrawing exposing (..)

    main =
        picture ( 10, 1 ) <|
            [ line 10 horizontal double ]

Result:

    ════════

You give in order:

  - The length
  - The `Direction`
  - The `Weight`

`Direction` can be

  - `horizontal` ⇨
  - `vertical` ⇩
  - `diagonalUp` ⬀
  - `diagonalDown` ⬂

`Weight` can be

  - `none`
  - `single` ─
  - `double` ═

-}
line : Int -> Direction -> Weight -> Shape
line length direction weight =
    Internal.Shape.Shape 0 0 (Internal.Shape.Line length direction weight)


{-| Make arrows:

    import BoxDrawing exposing (..)

    main =
        picture ( 10, 1 ) <|
            [ arrow 10 horizontal double standard ]

Result:

    ═══════>

An `arrow` is similar to a [`line`](#line) but with a point at the end.

You give in order:

  - The length
  - The `Direction`
  - The `Weight`
  - The `ArrowDirection`

[`ArrowDirection`](#ArrowDirection) can be

  - `standard` ══>
  - `reversed` <══

-}
arrow : Int -> Direction -> Weight -> ArrowDirection -> Shape
arrow length direction weight arrowType =
    Internal.Shape.Shape 0 0 (Internal.Shape.Arrow length direction weight arrowType)


{-| Make rectangles:

    import BoxDrawing exposing (..)

    main =
        picture ( 5, 3 ) <|
            [ rectangle 5 3 double ]

Result:

    ╔═══╗
    ║   ║
    ╚═══╝

You give in order:

  - The width
  - The height
  - The `Weight`

-}
rectangle : Int -> Int -> Weight -> Shape
rectangle width height weight =
    Internal.Shape.Shape 0 0 (Internal.Shape.Rectangle width height weight)


{-| Make boxes:

    import BoxDrawing exposing (..)

    main =
        box ( 5, 3 ) <|
            [ rectangle 5 3 double '▒' ]

Result:

    ╔═══╗
    ║▒▒▒║
    ╚═══╝

You give in order:

  - The width
  - The height
  - The `Weight`
  - A filling `Char`

A `box` is similar to a [`rectangle`](#rectangle) but it also fills the inner area with a `Char`. Useful if you want to cover something underneath. For example:


### Overlapping rectangles

    main =
        picture ( 6, 4 ) <|
            [ rectangle 5 3 single
            , rectangle 5 3 double |> move 1 1
            ]

Result :

    ┌───┐
    │╔══╪╗
    └╫──┘║
     ╚═══╝


### Overlapping boxes

    main =
        picture ( 6, 4 ) <|
            [ rectangle 5 3 single
            , box 5 3 double ' ' |> move 1 1
            ]

Result:

    ┌───┐
    │╔══╧╗
    └╢   ║
     ╚═══╝

-}
box : Int -> Int -> Weight -> Char -> Shape
box width height weight char =
    Internal.Shape.Shape 0 0 (Internal.Shape.Box width height weight char)


{-| Print words:

    import BoxDrawing exposing (..)

    main =
        picture ( 13, 1 ) <|
            [ words "Hello, World!" ]

Result:

    Hello, World!

-}
words : String -> Shape
words string =
    Internal.Shape.Shape 0 0 (Internal.Shape.Words string)


{-| Print paragraphs:

    import BoxDrawing exposing (..)

    main =
        picture ( 13, 1 ) <|
            [ paragraph "Hello,\nWorld!" ]

Result:

    Hello,
    World!

-}
paragraph : String -> Shape
paragraph string =
    group <| List.indexedMap (\index string_ -> words string_ |> move 0 index) (String.split "\n" string)


{-| Make labels. Labels are boxes with text inside:

    import BoxDrawing exposing (..)

    main =
        picture ( 17, 3 ) <|
            [ label " Hello, World! " single ]

Result:

    ┌───────────────┐
    │ Hello, World! │
    └───────────────┘

-}
label : String -> Weight -> Shape
label string weight =
    group
        [ box (String.length string + 2) 3 weight ' '
        , words string |> move 1 1
        ]


{-| The building block of your pictures.
-}
type alias Shape =
    Internal.Shape.Shape



-- Weight


{-| -}
type alias Weight =
    Internal.Weight.Weight


{-| -}
none : Weight
none =
    OO


{-|

    ──────

-}
single : Weight
single =
    O1


{-|

    ══════

-}
double : Weight
double =
    O2



-- ArrowDirection


{-| -}
type alias ArrowDirection =
    Internal.ArrowDirection.ArrowDirection


{-|

    ───>

-}
standard : ArrowDirection
standard =
    Standard


{-|

    <───

-}
reversed : ArrowDirection
reversed =
    Reversed



-- Direction


{-| -}
type alias Direction =
    Internal.Direction.Direction


{-|

    ══════

-}
horizontal : Direction
horizontal =
    Horizontal


{-|

    ║
    ║
    ║

-}
vertical : Direction
vertical =
    Vertical


{-|

      /
     /
    /

-}
diagonalUp : Direction
diagonalUp =
    DiagonalUp


{-|

    \
     \
      \

-}
diagonalDown : Direction
diagonalDown =
    DiagonalDown



-- Animation


{-| Moves shapes.

Useful to move shapes during an animation.

  - `counter`: An `Int` that increase (tick) 60 times per second
  - `delay`: Delay in number of ticks before the movement starts
  - `speed`: Smaller number: faster speed. Bigger number: slower speed
  - `offset`: Offset
  - `from`: Initial value
  - `to`: Final value

Find examples of usage in the Robot animation:

-}
moving :
    { counter : Int
    , delay : Int
    , speed : Float
    , offset : Int
    , from : Int
    , to : Int
    }
    -> Int
moving =
    Internal.Animation.moving


{-| Alternates two values.

For example, if you want to make the eye of a robot blinking:

    import BoxDrawing exposing (..)

    main : Program () Int ()
    main =
        animation
            ( 13, 7 )
            (\counter ->
                -- Head
                [ rectangle 11 7 double |> move 1 0

                -- Hears
                , rectangle 2 2 single |> move 11 2
                , rectangle 2 2 single |> move 0 2

                -- Unibrow
                , words "~~~/~~~" |> move 3 1

                -- Eyes
                , words
                    (blinking
                        { speed = 5
                        , valueA = " _   _ "
                        , valueB = " o   O "
                        , counter = counter
                        , modBy = 30
                        , delay = 0
                        , offset = 0
                        }
                    )
                    |> move 3 2

                -- Nose
                , words "   └   " |> move 3 3

                -- Mouth
                , words " _   _ " |> move 3 4
                , words " └───┘ " |> move 3 5
                ]
            )

Result:

     ╔═════════╗
     ║ ~~~/~~~ ║
    ┌╣  o   O  ╠┐
    └╣    └    ╠┘
     ║  _   _  ║
     ║  └───┘  ║
     ╚═════════╝

-}
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
blinking =
    Internal.Animation.blinking



-- Shapes Encoders/Decoders


{-| -}
shapesEncoder : List Internal.Shape.Shape -> Json.Encode.Value
shapesEncoder =
    Internal.Picture.encoder Internal.Label.long


{-| -}
shapesDecoder : Json.Decode.Decoder (List Internal.Shape.Shape)
shapesDecoder =
    Internal.Picture.decoder Internal.Label.long


{-| -}
shapesEncoderMinified : List Internal.Shape.Shape -> Json.Encode.Value
shapesEncoderMinified =
    Internal.Picture.encoder Internal.Label.short


{-| -}
shapesDecoderMinified : Json.Decode.Decoder (List Internal.Shape.Shape)
shapesDecoderMinified =
    Internal.Picture.decoder Internal.Label.short
