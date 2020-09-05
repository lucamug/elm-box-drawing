module List.Extra exposing
    ( getAt
    , indexedFoldl
    , initialize
    , setAt
    )

import Tuple


initialize : Int -> (Int -> a) -> List a
initialize n f =
    let
        step i acc =
            if i < 0 then
                acc

            else
                step (i - 1) (f i :: acc)
    in
    step (n - 1) []


getAt : Int -> List a -> Maybe a
getAt idx xs =
    if idx < 0 then
        Nothing

    else
        List.head <| List.drop idx xs


setAt : Int -> a -> List a -> List a
setAt index value =
    updateAt index (always value)


updateAt : Int -> (a -> a) -> List a -> List a
updateAt index fn list =
    if index < 0 then
        list

    else
        let
            head =
                List.take index list

            tail =
                List.drop index list
        in
        case tail of
            x :: xs ->
                head ++ fn x :: xs

            _ ->
                list


indexedFoldl : (Int -> a -> b -> b) -> b -> List a -> b
indexedFoldl func acc list =
    let
        step : a -> ( Int, b ) -> ( Int, b )
        step x ( i, thisAcc ) =
            ( i + 1, func i x thisAcc )
    in
    Tuple.second (List.foldl step ( 0, acc ) list)
