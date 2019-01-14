module Main exposing (main)

import Browser
import Debug exposing (toString)
import EmojiConverter exposing (emojiToText, textToEmoji)
import Html exposing (Html, button, div, h4, input, label, nav, p, section, span, text)
import Html.Attributes as Attr exposing (class, classList)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, view = view, update = update }


type Msg
    = SetCurrentText String
    | ToggleDirection
    | SetDefaultKey String


type alias Model =
    { currentText : String, direction : Direction, defaultKey : String }


type Direction
    = TextToEmoji
    | EmojiToText


init : Model
init =
    { currentText = "", direction = TextToEmoji, defaultKey = "😅" }


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetCurrentText value ->
            { model | currentText = value }

        ToggleDirection ->
            case model.direction of
                TextToEmoji ->
                    { model | direction = EmojiToText }

                EmojiToText ->
                    { model | direction = TextToEmoji }

        SetDefaultKey key ->
            { model | defaultKey = key }


view : Model -> Html Msg
view model =
    div []
        [ styles
        , navigation
        , input [ onInput SetCurrentText, class "center output-text emoji-size" ] []
        , switch
        , p [ class "center output-text emoji-size" ] [ text (translateText model) ]
        , div [ class "divider" ] []
        , Html.section
            [ class "container" ]
            [ h4
                [ class "center" ]
                [ text "Select Your Key" ]
            , renderKeys model
            ]
        ]


renderKeys : Model -> Html Msg
renderKeys model =
    div [ class "row" ] (List.map (\emoji -> renderKey model.defaultKey emoji) EmojiConverter.supportedEmojis)


renderKey : String -> String -> Html Msg
renderKey defaultKey emoji =
    div
        [ classList [ ( "key-selector", True ), ( "is-selected", emoji == defaultKey ) ]
        , onClick (SetDefaultKey emoji)
        ]
        [ text emoji ]


translateText : Model -> String
translateText model =
    case model.direction of
        TextToEmoji ->
            textToEmoji model.defaultKey model.currentText

        EmojiToText ->
            emojiToText model.defaultKey model.currentText


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


switch : Html Msg
switch =
    div [ class "switch center" ]
        [ label []
            [ text "Translate Text"
            , input [ Attr.type_ "checkbox", onClick ToggleDirection ] []
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
