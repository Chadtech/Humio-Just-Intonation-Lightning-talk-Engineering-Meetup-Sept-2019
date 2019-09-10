module Msg exposing
    ( Msg(..)
    , arrowKeyDecoder
    , goToTitleClicked
    , playClicked
    )

import Audio exposing (Audio)
import Browser exposing (UrlRequest)
import Json.Decode as Decode exposing (Decoder)
import Route exposing (Route)



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type Msg
    = RouteChanged (Maybe Route)
    | UrlRequested UrlRequest
    | LeftPressed
    | RightPressed
    | PlayClicked Audio
    | SecondElapsed
    | GoToTitleClicked


playClicked : Audio -> Msg
playClicked =
    PlayClicked


goToTitleClicked : Msg
goToTitleClicked =
    GoToTitleClicked



--------------------------------------------------------------------------------
-- DECODERS --
--------------------------------------------------------------------------------


arrowKeyDecoder : Decoder Msg
arrowKeyDecoder =
    let
        decoderFromString : String -> Decoder Msg
        decoderFromString str =
            case str of
                "ArrowLeft" ->
                    Decode.succeed LeftPressed

                "ArrowRight" ->
                    Decode.succeed RightPressed

                _ ->
                    Decode.fail "Not an arrow key"
    in
    Decode.string
        |> Decode.andThen decoderFromString
