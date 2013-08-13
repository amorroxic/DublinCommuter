#document.addEventListener 'DOMContentLoaded', () ->
    #a = new DublinCommuter
    #a.addListener DublinCommuter.LUAS_STATUS, (a) ->
        #console.log a
    #do a.run
#, no
'use strict'
app = angular.module('ngDublinCommuter', [] )

app.factory "dublinLuasFactory", ($q, $rootScope, safeApply) ->

    deferred = do $q.defer

    dublinCommuter = new DublinCommuter
    dublinCommuter.addListener DublinCommuter.STATUS_CHANGE_EVENT, (dublinCommuterInstance) ->
        safeApply $rootScope, ->
        #$rootScope.$apply ->
            deferred.resolve dublinCommuterInstance
            #deferred.reject 'some_reason'

    factoryObject = {}
    factoryObject.getApplicationPromise = ()->
        deferred.promise
    factoryObject.getApplication = ()->
        dublinCommuter

    do dublinCommuter.run
    factoryObject


# Depending on the nature of the activity in DublinCommuter (sync/async) $scope.$apply from the dublinLuasFactory may return an exception:
#   Error: $apply already in progress
# The following factory implements a safe $apply function. Adapted to Coffee from https://coderwall.com/p/ngisma

app.factory "safeApply", ($rootScope) ->
    factoryObject = ($scope, fn) ->
        phase = $scope.$root.$$phase
        if phase is '$apply' or phase is '$digest'
            $scope.$eval fn if fn
        else
            if fn then $scope.$apply fn else do $scope.$apply

    factoryObject

app.factory "dublinTimingFactory", ($q, $rootScope, safeApply, dublinLuasFactory) ->

    deferred = do $q.defer

    timerInstance = new Timer 1000
    timerInstance.addListener Timer.TICK, () ->
        if do timerInstance.isNewMinute then do dublinLuasFactory.getApplication().luasManager.refreshForecast
        safeApply $rootScope, ->
            deferred.resolve timerInstance

    factoryObject = {}
    factoryObject.getTimerPromise = ()->
        deferred.promise

    factoryObject


app.filter 'timeformat', () ->
    filterFunction = (input, param) ->
        returnValue = ''
        if isFinite input
            returnValue = input + (if parseInt input == 1 then ' minute' else ' minutes')
        else
            returnValue = input
        returnValue
    filterFunction

app.controller "DublinCommuterController", ($scope, dublinLuasFactory, dublinTimingFactory) ->

    dublinCommuterPromise = do dublinLuasFactory.getApplicationPromise
    dublinCommuterPromise.then (dublinCommuter)->
            $scope.dublinCommuter = dublinCommuter
    , (status) ->
        console.log 'promise rejected because: ' + status

    dublinTimerPromise = do dublinTimingFactory.getTimerPromise
    dublinTimerPromise.then (timerInstance)->
            $scope.timerInstance = timerInstance

    $scope.weatherIconClass = 'icon-forecast'
    if do dublinLuasFactory.getApplication().weatherManager.hasForecast
        $scope.weatherIconClass += ' ' + dublinLuasFactory.getApplication().weatherManager.forecast.current.icon
        console.log "scope: "+$scope.weatherIconClass

    $scope.$weatherIcon = 'partly-cloudy-night'
    $scope.dublinCommuter = no
    $scope.stationClicked = (station) ->
        dublinLuasFactory.getApplication().luasManager.setStation station

