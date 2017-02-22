# Mobil event to implement...
# endTypes = 'touchend touchcancel mouseup mouseleave'
# moveTypes = 'touchmove mousemove'
# startTypes = 'touchstart mousedown'

angular.module('webapp')
  .directive 'draggable', ->
    (scope, element) ->
      # this gives us the native JS object
      el = element[0]
      
      el.draggable = true

      el.addEventListener 'dragstart', ((e) ->
        e.dataTransfer.effectAllowed = 'move'
        e.dataTransfer.setData 'Text', @id
        # e.dataTransfer.setData 'Text', "#{@id} #{@offsetLeft} #{@offsetTop}"
        @classList.add 'drag'
        return false
      )
      el.addEventListener 'dragend', ((e) ->
        @classList.remove 'drag'
        return false
      )

  .directive 'droppable', ->
    scope:
      drop: '&'
      bin: '='
    
    link: (scope, element) ->
      # again we need the native object
      el = element[0]
      
      el.addEventListener 'dragover', ((e) ->
        e.dataTransfer.dropEffect = 'move'
        # allows us to drop
        if e.preventDefault
          e.preventDefault()
        @classList.add 'over'
        return false
      )
      
      el.addEventListener 'dragenter', ((e) ->
        @classList.add 'over'
        return false
      )
      
      el.addEventListener 'dragleave', ((e) ->
        @classList.remove 'over'
        return false
      )
      
      el.addEventListener 'drop', ((e) ->
        # Stops some browsers from redirecting.
        if e.stopPropagation
          e.stopPropagation()
        
        @classList.remove 'over'
        binId = @id
        item = document.getElementById(e.dataTransfer.getData('Text'))
        console.log item
        @appendChild item
        # call the passed drop function
        scope.$apply (scope) ->
          fn = scope.drop()
          unless typeof fn is 'undefined'
            fn item.id, binId
          return
        return false
      )

  