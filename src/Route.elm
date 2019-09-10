module Route exposing
    ( Route(..)
    , fromUrl
    , goTo
    , next
    , prev
    , toUrlString
    )

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, s, top)



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type Route
    = Title



--------------------------------------------------------------------------------
-- HELPERS --
--------------------------------------------------------------------------------


toParser : Route -> Parser (Route -> a) a
toParser route =
    let
        defaultParser : Parser (Route -> a) a
        defaultParser =
            Parser.map route (top </> s (toUrlString route))
    in
    case route of
        Title ->
            Parser.oneOf
                [ Parser.map Title top
                , defaultParser
                ]

        _ ->
            defaultParser


prev : Route -> Route
prev route =
    let
        getNextHelper : List Route -> Route
        getNextHelper remainingRoutes =
            case remainingRoutes of
                first :: second :: rest ->
                    if second == route then
                        first

                    else
                        getNextHelper (second :: rest)

                _ ->
                    Title
    in
    getNextHelper allInCorrectOrder


next : Route -> Route
next route =
    let
        getNextHelper : List Route -> Route
        getNextHelper remainingRoutes =
            case remainingRoutes of
                first :: second :: rest ->
                    if first == route then
                        second

                    else
                        getNextHelper (second :: rest)

                _ ->
                    End
    in
    getNextHelper allInCorrectOrder


allInCorrectOrder : List Route
allInCorrectOrder =
    [ Title ]


toUrlString : Route -> String
toUrlString route =
    case route of
        Title ->
            "title"


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


parser : Parser (Route -> a) a
parser =
    Parser.oneOf <| List.map toParser allInCorrectOrder


goTo : Nav.Key -> Route -> Cmd msg
goTo key =
    toUrlString >> Nav.pushUrl key
