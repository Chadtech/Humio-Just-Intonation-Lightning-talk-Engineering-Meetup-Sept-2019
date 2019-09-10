module Model exposing
    ( Model
    , digress
    , formattedTime
    , incrementSecond
    , init
    , progress
    , setSlide
    )

import Browser.Navigation as Nav
import Route exposing (Route)
import Slide exposing (Slide)



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type alias Model =
    { slide : Slide
    , audioPlayerHtmlId : String
    , navKey : Nav.Key
    , time : Int
    }


init : Slide -> Nav.Key -> Model
init slide key =
    { slide = slide
    , audioPlayerHtmlId = "audio-player"
    , navKey = key
    , time = 0
    }



--------------------------------------------------------------------------------
-- HELPERS --
--------------------------------------------------------------------------------


incrementSecond : Model -> Model
incrementSecond model =
    { model | time = model.time + 1 }


setSlide : Slide -> Model -> Model
setSlide slide model =
    { model | slide = slide }


progress : Model -> Cmd msg
progress model =
    Route.goTo model.navKey (Slide.next model.slide)


digress : Model -> Cmd msg
digress model =
    Route.goTo model.navKey (Slide.prev model.slide)


formattedTime : Model -> String
formattedTime { time } =
    [ String.fromInt (time // 60)
    , doubleDigits <| String.fromInt <| modBy 60 time
    ]
        |> String.join ":"


doubleDigits : String -> String
doubleDigits str =
    if String.length str == 1 then
        "0" ++ str

    else
        str
