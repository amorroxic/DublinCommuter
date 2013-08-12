class Timer extends BaseFunctionality

    @TICK               = "timer_tick"
    @currentDate        = no

    constructor: (timeout) ->
        if not isFinite(timeout)
            timeout = 1000
        @currentDate = new Date
        @forever timeout, =>
            @emitEvent Timer.TICK, [@]
            @currentDate = new Date

    isNewMinute: () ->
        @currentDate.getSeconds() == 0

