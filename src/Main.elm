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
    { destination : Maybe CitySelection
    }


init : Model
init =
    { destination = Nothing
    }


-- City selection to prevent impossible states :)

type CitySelection =
    CitySelection
        { country : Country
        , city : Maybe City
        }
    
citySelect : City -> CitySelection -> CitySelection
citySelect newCity (CitySelection { country, city }) =
    CitySelection { country = country, city = Just newCity }
  
countrySelect : Country -> CitySelection -> CitySelection
countrySelect newCountry (CitySelection { country, city } as old) =
      if newCountry /= country then
        CitySelection { country = newCountry, city = Nothing }
      else 
        old

newSelect : Country -> CitySelection
newSelect newCountry =
    CitySelection { country = newCountry, city = Nothing }

cityFrom : CitySelection -> Maybe City
cityFrom (CitySelection { country, city }) =
    city

countryFrom : CitySelection -> Country
countryFrom (CitySelection { country, city }) =
    country



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
        CountryPicked newCountry ->
            { model
                | destination =
                    model.destination
                    |> Maybe.map (countrySelect newCountry)
                    |> Maybe.withDefault (newSelect newCountry)
                    |> Just
            }

        CityPicked newCity ->
            { model
                | destination =
                    model.destination
                    |> Maybe.map (citySelect newCity)
            }



-- VIEW


view : Model -> Html.Html Msg
view model =
    let
        countryCfg =
            { label = "Country"
            , tagger = CountryPicked
            , selected =
                model.destination
                |> Maybe.map countryFrom
            , items = countries
            , disabled = False
            }

        ( isCityDisabled, cities ) =
            case model.destination of
                Nothing ->
                    ( True, [] )

                Just destination ->
                    ( False, citiesForCountry <| countryFrom destination )

        cityCfg =
            { label = "City"
            , tagger = CityPicked
            , selected = 
                model.destination
                |> Maybe.andThen cityFrom
            , items = cities
            , disabled = isCityDisabled
            }
    in
        div []
            [ dropdown countryCfg, dropdown cityCfg ]
