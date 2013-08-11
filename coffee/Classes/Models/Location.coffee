class Location extends LocalStorage

    @id                 = null
    @location           = null
    @coordinates        = null
    @isGeolocated       = null

    @forecastManager    = null
    @luasManager        = null

    @LOCATION_LOADED            = "location_cache_loaded"
    @LOCATION_UNKNOWN           = "location_is_unknown"

    constructor: (params) ->
        @id                 = params.id
        @location           = params.name
        @coordinates        = null
        @isGeolocated       = no
        log "New location"
        log @

    populate: () ->
        isInitialized       = do @cacheLoad
        if isInitialized
            @emitEvent Location.LOCATION_LOADED, [@]

    cacheLoad: () ->
        loaded = no
        if @id?
            data = @retrieve @id
            if data?
                @isGeolocated = @populateCoordinates data
                if not @isGeolocated
                    do @geolocateMe
                else
                    loaded = yes
                    do @feedLocationInformation
            else
                do @geolocateMe

        loaded

    feedLocationInformation: () ->
        params =
            id          : @id
            name        : @location
            latidude    : @coordinates.latitude
            longitude   : @coordinates.longitude

        @forecastManager    = new ForecastManager params
        @forecastManager.addListener ForecastManager.FORECAST_SUCCESS, @forecastSuccess
        @forecastManager.addListener ForecastManager.FORECAST_FAILED, @forecastFailure

        @luasManager   = new LuasManager params
        @luasManager.addListener LuasManager.STATION_FOUND, @luasStationFound
        @luasManager.addListener LuasManager.STATION_UNKNOWN, @luasStationUnknown
        @luasManager.addListener LuasManager.SYSTEM_DOWN, @luasSystemDown

    cacheSave: () ->
        saved = no
        if @id?
            @store @id, @
            saved = yes
        saved

    destroy: () ->
        @remove @id
        @isGeolocated = no
        @hasForecast = no
        @forecast = {}

    populateCoordinates: (data) ->
        foundCoordinates = no
        if data.coordinates?
            @location = data.location
            @coordinates = {}
            @coordinates.latitude = data.coordinates.latitude
            @coordinates.longitude = data.coordinates.longitude
            foundCoordinates = yes
        foundCoordinates

    geolocateMe: () ->
        coder = new Geocoder @location
        coder.addListener Geocoder.SUCCESS, @geolocationSuccess
        coder.addListener Geocoder.FAILURE, @geolocationFailure
        do coder.perform

    geolocationSuccess: (data) =>
        @location = data.location
        @isGeolocated = @populateCoordinates data
        do @cacheSave
        @emitEvent Location.LOCATION_LOADED, [@]

    geolocationFailure: (text) =>
        @emitEvent Location.LOCATION_UNKNOWN, [@]

    showData: () ->
        # console.log @
