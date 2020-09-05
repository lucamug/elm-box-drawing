# elm-box-drawing

Create pictures and animations with [Box-drawing characters](https://en.wikipedia.org/wiki/Box-drawing_character)!

Box-drawing characters, also known as line-drawing characters, are a form of semigraphics used to draw boxes and similar geometric shapes.

They work well with monospaced fonts and are perfected to decorate your code documentation or your README files.

You can create robots

     ╔═════════╗
     ║ ~~~/~~~ ║
    ┌╣  o   O  ╠┐
    └╣    └    ╠┘
     ║  _   _  ║
     ║  └───┘  ║
     ╚═════════╝

Diagrams

     ┌─────────┐     ┌─────────┐
     │  box 1  ╞════>│  box 2  │
     └────┬────┘     └─────────┘
          │
    ┌─────┴─────┐
    │╔══════════╧╗
    └╢   boxes   ║
     ╚═══════════╝

Or whatever your imagination can think of

        ┌─┬─┬─╗    ╔──═════──╗
      ┌─┼─┼─╬═╣    │ ┌─┐ ┌─┐ │
    ┌─┼─┼─╬═╬═╣    ║ └─╬═╬─┘ ║
    ├─┼─╬═╬═╬═╝    ║ ┌─╬═╬─┐ ║
    ├─╬═╬═╬═╝      │ └─┘ └─┘ │
    ╚═╩═╩═╝        ╚──═════──╝

You can also animate your drawings

![Animated Robot](https://lucamug.github.io/elm-box-drawing/images/blinking.gif)


The library supports primitives such as

                          ║          ║
    Lines                 ║   │    ══╬══
                          ║   │   ───╫───
                          ║          ║

                          ┌───┐
    Boxes & Rectangles    │╔══╧╗
                          └╢   ║
                           ╚═══╝

                          ║   ^       ║
    Arrows                ║   │    <══╬═══
                          ║   │   ────╫───>
                          v   │       v

                          ╔═══════╗
    Words                 ║ Words ║
                          ╚═══════╝


To put these shapes together the library uses a system heavily inspired by [elm-playground](https://package.elm-lang.org/packages/evancz/elm-playground/latest/).

For example, to generate the head of the robot above, you can write

    import BoxDrawing exposing (..)

    main : Program () () ()
    main =
        picture
            ( 13, 7 )
            [ rectangle 11 7 double |> move 1 0
            , rectangle 2 2 single |> move 11 2
            , rectangle 2 2 single |> move 0 2
            , words "~~~/~~~" |> move 3 1
            , words " o   O " |> move 3 2
            , words "   └   " |> move 3 3
            , words " _   _ " |> move 3 4
            , words " └───┘ " |> move 3 5
            ]


This is another example of diagram:

                               The Elm Architecture                               
                             ───────────────────────                              

    ┌───────────┐    ┌─────┐    ┌──────────────┐   ┌─────┬───────┐   ┌───────────┐
    │           ├────┤ Msg ├───>│              ├───┤ Msg │ Model ├──>│           │
    │           │    └─────┘    │ Elm Runtime  │   └─────┴───────┘   │           │
    │  Effects  │               │              │                     │  update   │
    │           │    ┌─────┐    │              │   ┌───────┬─────┐   │           │
    │           │<───┤ Cmd ├────┤              │<──┤ Model │ Cmd ├───┤           │
    └───────────┘    └─────┘    │              │   └───────┴─────┘   └───────────┘
                                │              │                                  
                                │ ╔══════════╗ │                                  
                                │ ║  Model   ║ │                                  
                                │ ╚══════════╝ │                                  
    ┌───────────┐   ┌───────┐   │              │      ┌───────┐      ┌───────────┐
    │           ├───┤ Event ├──>│              ├──────┤ Model ├─────>│           │
    │           │   └───────┘   │              │      └───────┘      │           │
    │    DOM    │               │              │                     │   view    │
    │           │   ┌───────┐   │              │      ┌───────┐      │           │
    │           │<──┤ HTML  ├───┤              │<─────┤ Html  ├──────┤           │
    └───────────┘   └───────┘   └──────────────┘      └───────┘      └───────────┘

This is the code:

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


Other examples are available [here](https://github.com/lucamug/elm-box-drawing/tree/master/examples), [here](https://github.com/lucamug/ro-box/tree/master/src/Examples) or in the [Ro-Box website](https://ro-box.netlify.app/) where you can play directly with the library through the web interface.
