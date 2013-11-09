app = angular.module 'fioriApp', ['ngRoute']
app.config ['$routeProvider', (routeProvider)->
  routeProvider.when '/', {} =
    controller: 'notesCtrl'
    templateUrl: 'views/notes.html'
  routeProvider.when '/addclient', {} = 
    controller: 'addUserCtrl'
    templateUrl: 'views/newclient.html'
]
app.controller 'addUserCtrl', ['$scope', (scope)->
  console.log "add user ctrl"
  animation = false;
  scope.masters = ["Ким Диана", "Дмитрий Ногиев"]
  scope.client = 
    savings: 0
    discount: 0
    phone: [
      {
        type: "мобильный"
        number: ""
      }
      {
        type: "домашний"
        number: ""
      }
    ]
  scope.saveClient = ()->
    console.log "Saving user:"
    scope.client.reg_date = new Date()
    console.log scope.client
  scope.setPhone = (index)->
    if index is 0
      scope.client.phone[index].number = scope.mobilephone
    else
      scope.client.phone[index].number = scope.homephone
  scope.setBirthday = ()->
    scope.client.birthday = new Date scope.birthday
  scope.setMaster = ()->
    scope.client.master = scope.clientmaster
]
app.controller 'notesCtrl', ['$scope', (scope)->
  console.log "notes ctrl"
]



app.controller 'addNoteCtrl', ['$scope', (scope)->
  console.log "add note ctrl"
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