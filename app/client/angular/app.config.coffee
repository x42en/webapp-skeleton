require './app.routes'

angular.module('webapp')
    .run ($rootScope, $state, $location, Auth) ->
        $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState) ->
            shouldLogin = toState.data isnt undefined and toState.data.requireLogin and not Auth.isLoggedIn
          
            if shouldLogin
                $state.go('login')
                event.preventDefault()
                return

            if Auth.isLoggedIn
                shouldGoToMain = fromState.name is "" and toState.name

                if shouldGoToMain
                    $state.go(toState.name)
                    event.preventDefault()

                return