module Main exposing (..)

import Task exposing (Task)
import Html exposing (Html, div, button, text)
import Http
import Item as Item exposing (getItem)


main =
    Html.program { init = init, update = update, view = view, subscriptions = \_ -> Sub.none }


type alias Msg =
    Result Http.Error Item


type alias Model =
    Maybe Item


init : ( Model, Cmd Msg )
init =
    let
        commands =
            GetItem.item { id = "1000" }
                |> Task.perform Err Ok
    in
        ( Nothing, commands )


view : Model -> Html Msg
view model =
    case model of
        Just res ->
            text (toString res)

        Nothing ->
            text "no result yet"



-- todo: add failure as a 3rd state w/reason


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Ok res ->
            ( Just res, Cmd.none )

        Err e ->
            ( Nothing, Cmd.none )
