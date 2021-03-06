module App.Partials.Footer exposing (view)

import App.Messages exposing (Msg(ChangeLanguage, RemoveLocalJWT, ScrollToTop))
import App.Translations exposing (..)
import App.Utils.Config exposing (githubRepoLink)
import Html exposing (Html, text)
import Html.Attributes exposing (target)
import Material.Footer as Footer
import Material.Options as Options exposing (attribute, cs, css)
import Users.Models exposing (User)
import Users.Utils exposing (userIsActive)


view : User -> Language -> Html Msg
view user language =
    Footer.mega []
        { top =
            Footer.top []
                { left = Footer.left [] []
                , right = Footer.right [] []
                }
        , middle =
            Footer.middle []
                [ languagesSection language
                , websiteSection user language
                ]
        , bottom = Footer.bottom [] []
        }


languagesSection : Language -> Footer.Content Msg
languagesSection language =
    let
        linkItem ( lang, linkText ) =
            Footer.linkItem
                [ Options.onClick (ChangeLanguage lang)
                , Options.onMouseUp ScrollToTop
                , cs "h-clickable"
                ]
                [ Footer.html (text linkText) ]

        links =
            [ ( English, "English" )
            , ( Ukrainian, "Українська" )
            , ( Russian, "Русский" )
            , ( Spanish, "Español" )
            ]
                |> List.map linkItem
    in
    Footer.dropdown []
        [ Footer.heading []
            [ Footer.html <| text <| translate language LanguagesText ]
        , Footer.links [] links
        ]


websiteSection : User -> Language -> Footer.Content Msg
websiteSection user language =
    Footer.dropdown []
        [ Footer.heading [] [ Footer.html <| text "Website" ]
        , Footer.links []
            [ Footer.linkItem
                [ Footer.href githubRepoLink
                , cs "h-clickable"
                , attribute <| target "_blank"
                ]
                [ Footer.html <| text "Github" ]
            , logoutLink language user
            ]
        ]


logoutLink : Language -> User -> Footer.Content Msg
logoutLink language user =
    if userIsActive user then
        Footer.linkItem
            [ Options.onClick RemoveLocalJWT
            , Options.onMouseUp ScrollToTop
            , cs "h-clickable"
            ]
            [ Footer.html <| text <| translate language LogoutText ]
    else
        Footer.html <| text ""
