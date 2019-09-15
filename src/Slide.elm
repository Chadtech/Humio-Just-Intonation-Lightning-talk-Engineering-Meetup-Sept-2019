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
            titleView

        Route.Basics ->
            [ View.line [] "by \"note\" I really mean frequency, as in, a vibration that happens a certain number of times per second"
            , View.line [] "musical instruments produce frequencies"
            , View.line [] "the basic problem of intonation, is \"what frequencies should my instrument by designed to make?\""
            ]

        Route.Today ->
            [ View.header "where are we today?"
            , View.words [] "we use these notes"
            , Image.view [] Image.PianoKeys
            ]

        Route.World ->
            [ View.header "where are we today?"
            , View.words [] "countries where those notes are common are marked in gray"
            , Image.view [] Image.WorldMap
            ]

        Route.History ->
            [ View.header "where are we today?"
            , Image.view [] Image.Timeline
            ]

        Route.TheirAndOurNotes ->
            [ Image.view [] Image.TheirAndOurNotes ]

        Route.JustIntonation__Significance ->
            [ View.header "just intonation"
            , View.line
                []
                "among the music cultures that used notes, most were using just intonation"
            ]

        Route.Definition ->
            [ View.header "just intonation :="
            , View.words
                [ fontSize (px Units.size6)
                , marginBottom (px Units.size5)
                ]
                "notes that have fractional relationships to each other"
            , View.line [] "300 hz / 200 hz = 3/2"
            , View.line [] "3/2 is a fraction, so 300 and 200 hertz are two notes in a just intonation system"
            ]

        Route.Octave ->
            [ View.header "octave"
            , View.line [] "an octave up is 2/1"
            , View.line [] "an octave down is 1/2"
            , View.line [] "octaves sound like they are the same thing"
            , View.line [] "The octave of \"C#\" is also \"C#\""
            ]

        Route.SmallNumbers ->
            [ View.header "small numbers"
            , View.line [] "the smaller the numbers in the fraction, the simpler the harmony"
            , Image.view [] Image.ThreeOverTwo
            , View.line [] "3/2 is roughly the equivalent of a \"fifth\" interval on a piano, C to G"
            ]

        Route.SimpleScale ->
            [ View.header "scales"
            , View.line [] "a scale is just a set of notes"
            , View.line [] "in just intonation a note is a fraction"
            , View.line [] "so a just scale is a set of fractions"
            , View.line
                [ marginBottom (px Units.size4) ]
                "Ling Lun's scale from 3000 BCE:"
            , View.line [] "1/1, 9/8, 81/64, 3/2, 27/16, 2/1"
            ]

        Route.PrimeNumbers ->
            [ View.header "prime numbers"
            , View.line [] "the character of musical scales seems to derive from the organization and selection of prime numbers in the notes of the scale"
            , View.line
                [ marginBottom (px Units.size4) ]
                "Ling Lun's scale from 3000 BCE:"
            , View.line [ whiteSpace pre ] "1             / 1"
            , View.line [ whiteSpace pre ] "3 * 3         / 2 * 2 * 2"
            , View.line [ whiteSpace pre ] "3 * 3 * 3 * 3 / 2 * 2 * 2 * 2 * 2 * 2"
            , View.line [ whiteSpace pre ] "3             / 2"
            , View.line [ whiteSpace pre ] "3 * 3 * 3     / 2 * 2 * 2 * 2"
            , View.line [ whiteSpace pre ] "2             / 1"
            ]

        Route.MajorMinor ->
            [ View.header "prime numbers"
            , View.line [] "major chord: 5 and 3 in the numerator"
            , View.line
                [ marginBottom (px Units.size4) ]
                "1/1, 5/4, 3/2, 15/8"
            , View.line [] "minor chord: 3 in the numerator, 5 in the denominator"
            , View.line
                [ marginBottom (px Units.size4) ]
                "1/1, 6/5, 3/2, 8/5"
            , View.line
                []
                "\"slendro\", an indonesian scale: 7 and 3, top and bottom"
            , View.line
                []
                "1/1, 8/7, 21/16, 32/21, 7/4, 2/1"
            ]

        Route.End ->
            [ View.words
                [ fontSize (px Units.size6) ]
                "the end"
            ]


titleView : List (Html Msg)
titleView =
    [ View.header
        "just intonation"
    , View.words
        [ fontSize (px Units.size6)
        , marginTop (px Units.size6)
        ]
        "by chadtech"
    ]


buttonColumn : String -> Audio -> Html Msg
buttonColumn label audio =
    Grid.column
        [ flex none ]
        [ Button.view
            [ Events.onClick <| Msg.playClicked audio ]
            ("play " ++ label ++ "")
        ]
