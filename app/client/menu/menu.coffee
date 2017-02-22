class MenuCtrl
    constructor: (@$state, @chatSocket, @chatService) ->
        console.log '[+] Menu controller loaded'
        
    logout: () ->
        @chatSocket.emit 'leave', @chatService.username
        @chatService.logout()
        @$state.go 'login'

angular.module('webapp').controller 'MenuCtrl', MenuCtrl