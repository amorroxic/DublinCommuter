class ForecastManager extends LocalStorage

    @location           = null
    @coordinates        = null
    @forecast           = null
    @hasForecast        = null

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
        @coordinates        =
            latitude:   params.latitude
            longitude:  params.longitude

        @hasForecast        = no
        @forecast           = {}
        @weatherAPI         = 'http://api.dublin.io/api/v1/weather/for'

        @log "[Forecast] new"

    populate: () ->
        @log "[Forecast] populate"
        isInitialized       = do @cacheLoad
        if isInitialized
            @emitEvent ForecastManager.FORECAST_SUCCESS, [@forecast]
        @log "[Forecast] populate result: " + isInitialized


    # trying to load forecast from cache and validate it
    cacheLoad: () ->
        @log "[Forecast] cacheLoad " + @id
        @hasForecast = no
        data = @retrieve @id
        if data?
            if data.forecast? and data.forecast.current?
                @forecast = data.forecast
                validForecast = do @hasValidForecast
                if validForecast
                    @hasForecast = yes
                else
                    do @refreshForecast
        else
            do @refreshForecast

        @log "[Forecast] cacheLoad result: " + @hasForecast
        @hasForecast


    refreshForecast: () ->
        @log "[Forecast] refreshForecast"
        endPoint = @weatherAPI + '/' + @coordinates.latitude + ',' + @coordinates.longitude
        @log endPoint
        request = new Ajax endPoint
        request.addListener Ajax.LOAD_SUCCESS, @forecastSuccess
        request.addListener Ajax.LOAD_FAILED, @forecastFailure
        params = {}
        request.perform params, 'json'

    forecastSuccess: (transport) =>
        @log "[Forecast] forecastSuccess"
        if transport.result['status']
            @populateForecast transport.result.data
            @hasForecast = yes
            do @cacheSave
            @emitEvent ForecastManager.FORECAST_SUCCESS, [@forecast]
        else
            @emitEvent ForecastManager.FORECAST_FAILED, [@]

    forecastFailure: (data) =>
        @log "[Forecast] forecastFailure"
        @emitEvent ForecastManager.FORECAST_FAILED, [@]

    populateForecast: (data) ->
        @log "[Forecast] populateForecast"

        currentTime = data.time
        currentDate = new Date currentTime*1000

        currentForecast = {
            'key'           : do currentDate.yyyymmddh,
            'date'          : do currentDate.yyyymmdd,
            'timestamp'     : data.time,
            'summary'       : data.summary,
            'icon'          : data.icon,
            'temp'          : data.temp
        }

        @forecast.current   = currentForecast
        @forecast.days      = {}

        @log "[Forecast] populateForecast result: " + @forecast

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
        @log "[Forecast] hasValidForecast"
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
        @log "[Forecast] cacheSave " + @id
        saved = no
        data =
            forecast: @forecast
        @store @id, data
        saved = yes
        saved

    destroy: () ->
        @log "[Forecast] destroy " + @id
        @remove @id
        @hasForecast = no
        @forecast = {}

    celsius: (f) ->
        @log "[Forecast] celsius from: " + f
        c = null
        if f?
            c = (f-32)*5/9
            c = Math.round(c)
        @log c
        c

