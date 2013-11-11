app.directive 'clock', ($timeout)->
  return {
    restrict: "A"
    link: (scope, elem, attr)->
      updatetime = ()->
        $timeout ()->
          time = new Date()
          hours = time.getHours()
          minutes = time.getMinutes()
          if minutes > 9
            scope.time = hours + ":" + minutes
          else
            scope.time = hours + ":0" + minutes
          elem.text(scope.time)
          updatetime()
        , 1000
      updatetime()
      return
  }

