module Internal.Label exposing
    ( Label
    , long
    , short
    )


type alias Label =
    { arrow : String
    , arrowDirection : String
    , author : String
    , box : String
    , char : String
    , diagonalDown : String
    , diagonalUp : String
    , direction : String
    , form : String
    , group : String
    , height : String
    , horizontal : String
    , length : String
    , line : String
    , link : String
    , rectangle : String
    , reversed : String
    , shapes : String
    , source : String
    , standard : String
    , title : String
    , vertical : String
    , weight : String
    , width : String
    , words : String
    , x : String
    , y : String
    }


short : Label
short =
    { form = "f"

    --
    , char = "c"
    , line = "l"
    , arrow = "a"
    , rectangle = "r"
    , box = "b"
    , words = "w"
    , group = "g"

    --
    , length = "e"

    --
    , width = "t"
    , height = "h"

    --
    , direction = "d"
    , weight = "i"
    , shapes = "s"
    , arrowDirection = "j"

    --
    , standard = ">"
    , reversed = "<"

    --
    , vertical = "|"
    , horizontal = "-"
    , diagonalUp = "/"
    , diagonalDown = "\\"

    --
    , title = "n"
    , source = "o"
    , author = "u"
    , link = "k"

    --
    , x = "x"
    , y = "y"
    }


long : Label
long =
    { form = "shape"

    --
    , char = "char"
    , line = "line"
    , arrow = "type"
    , rectangle = "rect"
    , box = "box"
    , words = "words"
    , group = "group"

    --
    , length = "length"
    , direction = "direction"
    , weight = "weight"
    , width = "width"
    , shapes = "shapes"
    , arrowDirection = "arrowDirection"

    --
    , standard = ">"
    , reversed = "<"

    --
    , vertical = "|"
    , horizontal = "-"
    , diagonalUp = "/"
    , diagonalDown = "\\"

    --
    , title = "title"
    , source = "source"
    , author = "author"
    , link = "link"
    , height = "height"

    --
    , x = "x"
    , y = "y"
    }
