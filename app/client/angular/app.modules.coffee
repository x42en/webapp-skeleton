angular = require 'angular'
# <%Start requires %>
require 'angular-ui-router'
require 'angular-touch'
require 'angular-animate'
require 'angular-tooltips'
require 'angular-dnd-module'
# <%End requires %>

underscore = angular.module('underscore', [])
underscore.service '_', [ '$window', ($window) -> 
    _ = 
        getInstance: -> $window._
    _.getInstance()

    return _
]

angular
    .module('webapp', [
        # <%Start modules %>
        'underscore',
        'ui.router',
        'ngTouch',
        'ngAnimate',
        'dnd',
        '720kb.tooltips'
        # <%End modules%>
    ])