module Slide exposing
    ( Slide(..)
    , fromRoute
    , next
    , prev
    , view
    )

import Audio exposing (Audio)
import Css exposing (..)
import Html.Grid as Grid
import Html.Styled exposing (Html)
import Html.Styled.Events as Events
import Msg exposing (Msg)
import Route exposing (Route)
import Style.Units as Units
import View.Button as Button
import View.Helpers as View
import View.Image as Image exposing (Image)



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type Slide
    = FromRoute Route
    | SlideDoesntExist



--------------------------------------------------------------------------------
-- HELPERS --
--------------------------------------------------------------------------------


toRoute : Slide -> Route
toRoute slide =
    case slide of
        FromRoute route ->
            route

        SlideDoesntExist ->
            Route.Title


fromRoute : Route -> Slide
fromRoute =
    FromRoute


next : Slide -> Route
next =
    Route.next << toRoute


prev : Slide -> Route
prev =
    Route.prev << toRoute



--------------------------------------------------------------------------------
-- VIEW --
--------------------------------------------------------------------------------


view : Slide -> List (Html Msg)
view slide =
    case slide of
        SlideDoesntExist ->
            [ View.box
                [ displayFlex
                , flex (int 1)
                , flexDirection column
                , justifyContent center
                ]
                [ Grid.row
                    []
                    [ Grid.column
                        [ justifyContent center ]
                        [ View.words
                            []
                            "This slide does not exist"
                        ]
                    ]
                , Grid.row
                    [ marginTop <| px Units.size3 ]
                    [ Grid.column
                        [ justifyContent center ]
                        [ Button.view
                            [ Events.onClick Msg.goToTitleClicked ]
                            "go to title slide"
                        ]
                    ]
                ]
            ]

        FromRoute route ->
            viewRoute route


viewRoute : Route -> List (Html Msg)
viewRoute route =
    case route of
        Route.Title ->
            [ View.words
                [ fontSize (px Units.size6) ]
                "just intonation"
            , View.words
                [ fontSize (px Units.size6)
                , marginTop (px Units.size6)
                ]
                "by chadtech"
            ]

        Route.Definition ->
            [ View.header "just intonation"
            , View.header "what is it?"
            , View.line
                []
                "each note on a musical instrument is a unique frequency"
            , View.line
                []
                "if you were to restart all of music from scratch, you would have to pick which frequencies to use"
            , View.line
                []
                "just intonation is a theory about which frequencies go together (harmony)"
            ]

        Route.Why ->
            [ View.header "Why"
            , View.line [] "Why are there 12 notes on a piano?"
            , View.line [] "Why not 13? Why not 11?"
            , View.line [] "Why do some notes sound good with each other?"
            ]

        Route.End ->
            [ View.words
                [ fontSize (px Units.size6) ]
                "the end"
            ]


buttonColumn : String -> Audio -> Html Msg
buttonColumn label audio =
    Grid.column
        [ flex none ]
        [ Button.view
            [ Events.onClick <| Msg.playClicked audio ]
            ("play " ++ label ++ "")
        ]
