port module Audio exposing
    ( Audio(..)
    , play
    )

import Json.Encode as Encode



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type Audio
    = SineWaveDemo
    | IdealFlute
    | IdealFlute__SineWave
    | ElmVoice
    | ElmVoice__E
    | ElmVoice__L
    | ElmVoice__M
    | ElmVoice__Uh
    | ElmVoice__AllTogether
    | ActualSnareDrum
    | SynthesizedSnareDrum



--------------------------------------------------------------------------------
-- HELPERS --
--------------------------------------------------------------------------------


toFilePathBase : Audio -> String
toFilePathBase audio =
    case audio of
        SineWaveDemo ->
            "sine-wave-demo"

        IdealFlute ->
            "ideal-flute"

        IdealFlute__SineWave ->
            "flute-tone"

        ElmVoice ->
            "elm-voice"

        ElmVoice__E ->
            "elm-voice-e"

        ElmVoice__M ->
            "elm-voice-m"

        ElmVoice__L ->
            "elm-voice-l"

        ElmVoice__Uh ->
            "elm-voice-uh"

        ElmVoice__AllTogether ->
            "elm-voice-all-together"

        ActualSnareDrum ->
            "marching-snare-drum"

        SynthesizedSnareDrum ->
            "elm-europe-snare-final"


toFilePath : Audio -> String
toFilePath audio =
    "./" ++ toFilePathBase audio ++ ".mp3"


play : String -> Audio -> Cmd msg
play htmlId audio =
    [ Tuple.pair "htmlId" <| Encode.string htmlId
    , Tuple.pair "filePath" <| Encode.string (toFilePath audio)
    ]
        |> Encode.object
        |> playAudio


port playAudio : Encode.Value -> Cmd msg
