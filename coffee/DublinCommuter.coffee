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

        do @cleanupAfterPreviousVersions

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

    run: () ->
        do @luasManager.populate
        do @weatherManager.populate

    clearCurrentPreferences: () ->
        do @luasManager.destroy
        do @weatherManager.destroy
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasStationFound: (station) =>
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasStationUnknown: (data) =>
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasSystemDown: () =>
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasForecastSuccess: (data) =>
        @weatherManager.cacheWeatherDataForThisStation @luasManager.currentStation.key
        @weatherManager.setCoordinates @luasManager.currentStation
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleLuasForecastFailure: (data) =>
        data

    handleWeatherForecastSuccess: (data) =>
        @emitEvent DublinCommuter.STATUS_CHANGE_EVENT, [@]

    handleWeatherForecastFailed: (data) =>
        data

    cleanupAfterPreviousVersions: () ->
        @remove 'forecast-data'

