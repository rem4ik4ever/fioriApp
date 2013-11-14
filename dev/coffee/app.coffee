app = angular.module 'fioriApp', ['ngRoute','ngAnimate']
app.config ['$routeProvider', (routeProvider)->
  
  #
  # Routes for notes
  #

  routeProvider.when '/', {} =
    controller: 'notesCtrl'
    templateUrl: 'views/notes.html'
    resolve: {
      notes: (notesService, dateService)->
        today = dateService.getDate()
        today.setHours(0)
        today.setMinutes(0)
        tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000))
        params = {
          start_date: today
          end_date: tomorrow
        }
        console.log params
        request = notesService.byDate(params)
    }

  routeProvider.when '/addnote', {} =
    controller: 'NoteCtrl'
    templateUrl: 'views/note.html'
    resolve: {
      param: (mastersService)->
        request = mastersService.all()
        {type: 'add' , masters: request}

    }

  routeProvider.when '/notes/edit/:note', {} =
    controller: 'NoteCtrl'
    templateUrl: 'views/note.html'
    resolve: {
      param: ($route, notesService)->
        id = $route.current.params.note
        console.log id
        {type: 'edit', note: notesService.getEdit(id)}
    }
  
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
app.factory 'dateService', [()->
  noteDay = new Date
  noteDay.setHours 0
  noteDay.setMinutes 0
  noteDay.setSeconds 0
  noteDay.setMilliseconds 0
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
app.factory 'notesService', ['$http', '$location', (http, location)->
  note_to_edit = {}
  return{
    save: (note)->
      result = http.post '/api/notes', note
    all: ()->
      result = http.get '/api/notes'
    byDate: (params)->
      result = http.post '/api/notes/bydate', params
    masterNotes: (params)->
      result = http.post '/api/notes/bydatemaster', params
    getEdit: (id)->
      request = http.get "/api/notes/edit?q="+id
    update: (note)->
      request = http.put "/api/notes/"+note.id, note
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
app.controller 'NoteCtrl', ['$scope','dateService','clientsService','notesService' ,'param', (scope, dateService, clientsService, notesService, param)->
  editnote = {}
  scope.active = false
  scope.updated = false
  type = param.type
  console.log type
  if param.type is 'add'
    param.masters.success (data)->
      scope.masters = data

  else if param.type is 'edit'
    param.note.success (data)->
      editnote = data
      setNote()
  months = ["Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря"]
  scope.masterNotes = []
  scope.intersection = false
  scope.timeOfDate = (date)->
    res = new Date(date)
    minutes = res.getMinutes()
    if minutes < 10
      minutes = "0"+minutes
    res.getHours() + ":" + minutes
  scope.noteDate = ()->
    date = dateService.getDate()
    year = date.getFullYear()
    month = date.getMonth()
    if month < 10
      month = "0" + month
    day = date.getDate()
    if day < 10
      day = "0" + day
    day + " " + months[month] + " " + year + " года"
  
  scope.tryFind = ()->
    if scope.register_client isnt "" and scope.register_client isnt undefined
      part = scope.register_client.split(" ")
      param = {}
      if part.length is 1
        param = { name : part[0] }
      else if part.length is 2
        param = {name : part[0], surname : part[1]}
      request = clientsService.find(param)
      request.success (data)->
        scope.clientsFound = data
    else
      scope.clientsFound = []
  
  scope.setClient = (index)->
    scope.client = scope.clientsFound[index]
    scope.register_client = scope.client.name + " " + scope.client.surname
    scope.clientsFound = []
    scope.unregister_client = ""
  
  scope.setUnregClient = ()->
    scope.register_client = scope.unregister_client
    if scope.register_client isnt undefined and scope.register_client isnt ""
      part = scope.register_client.split " "
      scope.client = {name: "" , surname: ""}
      if part.length is 2
        scope.client.name = part[0]
        scope.client.surname = part[1]
      else
        scope.client.name = part[0]
    console.log "unregister user"
  
  scope.setMaster = (master)->
    scope.master = master
    scope.findmaster = scope.master.name + " " + scope.master.surname
    params = {
      start_date : dateService.getDate()
      end_date : new Date(dateService.getDate().getTime() + (24 * 60 * 60 * 1000))
      master : scope.master._id
    }
    request = notesService.masterNotes(params)
    request.success (data)->
      if param.type is 'edit'
        for note in data
          if !_.isEqual(note, editnote)
            scope.masterNotes.push note
      else 
        scope.masterNotes = data
    request.error (err)->
      console.log err
  scope.getMasterNotes = ()->
    scope.masterNotes
  clearFields = ()->
    scope.client = {}
    scope.register_client = ""
    scope.unregister_client = ""
    scope.hours = ""
    scope.minutes = ""
    scope.service = ""
    scope.master = ""
    scope.findmaster = ""
  scope.mins = (mins)->
    if mins < 10
      "0" + mins
    else
      mins
  scope.checkInter = (time)->
    noteTime = scope.timeOfDate(time)
    mins = scope.minutes
    if mins < 10
      mins = "0"+mins
    # console.log time + " " + scope.hours+":"+mins
    cur_time = scope.hours+":"+mins
    if noteTime is cur_time
      scope.intersection = true
      return "intersection"
    return ""
  scope.timeChange = ()->
    scope.intersection = false
  scope.saveNote = ()->
    if scope.intersection
      alert("Существует совпадение по времени")
      return
    note = {
      client : {}
      master : ""
      service: ""
      time : ""
    }
    
    reg_date = dateService.getDate()
    reg_date.setHours(scope.hours)
    reg_date.setMinutes(scope.minutes)
    reg_date.setSeconds(0)

    if scope.unregister_client isnt undefined and scope.unregister_client isnt ""
      note.client.name = scope.unregister_client
      note.client.id = ""
    else
      note.client.name = scope.register_client
      note.client.id = scope.client._id

    note.master = scope.master._id
    note.service = scope.service
    note.time = reg_date

    if type is 'add'
      request = notesService.save note
      request.success (data)->
        scope.active = true
      request.error (err)->
        console.log err
    else if type is 'edit'
      note.id = editnote._id
      request = notesService.update note
      request.success (data)->
        scope.updated = true
      request.error (err)->
        console.log err
  setNote = ()->
    console.log editnote
    scope.client = editnote.client
    scope.register_client = scope.client.name
    scope.master = editnote.master
    scope.setMaster(scope.master)
    scope.findmaster = scope.master.name + " " + scope.master.surname
    scope.service = editnote.service
    scope.hours = new Date(editnote.time).getHours()
    scope.minutes = new Date(editnote.time).getMinutes()
  scope.newNote = ()->
    scope.active = false
    clearFields()
  scope.formState = ()->
    if scope.active is true or scope.updated is true
      true
    false

  return
]
app.controller 'notesCtrl', ['$scope','notes','notesService','dateService', (scope, notes, notesService, dateService)->
  console.log "notes ctrl"
  scope.notes = notes.data
  console.log scope.notes
  current_date = dateService.getDate()
  scope.oldDate = true
  
  yearMontDay = (date)->
    res = new Date(date)
    month = res.getMonth() + 1
    if month < 10
      month = "0" + month
    res.getDate() + "/" + month + "/" + res.getFullYear()
  
  timeOfDate = (date)->
    res = new Date(date)
    minutes = res.getMinutes()
    if minutes < 10
      minutes = "0"+minutes
    res.getHours() + ":" + minutes
  
  scope.showTime = (date)->
    todayDate = yearMontDay new Date()
    selDate = yearMontDay new Date(date)
    if todayDate is selDate
      timeOfDate(date)
    else
      scope.oldDate = false
      selDate + " " + timeOfDate(date)
  
  scope.changeDate = ()->
    console.log "changing date"

  scope.getId = (note)->
    note._id
  scope.deleteNote = (note)->
    console.log note
  scope.$watch ()->
    dateService.getDate()
  , (newDate)->
    newOne = newDate.getFullYear() + " " + newDate.getMonth() + " " + newDate.getDate()
    oldOne = current_date.getFullYear() + " " + current_date.getMonth() + " " + current_date.getDate()
    if newOne isnt oldOne
      console.log "not the same"
      today = newDate
      today.setHours(0)
      today.setMinutes(0)
      tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000))
      params = {
        start_date: today
        end_date: tomorrow
      }
      request = notesService.byDate params
      request.success (data)->
        scope.notes = data
      request.error (err)->
        console.log err
    else 
      scope.oldDate = true
      today = dateService.getDate()
      today.setHours(0)
      today.setMinutes(0)
      tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000))
      params = {
        start_date: today
        end_date: tomorrow
      }
      request = notesService.byDate params
      request.success (data)->
        scope.notes = data
      request.error (err)->
        console.log err
]

app.directive 'calendar', ['dateService',(dateService)->
  {
    restrict : "EA"
    template : '<div id="datepicker"></div>'
    link : (scope, element, attrs)->
      selected_date = ""
      $( "#datepicker" ).datepicker({
        inline: true
        showOtherMonths: true
        dateFormat: 'yy-mm-dd'
        minDate: new Date('2013-11-14')
        maxDate: '+1y'
        dayNamesMin: [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс" ]
        monthNames: [ "Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь" ]
        onSelect: (date, obj)->
          dateService.setDate date
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

