module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (div, text)
import Html.Attributes exposing (class, disabled, style)
import Html.Events exposing (onClick)
import Polymer.Paper as Paper
import Polymer.Attributes exposing (label, selected)


--import Polymer.Events exposing (onIronSelect, onSelectedChanged, onTap, onValueChanged)
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
            { model | country = Just country, city = Nothing }

        CityPicked city ->
            { model | city = Just city }



-- VIEW


listItem : (String -> msg) -> String -> Html.Html msg
listItem toMsg label =
    Paper.item [ onClick (toMsg label) ] [ text label ]


listboxWithMaybe : (String -> msg) -> Maybe String -> List String -> Html.Html msg
listboxWithMaybe toMsg selectedItem list =
    let
        selectedIdx =
            case selectedItem of
                Nothing ->
                    "-1"

                Just val ->
                    List.indexedMap (,) list
                        |> List.foldr
                            (\( idx, elem ) acc ->
                                if elem == val then
                                    idx
                                else
                                    acc
                            )
                            -1
                        |> toString
    in
        Paper.listbox [ class "dropdown-content", selected selectedIdx ]
            (List.map (listItem toMsg) list)


view : Model -> Html.Html Msg
view model =
    let
        countryDropdown =
            Paper.dropdownMenu [ label "Country", style [ ( "margin", "8px" ) ] ] [ listboxWithMaybe CountryPicked model.country countries ]

        ( isCityDisabled, cities ) =
            case model.country of
                Nothing ->
                    ( True, [] )

                Just country ->
                    ( False, citiesForCountry country )

        cityDropdown =
            Paper.dropdownMenu [ label "City", disabled isCityDisabled, style [ ( "margin", "8px" ) ] ] [ listboxWithMaybe CityPicked model.city cities ]
    in
        div []
            [ countryDropdown, cityDropdown ]
