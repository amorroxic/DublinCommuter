class DublinCommuter extends LocalStorage

    @LUAS_STATUS    = 'somethings_happening_with_the_data_here'

    @luasManager        = null
    @weatherManager     = null
    @offsiteMenu        = null

    constructor: () ->
        do @initialize

    initialize: () ->
        params =
            latitude    : 53.309839
            longitude   : -6.25174

        @luasManager = new LuasManager params
        @luasManager.addListener LuasManager.STATION_FOUND, @handleLuasStationFound
        @luasManager.addListener LuasManager.STATION_UNKNOWN, @handleLuasStationUnknown
        @luasManager.addListener LuasManager.SYSTEM_DOWN, @handleLuasSystemDown
        @luasManager.addListener LuasManager.FORECAST_SUCCESS, @handleLuasForecastSuccess
        @luasManager.addListener LuasManager.FORECAST_FAILED, @handleLuasForecastFailure

        @weatherManager = new ForecastManager params
        @weatherManager.addListener ForecastManager.FORECAST_SUCCESS, @handleWeatherForecastSuccess
        @weatherManager.addListener ForecastManager.FORECAST_FAILED, @handleWeatherForecastFailed

        @offsiteMenu = new OffsiteMenu '#one-container-to-rule-them-all'


        #@cities = new Cities
        #@cities.addListener Cities.CITIES_NEW, @handleNewCityLoaded
        #@cities.addListener Cities.CITIES_COMPLETE, @handleAllCitiesLoaded
        #@cities.addListener Cities.CITIES_UPDATE, @handleCityWasRefreshed
        #@cities.addListener Cities.CITIES_FAILURE, @handleCityRefreshError
        #@cities.addListener Cities.CITIES_UNKNOWN, @handleCitiesIsUnknown

        #@mapInstance = new Maps 'container'
        #@mapInstance.addListener Maps.LOCATION_IS_REMOVED, @handleLocationRemovedFromMap

        #@autocompleteInstance = new AutoComplete 'searchbox'
        #@autocompleteInstance.addListener AutoComplete.AUTOCOMPLETE_QUERY, @handleAutocompleteAddCity
        #@autocompleteInstance.addListener AutoComplete.AUTOCOMPLETE_NOTFOUND, @handleAutocompleteLocationNotFound
        #gmapInstance = do @mapInstance.getGoogleMapsInstance
        #@autocompleteInstance.bindToGoogleMap gmapInstance

        #$('.blue-pill').bind 'click', (e) =>
            #do @cities.coldRefreshForecasts

    run: () ->
        do @luasManager.populate
        do @weatherManager.populate

    handleLuasStationFound: (data) =>
        @emitEvent DublinCommuter.LUAS_STATUS, [@]

    handleLuasStationUnknown: (data) =>
        @emitEvent DublinCommuter.LUAS_STATUS, [@]
        #@luasManager.setStation data[0]

    handleLuasSystemDown: () =>
        @emitEvent DublinCommuter.LUAS_STATUS, [@]

    handleLuasForecastSuccess: (data) =>
        @emitEvent DublinCommuter.LUAS_STATUS, [@]

    handleLuasForecastFailure: (data) =>

    handleWeatherForecastSuccess: (data) =>

    handleWeatherForecastFailed: (data) =>


    #run: () ->
        #do @cities.populate

    #handleNewCityLoaded: (params) =>
        #@mapInstance.addCityToMap params

    #handleAllCitiesLoaded: () =>
        #do @cities.mildRefreshForecasts

    #handleCityWasRefreshed: (params) =>
        #@mapInstance.updateCity params

    #handleCityRefreshError: (params) =>
        #console.log "Failed updating forecast for "+params.name

    #handleCitiesIsUnknown: (params) =>
        #console.log "Could not geolocate "+params.name

    #handleLocationRemovedFromMap: (cityID) =>
        #@cities.removeCity cityID

    #handleAutocompleteAddCity: (cityName) =>
        #@cities.generateIdAndAddCity cityName

    #handleAutocompleteLocationNotFound: () =>
        #console.log 'Location not found'
