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
    = Humio
    | SineWaveDemo
    | FluteAudio
    | IdealOrgan
    | UnidealOrgan
    | OrganPipes
    | OrganPipeTypes
    | PipeResonator
    | FluteBlowSpot
    | Horn
    | Xylophone
    | Bell
    | ElmVoice
    | ElmVoice__Diagrammed
    | InternetVoiceChat
    | Violin_0
    | Violin_1
    | SnareDrum__Punch
    | SnareDrum__TopHead
    | SnareDrum__Travel
    | SnareDrum__BottomHead
    | SnareDrum__Snare



--------------------------------------------------------------------------------
-- HELPERS --
--------------------------------------------------------------------------------


toFilePathBase : Image -> String
toFilePathBase image =
    case image of
        Humio ->
            "humio"

        SineWaveDemo ->
            "sine-wave-demo"

        FluteAudio ->
            "flute-demo"

        IdealOrgan ->
            "ideal-organ"

        UnidealOrgan ->
            "unideal-organ"

        OrganPipes ->
            "actual-organ-pipes"

        OrganPipeTypes ->
            "organ-pipe-types"

        PipeResonator ->
            "organ-pipe-resonator"

        FluteBlowSpot ->
            "flute-blow-spot"

        Horn ->
            "horn"

        Xylophone ->
            "xylophone"

        Bell ->
            "bell"

        ElmVoice ->
            "elm-voice"

        ElmVoice__Diagrammed ->
            "elm-voice-diagrammed"

        InternetVoiceChat ->
            "internet-voice-chat-grains"

        Violin_0 ->
            "violin-demo-0"

        Violin_1 ->
            "violin-demo-1"

        SnareDrum__Punch ->
            snareDrum "punch"

        SnareDrum__TopHead ->
            "snare-drum-top-head"

        SnareDrum__Travel ->
            "snare-drum-travel"

        SnareDrum__BottomHead ->
            "snare-drum-bottom-head"

        SnareDrum__Snare ->
            "snare-drum-snares"


snareDrum : String -> String
snareDrum =
    (++) "snare-drum-"


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
