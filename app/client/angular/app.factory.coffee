angular.module('webapp')
    .factory 'Auth', () ->
        return { isLoggedIn : false}

    .factory 'tooltipsConfProvider', (tooltipsConfProvider) ->
        tooltipsConfProvider.configure
            'smart':true
            'speed': 'slow'
            'tooltipTemplateUrlCache': true
        