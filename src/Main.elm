module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (div, text)
import Html.Attributes exposing (class, disabled)
import Polymer.Paper as Paper
import Polymer.Attributes exposing (label, selected)
import Polymer.Events exposing (onIronSelect, onSelectedChanged, onTap, onValueChanged)


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
    { country = Just "Spain"
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
    | Dbg String


update : Msg -> Model -> Model
update msg model =
    case msg of
        CountryPicked country ->
            { model | country = Just country, city = Nothing }

        CityPicked city ->
            { model | city = Just city }

        Dbg str ->
            Debug.log str model



-- VIEW


listItem : String -> Html.Html msg
listItem label =
    Paper.item [] [ text label ]


listboxWithMaybe : (String -> msg) -> Maybe String -> List String -> Html.Html msg
listboxWithMaybe msg selectedItem list =
    let
        selectedIdx =
            case selectedItem of
                Nothing ->
                    ""

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
        Paper.listbox [ class "dropdown-content", selected selectedIdx, onIronSelect msg ]
            (List.map listItem list)


view : Model -> Html.Html Msg
view model =
    let
        countryDropdown =
            Paper.dropdownMenu [ label "Country" ] [ listboxWithMaybe Dbg model.country countries ]

        ( isCityDisabled, cities ) =
            case model.country of
                Nothing ->
                    ( True, [] )

                Just country ->
                    ( False, citiesForCountry country )

        cityDropdown =
            Paper.dropdownMenu [ label "City", disabled isCityDisabled ] [ listboxWithMaybe Dbg model.city cities ]
    in
        div []
            [ countryDropdown, cityDropdown ]
