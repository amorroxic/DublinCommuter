class BaseFunctionality extends EventEmitter

    @API_ENDPOINT = 'http://api.dublin.io/api/v2'

    settings =
        debug: false

    log: (msg) ->
        console?.log msg if settings.debug

    delay: (time, fn, args...) ->
        setTimeout fn, time, args...

    forever: (time, fn, args...) ->
        setInterval fn, time, args...


