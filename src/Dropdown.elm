module Dropdown exposing (dropdown)

import Html exposing (div, text)
import Html.Attributes exposing (class, disabled, style)
import Html.Events exposing (onClick)
import Polymer.Paper as Paper
import Polymer.Attributes as PA


--import Polymer.Events exposing (onIronSelect, onSelectedChanged, onTap, onValueChanged)


listItem : (String -> msg) -> String -> Html.Html msg
listItem tagger label =
    Paper.item [ onClick (tagger label) ] [ text label ]


listboxWithMaybe : (String -> msg) -> Maybe String -> List String -> Html.Html msg
listboxWithMaybe tagger selectedItem list =
    let
        selectedIdx =
            case selectedItem of
                Nothing ->
                    "-1"

                Just val ->
                    case 
                        List.indexedMap (,) list
                        |> List.filter (\(idx, elem) -> elem == val) of

                            (i, el) :: xs ->
                                toString i

                            [] ->
                                "-1"
    in
        Paper.listbox [ class "dropdown-content", PA.selected selectedIdx ]
            (List.map (listItem tagger) list)


type alias DropdownConfig msg =
    { label : String
    , tagger : String -> msg
    , selected : Maybe String
    , items : List String
    , disabled : Bool
    }


dropdown : DropdownConfig msg -> Html.Html msg
dropdown cfg =
    Paper.dropdownMenu
        [ PA.label cfg.label, style [ ( "margin", "8px" ) ], disabled cfg.disabled ]
        [ listboxWithMaybe cfg.tagger cfg.selected cfg.items ]
