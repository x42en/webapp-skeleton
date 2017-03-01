angular.module('webapp').config (@$stateProvider, @$urlRouterProvider, @$locationProvider) ->
    
    @$urlRouterProvider.otherwise "/"
    @$locationProvider.html5Mode true

    @$stateProvider
        .state 'init',
            url: '/'
            data: { requireLogin: false }
            views:
                '':
                    templateUrl: 'pages/_home.php'
                    controller: 'HomeCtrl'
                    controllerAs: 'home'
                # <%End init views%>

        .state 'outoforder',
            data: { requireLogin: false }
            views:
                '':
                    templateUrl: 'pages/_outoforder.php'
                # <%End outoforder views%>
        
        .state 'login',
            url: '/login'
            data: { requireLogin: false }
            views:
                '':
                    templateUrl: 'pages/_login.php'
                    controller: 'LoginCtrl'
                    controllerAs: 'login'
                # <%End login views%>

        .state 'about',
            url: '/about'
            data: { requireLogin: false }
            views:
                '':
                    templateUrl: 'pages/_about.php'
                # <%End about views%>

        .state 'chat',
            url: '/chat'
            data: { requireLogin: true }
            views:
                '':
                    templateUrl: 'pages/_chat.php'
                    controller: 'ChatCtrl'
                    controllerAs: 'chat'
                'users@chat':
                    templateUrl: 'pages/_chat_users.php'
                    controller: 'UsersChatCtrl'
                    controllerAs: 'users'
                'messages@chat':
                    templateUrl: 'pages/_chat_messages.php'
                    controller: 'MessagesChatCtrl'
                    controllerAs: 'messages'
                # <%End chat views%>
        
        # <%End routes%>