io   = require 'socket.io-client'
PORT = 8081

class SocketClient
  constructor: ($rootScope, host='localhost', port=8000, service='/',ssl=false) ->
    safeApply = (scope, fn) ->
      if scope.$$phase
        fn()
      else
        scope.$apply(fn)

    socket = io.connect "#{host}:#{port}#{service}", { reconnectionDelay: 2000, forceNew: true }
    return {
      on: (eventName, callback) ->
        socket.on eventName, ->
          args = arguments
          safeApply($rootScope, () ->
            callback.apply socket, args
          )
      emit: (eventName, data, callback) ->
        socket.emit eventName, data, ->
          args = arguments
          safeApply($rootScope, () ->
            if callback
              callback.apply socket, args
          )

      disconnect: () ->
        disconnecting = true
        socket.disconnect()
      
      socket: socket
    }

class DevSocket extends SocketClient
  constructor: ($rootScope, $location) ->
    location = $location.protocol() + "://" + $location.host()
    return super($rootScope, host=location, port=PORT)

class ChatSocket extends SocketClient
  constructor: ($rootScope, $location) ->
    location = $location.protocol() + "://" + $location.host()
    return super($rootScope, host=location, port=8000, service='/chat')

class ChatService
  constructor: (@Auth) ->
    @messages = []
    @username = ''
    @users = []
  login: (@username) ->
    @Auth.isLoggedIn = true
  addUser: (user, notif=false) ->
    if user not in @users
      @users.push user
      if notif
        @messages.push { 'author': 'system', 'msg': "#{user} entered the room..." }

  delUser: (user) ->
    if user in @users
      @users.splice @users.indexOf(user), 1
      @messages.push { 'author': 'system', 'msg': "#{user} left the room..." }

  getMessages: () -> @messages
  addMessage: (msg) ->
    @messages.push msg
  logout: () ->
    @Auth.isLoggedIn = false
    @username = ''
    @users = []
    @messages = []

angular.module('webapp')
  .service 'devSocket', DevSocket
  .service 'chatSocket', ChatSocket
  .service 'chatService', ChatService
