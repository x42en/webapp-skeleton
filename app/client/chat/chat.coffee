class ChatCtrl
    constructor: (@chatSocket, @chatService) ->
        console.log '[+] Chat controller loaded'
        @name = @chatService.username
        @message = ''
        @msg = ''

        # Receive new message
        @chatSocket.on 'err', (message) =>
            @message = message
            console.error "[!] #{@message}"

    # Send a message
    send: () ->
        # Build object
        infos = {}
        infos.author = @name
        infos.msg = @msg
        # Store message infos
        @chatService.messages.push infos
        @chatSocket.emit 'msg', infos
        # Reset message input
        @msg = ''

angular.module('webapp').controller 'ChatCtrl', ChatCtrl