module Main exposing (main)

import Audio
import Browser
import Browser.Events
import Browser.Navigation as Nav
import Css exposing (..)
import Html.Grid as Grid
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attrs
import Json.Decode as Decode
import Model exposing (Model)
import Msg exposing (Msg(..))
import Route exposing (Route)
import Slide exposing (Slide)
import Style
import Style.Units as Units
import Time
import Url exposing (Url)
import Util.Cmd as CmdUtil
import View.Card as Card



--------------------------------------------------------------------------------
-- MAIN --
--------------------------------------------------------------------------------


main : Program Decode.Value Model Msg
main =
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = RouteChanged << Route.fromUrl
    , onUrlRequest = UrlRequested
    }
        |> Browser.application


init : Decode.Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        initialSlide : Slide
        initialSlide =
            url
                |> Route.fromUrl
                |> Maybe.map Slide.fromRoute
                |> Maybe.withDefault Slide.SlideDoesntExist
    in
    Model.init initialSlide key
        |> handleRoute (Route.fromUrl url)
        |> CmdUtil.withNoCmd



--------------------------------------------------------------------------------
-- SUBSCRIPTIONS --
--------------------------------------------------------------------------------


subscriptions : Model -> Sub Msg
subscriptions _ =
    [ Browser.Events.onKeyDown
        (Decode.field "key" Msg.arrowKeyDecoder)
    , Time.every 1000 (always SecondElapsed)
    ]
        |> Sub.batch



--------------------------------------------------------------------------------
-- UPDATE --
--------------------------------------------------------------------------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged maybeRoute ->
            handleRoute maybeRoute model
                |> CmdUtil.withNoCmd

        UrlRequested _ ->
            model
                |> CmdUtil.withNoCmd

        LeftPressed ->
            ( model, Model.digress model )

        RightPressed ->
            ( model, Model.progress model )

        PlayClicked audio ->
            ( model, Audio.play model.audioPlayerHtmlId audio )

        SecondElapsed ->
            model
                |> Model.incrementSecond
                |> CmdUtil.withNoCmd

        GoToTitleClicked ->
            ( model
            , Route.goTo model.navKey Route.Title
            )


handleRoute : Maybe Route -> Model -> Model
handleRoute maybeRoute =
    case maybeRoute of
        Nothing ->
            Model.setSlide Slide.SlideDoesntExist

        Just route ->
            route
                |> Slide.fromRoute
                |> Model.setSlide



--------------------------------------------------------------------------------
-- VIEW --
--------------------------------------------------------------------------------


view : Model -> Browser.Document Msg
view model =
    let
        mainContent : Html Msg
        mainContent =
            Grid.row
                [ flexDirection column
                , flex (int 1)
                , overflow hidden
                ]
                (Slide.view model.slide)

        timeView : Html Msg
        timeView =
            Grid.row
                [ marginTop <| px Units.size3 ]
                [ Html.p
                    [ Attrs.css
                        [ fontSize <| px Units.size5 ]
                    ]
                    [ Html.text <| "time = " ++ Model.formattedTime model ]
                ]
    in
    { title =
        "What has excited me about audio synthesis theory"
    , body =
        [ Style.globals
        , Html.audio
            [ Attrs.id model.audioPlayerHtmlId ]
            []
        , Grid.row
            [ flexDirection column
            , justifyContent center
            , height (pct 100)
            , padding <| px Units.size5
            ]
            [ Grid.column
                [ flex (int 1)
                , height (pct 100)
                ]
                [ Card.view
                    [ maxWidth (px 1000)
                    , Style.center
                    , flex (int 1)
                    ]
                    [ Card.body
                        []
                        [ mainContent
                        , timeView
                        ]
                    ]
                ]
            ]
        ]
            |> List.map Html.toUnstyled
    }
