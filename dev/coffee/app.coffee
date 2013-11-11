app = angular.module 'fioriApp', ['ngRoute']
app.config ['$routeProvider', (routeProvider)->
  routeProvider.when '/', {} =
    controller: 'notesCtrl'
    templateUrl: 'views/notes.html'
  routeProvider.when '/addclient', {} = 
    controller: 'ClientCtrl'
    templateUrl: 'views/client.html'
    resolve: {
      param: ()->
        {type:'add', client: null}
    }
  routeProvider.when '/clients', {} =
    controller: 'clientsCtrl'
    templateUrl: 'views/clientslist.html'
    resolve: {
      clients: (clientsService)->
        request = clientsService.all()
        request.success (data)->
          data
    }
  routeProvider.when '/clients/edit/:id', {} =
    controller: 'ClientCtrl'
    templateUrl: 'views/client.html'
    resolve: {
      param: (clientsService)->
        {type: 'edit', client: clientsService.getEdit()}
    }
]
app.factory 'clientsService', ['$http','$location', (http, location)->
  client_to_edit = {}
  return {
    create: (client)->
      console.log "create called"
      result = http.post '/api/clients/create', client
    all: ()->
      console.log "all clients"
      result = http.get '/api/clients/all'
    edit: (client)->
      client_to_edit = client
      location.path('/clients/edit/'+client._id)
    getEdit: ()->
      client_to_edit
    update: (client)->
      result = http.put '/api/clients/'+client._id, client
    delete: (id)->
      result = http.delete '/api/clients/'+id
  }
]
app.controller 'ClientCtrl', ['$scope', 'clientsService','param', (scope, clientsService, param)->
  console.log "add user ctrl"
  animation = false;
  scope.masters = ["Ким Диана", "Дмитрий Ногиев"]
  scope.active = true
  # Client class
  client = ()-> 
    savings: 0
    discount: 0
    phone: [
      {
        phonetype: "мобильный"
        number: ""
      }
      {
        phonetype: "домашний"
        number: ""
      }
    ]
    masters: []
    services: []

  if param.type is 'add'
    scope.client = new client
  else
    scope.client = param.client
    console.log scope.client
    scope.mobilephone = scope.client.phone[0].number
    scope.homephone = scope.client.phone[1].number
    date = new Date(scope.client.birthday)
    year = date.getFullYear()
    month = date.getMonth()+1
    day = date.getDate()
    if month > 9
      scope.birthday = year + '-' + month + '-' + day
    else
      scope.birthday = year + '-0' + month + '-' + day
    console.log scope.birthday

  scope.saveClient = ()->
    if param.type is 'add'
      scope.client.reg_date = new Date()
      response = clientsService.create scope.client
      response.success (data)->
        console.log data
        # scope.cleanFields()
        scope.active = false
      response.error ()->
        console.log "Error"
    else
      update()

  scope.setPhone = (index)->
    if index is 0
      scope.client.phone[index].number = scope.mobilephone
    else
      scope.client.phone[index].number = scope.homephone

  scope.setBirthday = ()->
    scope.client.birthday = new Date scope.birthday

  scope.cleanFields = ()->
    scope.client = new client
    scope.mobilephone = ""
    scope.homephone = ""
    scope.birthday = ""
  scope.addMaster = (master)->
    if master isnt undefined and master.length > 0
      if scope.client.masters.indexOf(master) is -1
        scope.client.masters.push master

  scope.removeMaster = (master)->
    scope.client.masters.splice scope.client.masters.indexOf(master), 1

  scope.getAll = ()->
    result = clientsService.all()
    result.success (data)->
      console.log data
    result.error ()->
      console.log "error"
  scope.restart = ()->
    scope.active = true
    scope.cleanFields()
  scope.formType = ()->
    if param.type is 'add'
      true
    else false
  scope.addService = ()->
    if scope.service.service_type and scope.service.material
      console.log scope.service
      if scope.client.services is undefined
        scope.client.services = []
      scope.client.services.push scope.service
      scope.service = {}
  scope.removeService = (index)->
    scope.client.services.splice(index, 1)
  update = ()->
    request = clientsService.update(scope.client)
    request.success ()->
      scope.updated = true
    request.error ()->
      console.log "Error while updating"
  scope.remove = ()->
    answer = confirm "Удалить клиента " + scope.client.surname + " " + scope.client.name
    if answer 
      request = clientsService.delete(scope.client._id)
      request.error ()->
        console.log "Error while deleting"
      scope.removed = true
  scope.hideIt = ()->
    if scope.updated or scope.removed
      true
    else false
  return
]
app.controller 'clientsCtrl', ['$scope','clients','clientsService', (scope, clients, clientsService)->
  scope.clients = clients.data
  console.log clients
  scope.showphone = 0
  scope.types = ['Мобильный телефон','Домашний телефон']
  scope.cur_type = "Мобильный телефон"
  scope.changePhone = ()->
    console.log "changing" + scope.phone
    if scope.cur_type is 'Мобильный телефон'
      scope.showphone = 0
    else
      scope.showphone = 1
  scope.editUser = (client)->
    clientsService.edit client
]
app.controller 'notesCtrl', ['$scope', (scope)->
  console.log "notes ctrl"
]



app.controller 'addNoteCtrl', ['$scope', (scope)->
  console.log "add note ctrl"
]
app.directive 'calendar', ()->
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

