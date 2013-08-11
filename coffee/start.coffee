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
    dublinCommuter.addListener DublinCommuter.LUAS_STATUS, (dublinCommuterInstance) ->
        safeApply $rootScope, ->
        #$rootScope.$apply ->
            deferred.resolve dublinCommuterInstance
            #deferred.reject 'some_reason'

    factoryObject = {}
    factoryObject.getApplicationPromise = ()->
        deferred.promise

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

app.controller "DublinCommuterController", ($scope, dublinLuasFactory) ->

    dublinCommuterPromise = do dublinLuasFactory.getApplicationPromise
    dublinCommuterPromise.then (dublinCommuter)->
            $scope.dublinCommuter = dublinCommuter
    , (status) ->
        console.log 'promise rejected because: ' + status

    $scope.dublinCommuter = no

