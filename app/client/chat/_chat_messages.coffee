class MessagesChatCtrl
    constructor: (@chatSocket, @chatService) ->
        console.log '[+] Chat messages controller loaded'
        @messages = @chatService.getMessages()

        # Receive new message
        @chatSocket.on 'message', (infos) =>
            @chatService.addMessage infos
            
        # New message from system
        @chatSocket.on 'system', (infos) =>
            @chatService.addMessage infos

    getClass: (css) ->
        if css is @chatService.username
            return 'myself'
        else if css is 'system'
            return 'system'
        else
            return 'other'
            
angular.module('webapp').controller 'MessagesChatCtrl', MessagesChatCtrl