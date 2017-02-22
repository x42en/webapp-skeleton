class LoginCtrl
    constructor: (@$state, @chatSocket, @chatService) ->
        console.log "[+] Login controller loaded"
        @username = undefined
        @type = 'error'
        @message = ''

        # Authentication is successful
        @chatSocket.on 'join', (name) =>
            @chatService.login name
            @$state.go 'chat'
            
        # Got an error
        @chatSocket.on 'err', (@message) =>
            console.error "[!] Error: #{@message}"
    
    getIcon: ->
        if @type is 'success'
            return 'fa-check-circle'
        else if @type is 'notification'
            return 'fa-info-circle'
        else if @type is 'warning'
            return 'fa-exclamation-circle'
        else
            return 'fa-warning'

    # Try to authenticate
    auth: () ->
        @chatSocket.emit 'auth', @username

angular.module('webapp').controller 'LoginCtrl', LoginCtrl