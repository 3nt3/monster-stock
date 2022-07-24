module Pages.Home_ exposing (Model, Msg, page)

import Dict exposing (Dict)
import Element exposing (..)
import Gen.Params.Home_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }



-- INIT


type alias Model =
    { inStock : List ItemInfo }


type alias ItemInfo =
    { typeOfThing : String
    , amount : Int
    , place : String
    }


init : Model
init =
    { inStock = [ { typeOfThing = "monster", amount = 2, place = "pallet" }, { typeOfThing = "monster", amount = 3, place = "fridge" } ] }



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> Model
update msg model =
    case msg of
        ReplaceMe ->
            model



-- VIEW


monsterInStock : Model -> Maybe Int
monsterInStock model =
    List.filter (\x -> x.typeOfThing == "monster") model.inStock |> List.head |> Maybe.map (\x -> x.amount)


countByPlace : List ItemInfo -> Dict String Int
countByPlace items =
    List.foldl
        (\x last ->
            Dict.update x.place
                (\value ->
                    Just (Maybe.withDefault x.amount (Maybe.map (\asdf -> asdf + x.amount) value))
                )
                last
        )
        Dict.empty
        items


view : Model -> View Msg
view model =
    { title = "Monster stock"
    , element =
        column []
            [ el [] <|
                text ((Maybe.withDefault 0 (monsterInStock model) |> String.fromInt) ++ " cans of monster in stock")
            , column
                []
                ((countByPlace model.inStock |> Dict.toList)
                    |> List.map (\( place, amount ) -> el [] (text (String.fromInt amount ++ " cans of monster at " ++ place)))
                )
            ]
    }
