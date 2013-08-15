class LuasManager extends LocalStorage

    @luasStations       = null

    @id                 = null
    @coordinates        = null
    @currentStation     = null
    @forecastData       = null

    @_hasLuas           = no
    @_hasForecast       = no

    @STATION_FOUND      = "luas_station_found"
    @STATION_UNKNOWN    = "luas_station_unknown"
    @FORECAST_SUCCESS   = "luas_station_forecast"
    @FORECAST_FAILED    = "luas_station_forecast_unavailable"
    @SYSTEM_DOWN        = "luas_system_down"

    constructor: (params) ->
        @id                 = 'luas-data'
        @_hasForecast       = no
        @_hasLuas           = no
        if params? and params.latitude? and params.longitude?
            @coordinates        =
                latitude:   params.latitude
                longitude:  params.longitude
        else
            @coordinates    = no

        @luasAPI            = BaseFunctionality.API_ENDPOINT + "/luas-forecast/for/"

        @luasStations = [
          key: "st-stephens-green"
          name: "St. Stephen's Green"
          latitude: 53.339605
          longitude: -6.26128
        ,
          key: "harcourt"
          name: "Harcourt"
          latitude: 53.333551
          longitude: -6.2629
        ,
          key: "charlemont"
          name: "Charlemont"
          latitude: 53.330681
          longitude: -6.2588
        ,
          key: "ranelagh"
          name: "Ranelagh"
          latitude: 53.326266
          longitude: -6.25636
        ,
          key: "beechwood"
          name: "Beechwood"
          latitude: 53.320845
          longitude: -6.25486
        ,
          key: "cowper"
          name: "Cowper"
          latitude: 53.309839
          longitude: -6.25174
        ,
          key: "milltown"
          name: "Milltown"
          latitude: 53.309839
          longitude: -6.25174
        ,
          key: "windy-arbour"
          name: "Windy Arbour"
          latitude: 53.293798
          longitude: -6.24699
        ,
          key: "dundrum"
          name: "Dundrum"
          latitude: 53.293798
          longitude: -6.24699
        ,
          key: "balally"
          name: "Balally"
          latitude: 53.286102
          longitude: -6.23679
        ,
          key: "kilmacud"
          name: "Kilmacud"
          latitude: 53.282997
          longitude: -6.223969
        ,
          key: "stillorgan"
          name: "Stillorgan"
          latitude: 53.279347
          longitude: -6.210156
        ,
          key: "sandyford"
          name: "Sandyford"
          latitude: 53.277596
          longitude: -6.204679
        ,
          key: "central-park"
          name: "Central Park"
          latitude: 53.270321
          longitude: -6.203531
        ,
          key: "glencairn"
          name: "Glencairn"
          latitude: 53.266313
          longitude: -6.210161
        ,
          key: "the-gallops"
          name: "The Gallops"
          latitude: 53.262109
          longitude: -6.208775
        ,
          key: "leopardstown-valley"
          name: "Leopardstown Valley"
          latitude: 53.257996
          longitude: -6.197485
        ,
          key: "ballyogan-wood"
          name: "Ballyogan Wood"
          latitude: 53.255901
          longitude: -6.1882
        ,
          key: "carrickmines"
          name: "Carrickmines"
          latitude: 53.254518
          longitude: -6.172085
        ,
          key: "laughanstown"
          name: "Laughanstown"
          latitude: 53.250955
          longitude: -6.156045
        ,
          key: "cherrywood"
          name: "Cherrywood"
          latitude: 53.247832
          longitude: -6.14845
        ,
          key: "brides-glen"
          name: "Brides Glen"
          latitude: 53.24216
          longitude: -6.142961
        ,
          key: "the-point"
          name: "The Point"
          latitude: 53.34834
          longitude: -6.22962
        ,
          key: "spencer-dock"
          name: "Spencer Dock"
          latitude: 53.34882
          longitude: -6.23718
        ,
          key: "mayor-square-nci"
          name: "Mayor Square - NCI"
          latitude: 53.34933
          longitude: -6.24355
        ,
          key: "georges-dock"
          name: "George's Dock"
          latitude: 53.34961
          longitude: -6.24807
        ,
          key: "busaras"
          name: "Busaras"
          latitude: 53.35007
          longitude: -6.25144
        ,
          key: "connolly"
          name: "Connolly"
          latitude: 53.351499
          longitude: -6.24993
        ,
          key: "abbey-street"
          name: "Abbey Street"
          latitude: 53.348588
          longitude: -6.258371
        ,
          key: "jervis"
          name: "Jervis"
          latitude: 53.347669
          longitude: -6.26609
        ,
          key: "the-four-courts"
          name: "The Four Courts"
          latitude: 53.346824
          longitude: -6.27291
        ,
          key: "smithfield"
          name: "Smithfield"
          latitude: 53.347259
          longitude: -6.2786
        ,
          key: "museum"
          name: "Museum"
          latitude: 53.347842
          longitude: -6.28673
        ,
          key: "heuston"
          name: "Heuston"
          latitude: 53.346388
          longitude: -6.29223
        ,
          key: "jamess"
          name: "James's"
          latitude: 53.342033
          longitude: -6.29384
        ,
          key: "fatima"
          name: "Fatima"
          latitude: 53.33835
          longitude: -6.29277
        ,
          key: "rialto"
          name: "Rialto"
          latitude: 53.337869
          longitude: -6.2975
        ,
          key: "suir-road"
          name: "Suir Road"
          latitude: 53.33664
          longitude: -6.30733
        ,
          key: "goldenbridge"
          name: "Goldenbridge"
          latitude: 53.335857
          longitude: -6.31366
        ,
          key: "drimnagh"
          name: "Drimnagh"
          latitude: 53.335383
          longitude: -6.31833
        ,
          key: "blackhorse"
          name: "Blackhorse"
          latitude: 53.334192
          longitude: -6.32793
        ,
          key: "bluebell"
          name: "Bluebell"
          latitude: 53.3293
          longitude: -6.33396
        ,
          key: "kylemore"
          name: "Kylemore"
          latitude: 53.32649
          longitude: -6.3439
        ,
          key: "red-cow"
          name: "Red Cow"
          latitude: 53.31666
          longitude: -6.36939
        ,
          key: "kingswood"
          name: "Kingswood"
          latitude: 53.30247
          longitude: -6.36862
        ,
          key: "belgard"
          name: "Belgard"
          latitude: 53.29874
          longitude: -6.3745
        ,
          key: "cookstown"
          name: "Cookstown"
          latitude: 53.294253
          longitude: -6.38623
        ,
          key: "hospital"
          name: "Hospital"
          latitude: 53.289591
          longitude: -6.3793
        ,
          key: "tallaght"
          name: "Tallaght"
          latitude: 53.28771
          longitude: -6.37359
        ,
          key: "fettercairn"
          name: "Fettercairn"
          latitude: 53.29395
          longitude: -6.3957
        ,
          key: "cheeverstown"
          name: "Cheeverstown"
          latitude: 53.29103
          longitude: -6.4076
        ,
          key: "citywest-campus"
          name: "Citywest Campus"
          latitude: 53.28781
          longitude: -6.42022
        ,
          key: "fortunestown"
          name: "Fortunestown"
          latitude: 53.28441
          longitude: -6.42501
        ,
          key: "saggart"
          name: "Saggart"
          latitude: 53.28483
          longitude: -6.43904
        ]

    populate: () ->
        isInitialized       = do @cacheLoad
        if isInitialized
            @emitEvent LuasManager.STATION_FOUND, [@currentStation]
            do @refreshForecast
        else
            suggestions = do @buildSuggestions
            @emitEvent LuasManager.STATION_UNKNOWN, [suggestions]

    buildSuggestions: () =>
        suggestions = []
        if @coordinates? and @coordinates.latitude? and @coordinates.longitude?
            suggestions = do @sortStationsByGPSDistance
        else
            suggestions = @luasStations.slice 0
        suggestions

    sortStationsByGPSDistance: () ->
        suggestions = @luasStations.slice 0
        suggestions.sort (a,b) =>
            return @compareDistance a,b
        suggestions

    compareDistance: (a,b) ->
        distanceToA = @getDistance a
        distanceToB = @getDistance b
        retVal      = 0
        if distanceToA > distanceToB
            retVal = 1
        else
            if distanceToA < distanceToB
                retVal = -1
        retVal

    getDistance: (point) ->
        R = 6371
        lat1 = @coordinates['latitude']
        lat2 = point['latitude']
        lon1 = @coordinates['longitude']
        lon2 = point['longitude']
        dLat = do (lat2-lat1).toRadians
        dLon = do (lon2-lon1).toRadians
        lat1 = do lat1.toRadians
        lat2 = do lat2.toRadians

        a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2)
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
        d = R * c
        d

    setStation: (station) ->
        status = no
        if station? and station.latitude? and station.longitude? and station.key?
            @currentStation = station
            @coordinates =
                latitude: station.latitude
                longitude: station.longitude
            do @cacheSave
            @_hasLuas = yes
            do @refreshForecast
            status = yes
        status

    cacheLoad: () ->
        @_hasLuas = no
        if @id?
            data = @retrieve @id
            if data? and data.currentStation? and data.currentStation.key?
                validStation = @stationIsValid data.currentStation
                if validStation
                    @currentStation = validStation
                    @_hasLuas = yes
        @_hasLuas

    stationIsValid: (requestedStation) ->
        status = no
        for station in @luasStations
            if requestedStation.key is station.key
                status = station
        status

    refreshForecast: () ->
        @forecastData = null
        @_hasForecast = no
        if @currentStation?
            endPoint = @luasAPI + @currentStation.key
            request = new Ajax endPoint
            request.addListener Ajax.LOAD_SUCCESS, @forecastSuccess
            request.addListener Ajax.LOAD_FAILED, @forecastFailure
            params = {}
            request.perform params,'json'

    forecastSuccess: (transport) =>
        if transport.result.status
            @forecastData = transport.result.data
            @_hasForecast = yes
            do @cacheSave
            @emitEvent LuasManager.FORECAST_SUCCESS, [@forecastData]
        else
            @emitEvent LuasManager.FORECAST_FAILED, [@]

    forecastFailure: (data) =>
        @_hasForecast = no
        @emitEvent LuasManager.SYSTEM_DOWN, [@]

    cacheSave: () ->
        saved = no
        if @currentStation?
            data =
                currentStation:
                    key: @currentStation.key
            @store @id, data
            saved = yes
        saved

    destroy: () ->
        @remove @id
        @_hasForecast   = no
        @_hasLuas       = no
        @coordinates    = no

    hasLuas: () ->
        @_hasLuas

    hasForecast: () ->
        @_hasForecast
