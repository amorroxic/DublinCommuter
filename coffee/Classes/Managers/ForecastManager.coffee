class ForecastManager extends LocalStorage

    @location           = null
    @coordinates        = null
    @forecast           = null
    @_hasForecast       = null

    @weatherAPI         = null
    @apiKey             = null

    @FORECAST_FAILED   = "forecast_failed"
    @FORECAST_SUCCESS  = "forecast_success"

    # expecting an input like this
    # params = {
    #   id: location id - used for caching purposes
    #   latitude: GPS latitude
    #   longitude: GPS longitude
    #   name: location name
    # }
    constructor: (params) ->

        @id                 = 'forecast-data'
        if params? and params.latitude? and params.longitude?
            @coordinates        =
                latitude:   params.latitude
                longitude:  params.longitude
                initialized: yes

        @_hasForecast       = no
        @forecast           = {}
        @weatherAPI         = BaseFunctionality.API_ENDPOINT + '/weather/for'

    cacheWeatherDataForThisStation: (cacheKey) ->
        @id = 'forecast-data' + '-' + cacheKey

    populate: () ->
        isInitialized       = do @cacheLoad
        if isInitialized
            @emitEvent ForecastManager.FORECAST_SUCCESS, [@forecast]

    # trying to load forecast from cache and validate it
    cacheLoad: () ->
        @_hasForecast = no
        if @coordinates and @coordinates.initialized?
            data = @retrieve @id
            if data?
                if data.forecast? and data.forecast.current?
                    @forecast = data.forecast
                    validForecast = do @hasValidForecast
                    if validForecast
                        @_hasForecast = yes
        @_hasForecast

    setCoordinates: (params) ->
        if params? and params.latitude? and params.longitude?
            @coordinates =
                latitude: params.latitude
                longitude: params.longitude
                initialized: yes
            isInitialized = do @cacheLoad
            if isInitialized
                @emitEvent ForecastManager.FORECAST_SUCCESS, [@forecast]
            else
                do @refreshForecast

    refreshForecast: () ->
        if @coordinates and @coordinates.initialized?
            endPoint = @weatherAPI + '/' + @coordinates.latitude + ',' + @coordinates.longitude
            @log endPoint
            request = new Ajax endPoint
            request.addListener Ajax.LOAD_SUCCESS, @forecastSuccess
            request.addListener Ajax.LOAD_FAILED, @forecastFailure
            params = {}
            request.perform params, 'json'

    forecastSuccess: (transport) =>
        if transport.result['status']
            @populateForecast transport.result.data
            @_hasForecast = yes
            do @cacheSave
            @emitEvent ForecastManager.FORECAST_SUCCESS, [@forecast]
        else
            @emitEvent ForecastManager.FORECAST_FAILED, [@]

    forecastFailure: (data) =>
        @emitEvent ForecastManager.FORECAST_FAILED, [@]

    populateForecast: (data) ->

        currentTime = data.time
        currentDate = new Date currentTime*1000

        currentForecast = {
            'key'           : do currentDate.yyyymmddh,
            'date'          : do currentDate.yyyymmdd,
            'timestamp'     : data.time,
            'summary'       : data.summary,
            'icon'          : data.icon,
            'temp'          : parseInt(data.temp)
        }

        @forecast.current       = currentForecast
        @forecast.coordinates   = @coordinates
        @forecast.days          = {}

        #for dayforecast in data.weather

            #newForecast = {
                #'date'          : dayforecast.date,
                #'precip_mm'     : dayforecast.precipMM,
                #'temp_min'      : {
                                    #'f' :   dayforecast.tempMinF,
                                    #'c' :   dayforecast.tempMinC
                                #},
                #'temp_max'      : {
                                    #'f' :   dayforecast.tempMaxF,
                                    #'c' :   dayforecast.tempMaxC
                                #},
                #'description'   : dayforecast.weatherDesc[0].value,
                #'icon'          : dayforecast.weatherIconUrl[0].value,
                #'wind'          : {
                                    #'m'         : dayforecast.windspeedMiles,
                                    #'km'        : dayforecast.windspeedKmph,
                                    #'direction' : dayforecast.winddir16Point
                                #}
            #}
            #@forecast.days[dayforecast.date] = newForecast
            #newForecast = null

    hasValidForecast: () ->
        status = no
        currentDateKey = new Date
        currentDateKey = do currentDateKey.yyyymmddh
        if @forecast and @forecast['current']
            if @forecast.current.key is currentDateKey
                status = yes
        @log status
        status

    getForecastOverview: () ->
        contentText     = @location
        validForecast   = do @hasValidForecast
        if validForecast
            contentText =  @location + ' at ' + @forecast.current.time + ': '+@forecast.current.temp.c + '&deg;C, ' + @forecast.current.description
        contentText

    cacheSave: () ->
        saved = no
        data =
            forecast: @forecast
        @store @id, data
        saved = yes
        saved

    destroy: () ->
        # i think it may be actually good not to erase forecast cache.
        #@remove @id
        @_hasForecast   = no
        @coordinates    = no
        @forecast       = {}

    celsius: (f) ->
        c = null
        if f?
            c = (f-32)*5/9
            c = Math.round(c)
        @log c
        c

    hasForecast: () ->
        @_hasForecast


