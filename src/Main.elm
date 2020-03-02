module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


init =
    { pricePerShare = "1", quantity = "2", commission = "10", desiredProfit = "100" }


type Msg
    = ChangePrice String
    | ChangeQuantity String
    | ChangeCommission String
    | ChangeDesiredProfit String


type alias Model =
    { pricePerShare : String
    , quantity : String
    , commission : String
    , desiredProfit : String
    }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangePrice value ->
            { model | pricePerShare = value }

        ChangeQuantity value ->
            { model | quantity = value }

        ChangeCommission value ->
            { model | commission = value }

        ChangeDesiredProfit value ->
            { model | desiredProfit = value }


view model =
    div []
        [ h1 [] [ text "Stock Calculator" ]
        , input [ onInput ChangePrice, value model.pricePerShare, type_ "number" ] []
        , input [ onInput ChangeQuantity, value model.quantity, type_ "number" ] []
        , p []
            [ text
                (calculateResult
                    model
                )
            ]
        ]


calculateResult : Model -> String
calculateResult model =
    case Maybe.map2 (*) (String.toFloat model.pricePerShare) (String.toFloat model.quantity) of
        Just value ->
            String.fromFloat value

        Nothing ->
            ""


main =
    Browser.sandbox { init = init, view = view, update = update }

