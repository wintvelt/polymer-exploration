module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (div, text)
import Dropdown exposing (dropdown)


-- WIRING


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { country : Maybe Country
    , city : Maybe City
    }


init : Model
init =
    { country = Nothing
    , city = Nothing
    }



-- simple types so we can read the code better


type alias Country =
    String


type alias City =
    String



-- global constants/ config


allCities : Dict Country (List City)
allCities =
    Dict.fromList
        [ ( "Spain", [ "Barcelona", "Madrid", "Alicante", "Valencia" ] )
        , ( "Germany", [ "Berlin", "München", "Bonn", "Leipzig" ] )
        , ( "France", [ "Paris", "Lyon", "Marseille", "Dijon" ] )
        , ( "Italy", [ "Florence", "Rome", "Milan" ] )
        ]


citiesForCountry : String -> List City
citiesForCountry country =
    Dict.get country allCities
        |> Maybe.withDefault []


countries : List Country
countries =
    Dict.keys allCities



-- UPDATE


type Msg
    = CountryPicked Country
    | CityPicked City


update : Msg -> Model -> Model
update msg model =
    case (Debug.log "msg" msg) of
        CountryPicked country ->
            { model
                | country = Just country
                , city =
                    if model.country == (Just country) then
                        model.city
                    else
                        Nothing
            }

        CityPicked city ->
            { model | city = Just city }



-- VIEW


view : Model -> Html.Html Msg
view model =
    let
        countryCfg =
            { label = "Country"
            , tagger = CountryPicked
            , selected = model.country
            , items = countries
            , disabled = False
            }

        ( isCityDisabled, cities ) =
            case model.country of
                Nothing ->
                    ( True, [] )

                Just country ->
                    ( False, citiesForCountry country )

        cityCfg =
            { label = "City"
            , tagger = CityPicked
            , selected = model.city
            , items = cities
            , disabled = isCityDisabled
            }
    in
        div []
            [ dropdown countryCfg, dropdown cityCfg ]
