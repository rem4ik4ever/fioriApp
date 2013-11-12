app = angular.module 'fioriApp', ['ngRoute']
app.config ['$routeProvider', (routeProvider)->
  
  #
  # Routes for notes
  #

  routeProvider.when '/', {} =
    controller: 'notesCtrl'
    templateUrl: 'views/notes.html'

  routeProvider.when '/addnote', {} =
    controller: 'NoteCtrl'
    templateUrl: 'views/note.html'

  routeProvider.when '/note/edit/:id', {} =
    controller: 'NoteCtrl'
    templateUrl: 'views/note.html'
  
  #
  # Routes for clients
  #

  routeProvider.when '/addclient', {} = 
    controller: 'ClientCtrl'
    templateUrl: 'views/client.html'
    resolve: {
      param: ()->
        {type :'add', client : null}
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
        {type : 'edit', client : clientsService.getEdit()}
    }
  
  #
  # Routes for masters
  #

  routeProvider.when '/addmaster', {} =
    controller: 'MasterCtrl'
    templateUrl: 'views/master.html'
    resolve:{
      param: ()->
        {type : 'add', master: null}
    }
  routeProvider.when '/masters/edit/:id', {} =
    controller: 'MasterCtrl'
    templateUrl: 'views/master.html'
    resolve: {
      param: (mastersService)->
        {type : 'edit', master : mastersService.getEdit()}
    }
  routeProvider.when '/masters', {} =
    controller: 'mastersCtrl'
    templateUrl: 'views/masterslist.html'
    resolve: {
      masters: (mastersService)->
        request = mastersService.all()
        request.success (data)->
          data
    }
]
app.factory 'clientsService', ['$http','$location', (http, location)->
  client_to_edit = {}
  return {
    create: (client)->
      result = http.post '/api/clients', client
    all: ()->
      result = http.get '/api/clients'
    edit: (client)->
      client_to_edit = client
      location.path('/clients/edit/'+client._id)
    getEdit: ()->
      client_to_edit
    update: (client)->
      result = http.put '/api/clients/'+client._id, client
    delete: (id)->
      result = http.delete '/api/clients/'+id
    find: (param)->
      result = http.post '/api/clients/find', param
  }
]
app.factory 'DateService', [()->
  noteDay = new Date
  return {
    getDate: ()->
      noteDay
    setDate: (date)->
      noteDay = new Date date
  }
]
app.factory 'mastersService', ['$http','$location', (http, location)->
  master_to_edit = {}
  return {
    create: (master)->
      result = http.post '/api/masters', master
    update: (master)->
      result = http.put '/api/masters/'+master._id, master
    edit: (master)->
      master_to_edit = master
      location.path('/masters/edit/'+master._id)
    getEdit: ()->
      master_to_edit
    delete: (id)->
      result = http.delete '/api/masters/'+id
    all: ()->
      result = http.get '/api/masters'
  }
]
app.controller 'ClientCtrl', ['$scope', 'clientsService','param', (scope, clientsService, param)->
  console.log "add user ctrl"
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
app.controller 'MasterCtrl', ['$scope', 'mastersService','param', (scope, mastersService, param)->
  scope.active = true
  scope.updated = false
  scope.removed = false
  # Client class
  master = ()->
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
    spec: []

  if param.type is 'add'
    scope.master = new master
  else
    scope.master = param.master
    console.log scope.master
    scope.mobilephone = scope.master.phone[0].number
    scope.homephone = scope.master.phone[1].number
    date = new Date(scope.master.birthday)
    year = date.getFullYear()
    month = date.getMonth()+1
    day = date.getDate()
    if day < 10
      day = "0" + day
    if month < 10
      month = "0" + month
    scope.birthday = year + '-' + month + '-' + day
    hire = new Date(scope.master.hiredate)
    year = hire.getFullYear()
    month = hire.getMonth()+1
    day = hire.getDate()
    if day < 10
      day = "0" + day
    if month < 10
      month = "0" + month
    scope.hiredate = year + '-' + month + '-' + day
    fire = new Date(scope.master.firedate)
    year = fire.getFullYear()
    month = fire.getMonth()+1
    day = fire.getDate()
    if day < 10
      day = "0" + day
    if month < 10
      month = "0" + month
    scope.firedate = year + '-' + month + '-' + day
    console.log scope.birthday
    console.log scope.hiredate
    console.log scope.firedate

  scope.saveMaster = ()->
    if param.type is 'add'
      scope.master.reg_date = new Date()
      response = mastersService.create scope.master
      response.success (data)->
        console.log data
        scope.active = false
      response.error ()->
        console.log "Error"
    else
      update()

  scope.setPhone = (index)->
    if index is 0
      scope.master.phone[index].number = scope.mobilephone
    else
      scope.master.phone[index].number = scope.homephone

  scope.setBirthday = ()->
    scope.master.birthday = new Date scope.birthday

  scope.cleanFields = ()->
    scope.master = new master
    scope.mobilephone = ""
    scope.homephone   = ""
    scope.birthday    = ""
    scope.hiredate    = ""
    scope.firedate    = ""

  scope.getAll = ()->
    result = mastersService.all()
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

  update = ()->
    request = mastersService.update(scope.master)
    request.success ()->
      scope.updated = true
    request.error ()->
      console.log "Error while updating"
  scope.remove = ()->
    answer = confirm "Удалить мастера " + scope.master.surname + " " + scope.master.name
    if answer 
      request = mastersService.delete(scope.master._id)
      request.error ()->
        console.log "Error while deleting"
      scope.removed = true

  scope.hideIt = ()->
    if scope.updated or scope.removed
      true
    else false

  scope.setHiredate = ()->
    scope.master.hiredate = new Date scope.hiredate

  scope.setFiredate = ()->
    scope.master.firedate = new Date scope.firedate
  scope.addSpec = ()->
    if scope.master.spec.indexOf(scope.spec) is -1
      scope.master.spec.push scope.spec
      scope.spec = ""
  scope.removeSpec = (index)->
    scope.master.spec.splice index, 1
  return
]
app.controller 'mastersCtrl', ['$scope','masters','mastersService', (scope, masters, mastersService)->
  scope.masters = masters.data
  console.log masters
  scope.showphone = 0
  scope.types = ['Мобильный телефон','Домашний телефон']
  scope.cur_type = "Мобильный телефон"
  scope.changePhone = ()->
    console.log "changing" + scope.phone
    if scope.cur_type is 'Мобильный телефон'
      scope.showphone = 0
    else
      scope.showphone = 1
  scope.editUser = (master)->
    mastersService.edit master
]
app.controller 'NoteCtrl', ['$scope','DateService','clientsService' , (scope, DateService, clientsService)->
  console.log "note ctrl"
  months = ["Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря"]
  scope.noteDate = ()->
    date = DateService.getDate()
    year = date.getFullYear()
    month = date.getMonth()
    if month < 10
      month = "0" + month
    day = date.getDate()
    if day < 10
      day = "0" + day
    day + " " + months[month] + " " + year + " года"
  scope.tryFind = ()->
    part = scope.client_name.split(" ")
    if part.length is 1
      param = { surname : part[0] }
    else if part.length is 2
      param = {surname : part[0] , name : part[1]}
    request = clientsService.find(param)
    request.success (data)->
      scope.clientsFound = data

  return
]
app.directive 'calendar', ['DateService',(DateService)->
  {
    restrict : "EA"
    template : '<div id="datepicker"></div>'
    link : (scope)->
      selected_date = ""
      $( "#datepicker" ).datepicker({
        inline: true
        showOtherMonths: true
        dateFormat: 'yy-mm-dd'
        minDate: new Date()
        maxDate: '+1y'
        dayNamesMin: [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс" ]
        monthNames: [ "Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь" ]
        onSelect: (date, obj)->
          # selected_date =  new Date(date)
          DateService.setDate date
          # console.log selected_date
          console.log DateService.getDate()
      })
  }
]
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

