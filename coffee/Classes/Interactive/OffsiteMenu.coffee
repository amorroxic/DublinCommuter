class OffsiteMenu extends BaseFunctionality

    @meny                   = null

    constructor: (selectorID) ->

        options =
            menuElement: document.querySelector '.menymenu'
            contentsElement: document.querySelector '.pagecontainer'
            position: 'left'
            height: 200
            width: 260
            mouse: true
            touch: true
        @meny               = Meny.create options

        do @bindUIListeners

    bindUIListeners: () ->
        ($ document).on 'click',@parentSelectorID, (e) =>
            type = $(e.currentTarget).data "effeckt"
            threedee = $(e.currentTarget).data "threedee"
            @toggleNavigation type,threedee

    toggleNavigation: (type,threedee) ->
        if not @opened
            $("#effeckt-off-screen-nav").addClass type
            if threedee
                $('html').addClass 'md-perspective'
            setTimeout ->
                $("#effeckt-off-screen-nav").addClass 'effeckt-off-screen-nav-show'
            ,100
        else
            $("#effeckt-off-screen-nav").removeClass 'effeckt-off-screen-nav-show'
            setTimeout ->
                $("#effeckt-off-screen-nav").removeClass type
                do $("#effeckt-off-screen-nav").hide
                a = $("#effeckt-off-screen-nav").width
                do $("#effeckt-off-screen-nav").show
                $('html').removeClass 'md-perspective'
            ,100

        @opened = not @opened


