class DevCtrl
    
    states = []
    controllers = []
    views = {}
    show = false
    message = ''
    type = 'error'
    infos = undefined
    name = undefined
    cname = undefined
    calias = undefined
    salias = undefined
    slug = undefined
    state = undefined
    view = undefined
    
    constructor: ($scope, @devSocket, @$timeout, _) ->
        console.log "[+] Dev controller loaded !"
        @authentified = false
        @controller = false

        $scope.$on '$destroy', () =>
            @devSocket.disconnect()
        
        # Retrieve infos on start
        @devSocket.emit 'infos'

        @devSocket.on 'states', (infos) =>
            @states = infos.states
            @controllers = infos.controllers
            @views = infos.views
        @devSocket.on 'refresh', =>
            location.reload()
        @devSocket.on 'success', (@message) =>
            @type = 'success'
            console.log "[+] Dev: #{@message}"
            # Only show success messages for 3sec
            @$timeout( () =>
                @message = ''
            , 3000)
        @devSocket.on 'notification', (@message) =>
            @type = 'notification'
            console.info "[+] Dev notification: #{@message}"
        @devSocket.on 'warning', (@message) =>
            @type = 'warning'
            console.warn "[!] Dev warning: #{@message}"
        @devSocket.on 'err', (@message) =>
            @type = 'error'
            console.error "[!] Dev error: #{@message}"
        @devSocket.on 'disconnect', =>
            @message = 'server disconnected...'
            @type = 'error'
            console.log "[!] #{@message}"

    showController: () ->
        return (@infos in ['page', 'view', 'component'])

    setType: (@infos) ->
        @controller = if @infos in ['controller','page','view','component'] then true else false

    setName: () ->
        @slug = "/#{@name.toLowerCase()}"
        if @name.length > 1
            @cname = @name[0].toUpperCase() + @name.substring(1).toLowerCase() + 'Ctrl'
        else
            @cname = @name.toUpperCase() + 'Ctrl'
        @calias = @name.toLowerCase()

    getMessage: () -> @message
    getIcon: ->
        if @type is 'success'
            return 'fa-check-circle'
        else if @type is 'notification'
            return 'fa-info-circle'
        else if @type is 'warning'
            return 'fa-exclamation-circle'
        else
            return 'fa-warning'

    create: ->
        unless @name
            @type = 'error'
            @message = "Define a #{@infos} name."
            return false

        if @name.length < 2
            @type = 'error'
            @message = "Name must be greater than 2 chars."
            return false
        
        # Avoid dir traversal
        unless /^[a-z0-9_]+$/.test(@name.toLowerCase())
            @type = 'error'
            @message = "#{@infos} name is not valid."
            return false

        if @name in ['angular','styles','assets','class','function','var']
            @type = 'error'
            @message = "#{@infos} name is forbidden."
            return false

        if (@infos is 'view') and !@state
            @type = 'error'
            @message = "Please select a parent state."
            return false

        # Reset error message
        @message = undefined

        options = {}
        options.name = @name[0].toUpperCase() + @name.substring(1).toLowerCase()
        # If we build server side
        if @infos is 'service'
            options.alias = if @salias then @salias else options.name.toLowerCase()
        # On client side
        else
            options.authentified = @authentified.toString()
            options.state = if @state then @state.toLowerCase() else ''
            
            if @controller
                options.controller = if @cname then @cname else options.name
                options.alias = if @calias then @calias else options.controller.toLowerCase()
            

            options.slug = if @slug then @slug else @name

        @devSocket.emit @infos, options
        
    success: (elt, name) ->
        @type = 'success'
        @message = "#{elt} '#{name}' created..."

angular.module('webapp').controller 'DevCtrl', DevCtrl