module View.Card exposing
    ( Model
    , Msg
    , Payload
    , body
    , closeButton
    , decoder
    , encode
    , header
    , headerContent
    , headerMouseEvents
    , headerTitle
    , initFromPosition
    , positioningStyle
    , subscriptions
    , unfocusedHeader
    , update
    , view
    )

import Browser.Events exposing (onMouseMove, onMouseUp)
import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Animations as Animations
import Data.Position as Position exposing (Position)
import Html.Events.Extra.Mouse as Mouse
import Html.Grid as Grid
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes as Attrs
import Html.Styled.Events as Events
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Style as Style
import Style.Units as Units
import View.Button as Button



-- TYPES --


type Msg
    = MouseDown ( Float, Float )
    | MouseMove Position
    | MouseUp Position


type MouseState
    = ReadyForClick
    | ClickAt Float Float


type alias Model =
    { x : Float
    , y : Float
    , mouseState : MouseState
    }


setMouseState : MouseState -> Model -> Model
setMouseState mouseState model =
    { model | mouseState = mouseState }


subtractPosition : Position -> Model -> Model
subtractPosition position model =
    case model.mouseState of
        ClickAt clickAtX clickAtY ->
            { model
                | x = position.x - clickAtX
                , y = position.y - clickAtY
            }

        _ ->
            model


initFromPosition : Position -> Model
initFromPosition position =
    { x = position.x
    , y = position.y
    , mouseState = ReadyForClick
    }


type alias Payload msg =
    { title : String
    , closeClickHandler : Maybe msg
    , positioning : Maybe ( Msg -> msg, Model )
    }



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.mouseState of
        ReadyForClick ->
            Sub.none

        ClickAt _ _ ->
            [ onMouseMove (mouseCtor MouseMove)
            , onMouseUp (mouseCtor MouseUp)
            ]
                |> Sub.batch


mouseCtor : (Position -> Msg) -> Decoder Msg
mouseCtor ctor =
    Decode.map ctor Position.browserDecoder



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        MouseDown ( x, y ) ->
            setMouseState
                (ClickAt (x + 40) (y + 71))
                model

        MouseMove mousePosition ->
            model
                |> subtractPosition mousePosition

        MouseUp mousePosition ->
            model
                |> subtractPosition mousePosition
                |> setMouseState ReadyForClick



-- VIEW --


view : List Style -> List (Html msg) -> Html msg
view styles =
    Html.node "card"
        [ Attrs.css
            [ Css.batch styles
            , containerStyle
            ]
        ]


containerStyle : Style
containerStyle =
    [ Style.outdent
    , backgroundColor Ct.content1
    , boxSizing borderBox
    , displayFlex
    , flexDirection column
    , property "animation-duration" "150ms"
    , [ ( 0, [ Animations.transform [ scale 0 ] ] )
      , ( 100, [ Animations.transform [ scale 1 ] ] )
      ]
        |> Animations.keyframes
        |> animationName
    ]
        |> Css.batch


positioningStyle : Model -> Style
positioningStyle model =
    [ position absolute
    , left (px model.x)
    , top (px model.y)
    ]
        |> Css.batch


header : List Style -> List (Html msg) -> Html msg
header styles children =
    Grid.row
        []
        [ Grid.column
            [ padding (px Units.size1)
            , displayFlex
            , backgroundColor Ct.content3
            , margin (px Units.size0)
            , Css.batch styles
            ]
            children
        ]


unfocusedHeader : Style
unfocusedHeader =
    backgroundColor Ct.content2


headerContent : List (Attribute msg) -> List (Html msg) -> Html msg
headerContent attrs =
    Html.node "card-header"
        (Attrs.css [ headerStyle ] :: attrs)


headerMouseEvents : List (Attribute Msg)
headerMouseEvents =
    [ Mouse.onDown (MouseDown << .offsetPos)
        |> Attrs.fromUnstyled
    ]


headerTitle : String -> Html msg
headerTitle str =
    Html.p
        [ Attrs.css [ headerTextStyle ] ]
        [ Html.text str ]


closeButton : msg -> Html msg
closeButton msg =
    Button.view
        [ Attrs.css
            [ width (px Units.size4)
            , minWidth (px Units.size4)
            , padding zero
            , paddingBottom (px 2)
            ]
        , Events.onClick msg
        ]
        "x"


headerCloseButton : Html msg
headerCloseButton =
    Html.button
        [ Attrs.css [ headerCloseButtonStyle ] ]
        [ Html.text "x" ]


headerCloseButtonStyle : Style
headerCloseButtonStyle =
    [ position absolute
    , width (px Units.size4)
    , height (px Units.size4)
    , padding zero
    , paddingBottom (px 2)
    , Style.indent
    , backgroundColor Ct.content2
    , active [ backgroundColor Ct.content0 ]
    , boxSizing borderBox
    , lineHeight (px 14)
    ]
        |> Css.batch


headerTextStyle : Style
headerTextStyle =
    [ color Ct.content0
    , lineHeight (px Units.size4)
    , textAlign center
    ]
        |> Css.batch


headerStyle : Style
headerStyle =
    [ height (px Units.size4)
    , flex (int 1)
    , position relative
    ]
        |> Css.batch


body : List Style -> List (Html msg) -> Html msg
body styles children =
    Grid.row
        [ flex (int 1)
        , height (pct 100)
        , Css.batch styles
        ]
        [ Grid.column
            [ padding (px Units.size1)
            , flexDirection column
            ]
            [ Html.node "card-body"
                [ Attrs.css
                    [ boxSizing borderBox
                    , backgroundColor Ct.content1
                    , flex2 (int 0) (int 1)
                    , flexBasis auto
                    , displayFlex
                    , flexDirection column
                    , height (pct 100)
                    , justifyContent spaceBetween
                    ]
                ]
                children
            ]
        ]


encode : Model -> Encode.Value
encode model =
    [ ( "x", Encode.float model.x )
    , ( "y", Encode.float model.y )
    ]
        |> Encode.object


decoder : Decoder Model
decoder =
    Decode.map3 Model
        (Decode.field "x" Decode.float)
        (Decode.field "y" Decode.float)
        (Decode.succeed ReadyForClick)
