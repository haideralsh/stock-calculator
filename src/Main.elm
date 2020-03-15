module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


init : Model
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
        [ h1 [] [ text "Stockie - A Tiny Stock Price Calculator" ]
        , div []
            [ label [ for "price per share" ] [ text "price per share" ]
            , input [ name "price per share", onInput ChangePrice, placeholder "Price Per Share", value model.pricePerShare, type_ "number", step "0.10" ] []
            ]
        , div []
            [ label [ for "quantity" ] [ text "quantity" ]
            , input [ name "quantity", onInput ChangeQuantity, placeholder "Quantity", value model.quantity, type_ "number", step "1" ] []
            ]
        , div []
            [ label [ for "commission" ] [ text "commission" ]
            , input [ name "commission", onInput ChangeCommission, placeholder "commission", value model.commission, type_ "number", step "0.10" ] []
            ]
        , div []
            [ label [ for "desired profit" ] [ text "desired profit" ]
            , input [ name "desired profit", onInput ChangeDesiredProfit, placeholder "Desired Profit", value model.desiredProfit, type_ "number", step "0.10" ] []
            ]
        , p []
            [ text
                (calculateResult
                    model
                )
            ]
        ]


floatIfInt : String -> Maybe Float
floatIfInt value =
    case String.toInt value of
        Just _ ->
            String.toFloat value

        Nothing ->
            -- TODO: Propagate the errors to the view?
            Nothing


calculateResult : Model -> String
calculateResult model =
    case
        -- TODO: Validate it is not a negative
        Maybe.map2 (/)
            (Maybe.map2 (+)
                (Maybe.map2 (*) (String.toFloat model.pricePerShare) (floatIfInt model.quantity))
                (Maybe.map2 (+)
                    (String.toFloat model.commission)
                    (String.toFloat model.desiredProfit)
                )
            )
            (String.toFloat model.quantity)
    of
        Just value ->
            -- TODO: Make it Html so you can add spans
            "Sell at $" ++ String.fromFloat value ++ " to make $" ++ model.desiredProfit

        Nothing ->
            "Please enter a valid input"


main : Program () Model Msg
main =
    Browser.sandbox { init = init, view = view, update = update }
