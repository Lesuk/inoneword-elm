module Entries.Partials.EntriesGridBlock exposing (entriesGridBlock)

import App.Routing exposing (Route(EntryRoute), routeToPath)
import App.Translations exposing (Language, TranslationId(NumberOfVotesText, ShowAllText), translate)
import App.Utils.Cloudinary exposing (cloudinaryUrl_240)
import App.Utils.Links exposing (linkTo)
import Entries.Messages exposing (Msg(Navigate, PopulateEntry, ScrollToTop))
import Entries.Models exposing (Entry)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onMouseUp)
import Html.Keyed as Keyed
import Material.Icon as Icon


type alias Title =
    String


type alias SubTitle =
    String


type alias ShowAllUrl =
    String


entriesGridBlock : List Entry -> Title -> SubTitle -> Maybe ShowAllUrl -> Bool -> Language -> Html Msg
entriesGridBlock entries title subTitle showAllUrl crop language =
    div [ class (gridBlockClass crop) ]
        [ div [ class "entries-grid__header h-clearfix" ]
            [ div [ class "entries-grid__header-info" ]
                [ h2 [ class "entries-grid__header-title" ]
                    [ text title ]
                , span [ class "entries-grid__header-subtitle" ]
                    [ text subTitle ]
                ]
            , div [ class "entries-grid__header-actions" ]
                [ showAllButton showAllUrl language ]
            ]
        , Keyed.ul [ class "entries-grid__list" ]
            (List.map (entryItem language) entries)
        ]


gridBlockClass : Bool -> String
gridBlockClass crop =
    let
        base =
            "entries-grid__block"
    in
    if crop then
        base ++ " cropped"
    else
        base


entryItem : Language -> Entry -> ( String, Html Msg )
entryItem language entry =
    let
        entryPath =
            routeToPath (EntryRoute entry.slug entry.id)

        entryImgSrc =
            cloudinaryUrl_240 entry.image.url

        listItem =
            li
                [ id entry.id
                , class "egrid-item"
                , onMouseUp (PopulateEntry entry)
                ]
                [ linkTo entryPath
                    (Navigate entryPath)
                    [ onMouseUp ScrollToTop
                    , class "egrid-item__link"
                    ]
                    [ img
                        [ class "egrid-item__img h-full-width h-absolute-position lazyload"
                        , attribute "data-src" entryImgSrc
                        , src "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="
                        , alt entry.title
                        , title entry.title
                        ]
                        []
                    , div [ class "egrid-item__caption" ]
                        [ h2 [ class "egrid-item__caption-title h-overflow-ellipsis", title entry.title ]
                            [ text entry.title ]
                        , h3 [ class "egrid-item__caption-subtitle h-overflow-ellipsis" ]
                            [ text <| translate language <| NumberOfVotesText entry.votesCount ]
                        ]
                    ]
                ]
    in
    ( entry.id, listItem )


showAllButton : Maybe ShowAllUrl -> Language -> Html Msg
showAllButton showAllUrl language =
    case showAllUrl of
        Just url ->
            linkTo url
                (Navigate url)
                [ class "entries-grid__all-btn" ]
                [ span [ class "entries-grid__all-btn-text" ]
                    [ text <| translate language ShowAllText ]
                , span [ class "entries-grid__all-btn-icon" ]
                    [ Icon.i "arrow_forward" ]
                ]

        Nothing ->
            span [] []
