class DublinCommuter extends LocalStorage

    @STATUS_CHANGE_EVENT = 'somethings_happening_with_the_data_here'

    @luasManager        = null
    @weatherManager     = null
    @offsiteMenu        = null

    constructor: () ->
        do @initialize

    initialize: () ->
        params =
            latitude    : 53.309839
            longitude   : -6.25174

        @luasManager = new LuasManager
        @luasManager.addListener LuasManager.STATION_FOUND, @handleLuasStationFound
        @luasManager.addListener LuasManager.STATION_UNKNOWN, @handleLuasStationUnknown
        @luasManager.addListener LuasManager.SYSTEM_DOWN, @handleLuasSystemDown
        @luasManager.addListener LuasManager.FORECAST_SUCCESS, @handleLuasForecastSuccess
        @luasManager.addListener LuasManager.FORECAST_FAILED, @handleLuasForecastFailure

        @weatherManager = new ForecastManager
        @weatherManager.addListener ForecastManager.FORECAST_SUCCESS, @handleWeatherForecastSuccess
        @weatherManager.addListener ForecastManager.FORECAST_FAILED, @handleWeatherForecastFailed

        #@offsiteMenu = new OffsiteMenu '#one-container-to-rule-them-all'


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

    clearCurrentPreferences: () ->
        do @luasManager.destroy
        do @weatherManager.destroy
        console.log "Dsad"
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasStationFound: (station) =>
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasStationUnknown: (data) =>
        #@weatherManager.setCoordinates station
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasSystemDown: () =>
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasForecastSuccess: (data) =>
        @weatherManager.setCoordinates @luasManager.currentStation
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasForecastFailure: (data) =>
        data

    handleWeatherForecastSuccess: (data) =>
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleWeatherForecastFailed: (data) =>
        data


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
