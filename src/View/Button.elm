module View.Button exposing
    ( disabled
    , selected
    , view
    )

import Chadtech.Colors as Ct
import Css exposing (..)
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        )
import Style as Style


view : List (Attribute msg) -> String -> Html msg
view attrs label =
    Html.button
        attrs
        [ Html.text label ]


disabled : Style
disabled =
    [ cursor default
    , backgroundColor Ct.content2
    , color Ct.content3
    ]
        |> Css.batch


selected : Style
selected =
    [ backgroundColor Ct.content1
    , color Ct.content5
    , Style.indent
    , hover [ color Ct.content5 ]
    ]
        |> Css.batch
