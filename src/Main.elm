module Main exposing (main)

import Browser
import Debug exposing (toString)
import EmojiConverter exposing (textToEmoji)
import Html exposing (Html, button, div, input, label, nav, p, span, text)
import Html.Attributes as Attr exposing (class)
import Html.Events exposing (onInput)


main =
    Browser.sandbox { init = init, view = view, update = update }


type Msg
    = SetCurrentText String


type alias Model =
    { currentText : String }


init : Model
init =
    { currentText = "" }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCurrentText value ->
            { model | currentText = value }


view : Model -> Html Msg
view model =
    div []
        [ styles
        , navigation
        , input [ onInput SetCurrentText, class "center output-text emoji-size" ] []
        , switch
        , p [ class "center output-text emoji-size" ] [ text (translateText model) ]
        ]


translateText : Model -> String
translateText model =
    textToEmoji defaultKey model.currentText


defaultKey =
    "😅"


navigation : Html msg
navigation =
    nav []
        [ div
            [ class "nav-wrapper light-blue lighten-2" ]
            [ div
                [ class "brand-logo center" ]
                [ text "Elmoji Translator" ]
            ]
        ]


switch : Html msg
switch =
    div [ class "switch center" ]
        [ label []
            [ text "Translate Text"
            , input [ Attr.type_ "checkbox" ] []
            , span [ class "lever" ] []
            , text "Translate Emoji"
            ]
        ]


styles : Html msg
styles =
    Html.node "link"
        [ Attr.rel "stylesheet"
        , Attr.href "styles/main.css"
        ]
        []
