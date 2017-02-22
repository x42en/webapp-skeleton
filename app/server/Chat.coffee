module.exports = class Chat
    constructor: () ->
        @names = []

    auth: (name, socket) ->
        unless /^[a-z0-9_]+$/.test name
            socket.emit 'err', 'Invalid username.'
            return

        if name in @names
            socket.emit 'err', 'This user already exists.'
            return

        console.log "[+] #{name} user enter the chat room !"
        @names.push name
        socket.emit 'join', name
        socket.broadcast.emit 'enter', name

    _isAuth: (name) ->
        return (name in @names)

    infos: (name, socket) ->
        if @_isAuth(name)
            socket.emit 'users', @names
        else
            socket.emit 'err', 'You are not authenticated !'

    msg: (infos, socket) ->
        console.log "[+] #{infos.author} user send -> #{infos.msg}"
        if @_isAuth(infos.author)
            
            socket.broadcast.emit 'message', infos
        else
            socket.emit 'err', 'You are not authenticated !'

    leave: (name, socket) ->
        if name in @names
            console.log "[+] #{name} user leave the chat room !"
            # Remove this user
            @names.splice @names.indexOf(name), 1
            # Notify everyone
            socket.broadcast.emit 'left', name
            socket.broadcast.emit 'system', { 'author': 'system', 'msg': "#{name} left the room..." }
