module Data.Position exposing
    ( Position
    , browserDecoder
    , subtractFromX
    , subtractFromY
    )

import Json.Decode as Decode exposing (Decoder)



--------------------------------------------------------------------------------
-- TYPES --
--------------------------------------------------------------------------------


type alias Position =
    { x : Float
    , y : Float
    }



-----------------------------------------------------------------------------
-- HELPERS --
--------------------------------------------------------------------------------


subtractFromX : Float -> Position -> Position
subtractFromX f position =
    { position | x = position.x - f }


subtractFromY : Float -> Position -> Position
subtractFromY f position =
    { position | y = position.y - f }


browserDecoder : Decoder Position
browserDecoder =
    Decode.map2 Position
        (Decode.field "clientX" Decode.float)
        (Decode.field "clientY" Decode.float)
