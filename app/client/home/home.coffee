class HomeCtrl
    constructor: (@$location) ->
        console.log '[+] Home controller loaded !'
        @field = 'Field'

    method: ->
        'Method'

    methodWithParam: (param) ->
        "Param: #{param}"

    accessFieldFromMethod: ->
        "Path: #{@$location.absUrl()}"
        
angular.module('webapp').controller 'HomeCtrl', HomeCtrl