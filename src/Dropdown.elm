module Dropdown exposing (dropdown)

import Html exposing (div, text)
import Html.Attributes exposing (class, disabled, style)
import Html.Events exposing (onClick)
import Polymer.Paper as Paper
import Polymer.Attributes as PA


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
        Paper.listbox [ class "dropdown-content", PA.selected selectedIdx ]
            (List.map (listItem toMsg) list)


type alias DropdownConfig msg =
    { label : String
    , toMsg : String -> msg
    , selected : Maybe String
    , items : List String
    , disabled : Bool
    }


dropdown : DropdownConfig msg -> Html.Html msg
dropdown cfg =
    Paper.dropdownMenu
        [ PA.label cfg.label, style [ ( "margin", "8px" ) ], disabled cfg.disabled ]
        [ listboxWithMaybe cfg.toMsg cfg.selected cfg.items ]
