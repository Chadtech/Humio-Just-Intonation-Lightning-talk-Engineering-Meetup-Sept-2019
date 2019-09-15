module View.Image exposing
    ( Image(..)
    , Param(..)
    , view
    )

import Css exposing (..)
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Style.Units as Units
import View.Helpers as View



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type Image
    = PianoTuning
    | PianoKeys
    | WorldMap
    | Timeline
    | TheirAndOurNotes
    | ThreeOverTwo



--------------------------------------------------------------------------------
-- HELPERS --
--------------------------------------------------------------------------------


toFilePathBase : Image -> String
toFilePathBase image =
    case image of
        PianoTuning ->
            "piano-tuning"

        PianoKeys ->
            "piano-keys"

        WorldMap ->
            "world-map"

        Timeline ->
            "time-line"

        TheirAndOurNotes ->
            "their-and-our-notes"

        ThreeOverTwo ->
            "3-over-2"


type Param
    = Styles (List Style)
    | Caption String


type alias Summary =
    { maybeCaption : Maybe String
    , styles : List Style
    }


makeSummary : List Param -> Summary
makeSummary params =
    let
        modifySummary : Param -> Summary -> Summary
        modifySummary param summary =
            case param of
                Styles styles ->
                    { summary | styles = summary.styles ++ styles }

                Caption str ->
                    { summary | maybeCaption = Just str }

        makeSummaryHelper : List Param -> Summary -> Summary
        makeSummaryHelper remainingParams summary =
            case remainingParams of
                first :: rest ->
                    makeSummaryHelper rest <| modifySummary first summary

                [] ->
                    summary
    in
    makeSummaryHelper
        params
        { maybeCaption = Nothing
        , styles =
            [ maxHeight (pct 100)
            , maxWidth (pct 100)
            , height auto
            , width auto
            , display block
            ]
        }


view : List Param -> Image -> Html msg
view params image =
    let
        summary : Summary
        summary =
            makeSummary params

        captionView : Html msg
        captionView =
            case summary.maybeCaption of
                Just caption ->
                    View.words
                        [ fontSize (px Units.size4)
                        , display block
                        ]
                        caption

                Nothing ->
                    Html.text ""
    in
    Html.div
        [ Attrs.css
            [ flexDirection column
            , displayFlex
            , flex (int 1)
            , justifyContent center
            ]
        ]
        [ Grid.row
            [ justifyContent center ]
            [ Html.img
                [ Attrs.src <| "./" ++ toFilePathBase image ++ ".png"
                , Attrs.css summary.styles
                ]
                []
            ]
        , Grid.row
            [ justifyContent center ]
            [ captionView ]
        ]
