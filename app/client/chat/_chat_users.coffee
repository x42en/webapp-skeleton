class UsersChatCtrl
    users = []
    name = undefined
    constructor: ($scope, @$window, @chatSocket, @chatService) ->
        console.log '[+] Chat users controller loaded'
        @users = @chatService.users
        @name = @chatService.username
        
        # Get participants
        @chatSocket.emit 'infos', @name

        # Received user list
        @chatSocket.on 'users', (users) =>
            for user in users
                @chatService.addUser user

        # New user
        @chatSocket.on 'enter', (user) =>
            # Add user with notification
            @chatService.addUser user, true

        # New user
        @chatSocket.on 'left', (user) =>
            @chatService.delUser user

        # Remove user when logout...
        $scope.$on '$locationChangeStart', (evt, next, current) =>
            if next.match "\/login"
                @chatSocket.emit 'leave', @name
                @chatService.logout()
                @chatSocket.disconnect()

        # Remove user when page reload
        $scope.$on '$destroy', () =>
            @chatSocket.emit 'leave', @name
            @chatService.logout()
            @chatSocket.disconnect()

angular.module('webapp').controller 'UsersChatCtrl', UsersChatCtrl