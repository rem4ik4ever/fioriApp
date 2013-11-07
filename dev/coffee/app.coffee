app = angular.module 'fioriApp', ['ngRoute']

app.config ['$routeProvider', (routeProvider)->
  routeProvider.when '/', {} =
    controller: 'mainCtrl'
    templateUrl: 'views/main.html'
]


app.controller 'mainCtrl', ['$scope', (scope)->
  console.log "should work fine"
]


directives = {}

directives.calendar = ()->
  {
    restrict : "EA"
    template : '<div id="datepicker"></div>'
    link : (scope)->
      $( "#datepicker" ).datepicker({
        inline: true
        showOtherMonths: true
        dateFormat: 'yy-mm-dd'
        minDate: new Date()
        maxDate: '+1y'
        dayNamesMin: [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс" ]
        monthNames: [ "Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь" ]
        onSelect: (date, obj)->
          console.log date
          testdate = new Date(date)
          console.log testdate
      })
  }



app.directive directives