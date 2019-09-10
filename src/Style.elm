module Style exposing
    ( borderNone
    , center
    , fontSmoothingNone
    , globals
    , hfnss
    , indent
    , outdent
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Global exposing (global)
import Html.Styled as Html exposing (Html)
import Style.Units as Units


globals : Html msg
globals =
    [ Css.Global.p
        [ color Ct.content4
        , fontSmoothingNone
        , hfnss
        ]
    , Css.Global.button
        [ hfnss
        , fontSmoothingNone
        , outline none
        , minWidth (px Units.size6)
        , height (px Units.size4)
        , boxSizing borderBox
        , padding2 zero (px Units.size3)
        , cursor pointer
        , outdent
        , backgroundColor Ct.content1
        , color Ct.content4
        , hover
            [ color Ct.content5
            ]
        , active
            [ color Ct.content5
            , indent
            ]
        ]
    , Css.Global.body
        [ backgroundColor Ct.background1 ]
    , Css.Global.everything
        [ boxSizing borderBox
        , margin zero
        , padding zero
        ]
    ]
        |> global


borderNone : Style
borderNone =
    property "border" "none"


indent : Style
indent =
    [ borderLeft3 (px Units.size0) solid Ct.content0
    , borderTop3 (px Units.size0) solid Ct.content0
    , borderRight3 (px Units.size0) solid Ct.content2
    , borderBottom3 (px Units.size0) solid Ct.content2
    ]
        |> Css.batch


outdent : Style
outdent =
    [ borderLeft3 (px Units.size0) solid Ct.content2
    , borderTop3 (px Units.size0) solid Ct.content2
    , borderRight3 (px Units.size0) solid Ct.content0
    , borderBottom3 (px Units.size0) solid Ct.content0
    ]
        |> Css.batch


hfnss : Style
hfnss =
    [ fontFamilies [ "HFNSS" ]
    , fontSize (px 32)
    ]
        |> Css.batch


fontSmoothingNone : Style
fontSmoothingNone =
    property "-webkit-font-smoothing" "none"


center : Style
center =
    margin2 zero auto
