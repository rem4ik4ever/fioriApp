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
      param: (mastersService)->
        {type :'add', client : null, masters: mastersService.all()}
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
      param: (clientsService, mastersService)->
        {type : 'edit', client : clientsService.getEdit(), masters: mastersService.all()}
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
  routeProvider.when '/data', {} =
    controller: 'dataCtrl'
    templateUrl: 'views/data.html'
]
app.factory 'accountService', ['$http', (http)->
	return{
		create: (account)->
			request = http.post '/api/account', account
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
app.factory 'dataService', ['$http', (http)->
	return {
		byDate: (params)->
			request = http.post '/api/account/bydate', params
	}
]
app.factory 'dateService', [()->
  noteDay = new Date()
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
    delete: (id)->
      request = http.delete "/api/notes/"+id
  }
]
app.controller 'ClientCtrl', ['$scope', 'clientsService','param', (scope, clientsService, param)->
  console.log "add user ctrl"
  param.masters.success (data)->
    scope.masters = data
  param.masters.error (err)->
    console.log err
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


app.controller 'dataCtrl', ['$scope','dateService','dataService', (scope, dateService, dataService)->
	scope.showDate = ()->
		console.log scope.begin + " " + scope.end
	setData = (data)->
		scope.data = data 
		getTotals()
	scope.find = ()->
		if angular.isDefined scope.begin and angular.isDefined scope.end 
			scope.sum = [0,0,0,0]
			params = 
				start_date: scope.begin
				end_date: scope.end
			request = dataService.byDate params
			request.success (data)->
				console.log data
				setData data

		else 
			alert 'Пожалуйста заполните дату начала и конца'
	scope.totalSpendings = (one, two)->
		(Number) one + (Number) two
	getTotals = ()->
		for info in scope.data
			if angular.isDefined info.payed
				scope.sum[0] += info.payed
			if angular.isDefined info.forSaloon
				scope.sum[1] += info.forSaloon
			if angular.isDefined info.masterIncome
				scope.sum[2] += info.masterIncome
			if angular.isDefined info.materials
				scope.sum[3] += info.materials
		tmp = []
		for sum in scope.sum
			tmp.push sum.toFixed(2)
		scope.sum = tmp
		console.log scope.sum
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
  current_date = dateService.getDate()
  scope.requireminutes = 60
  
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
    start = dateService.getDate()
    start.setHours 0
    start.setMinutes 0
    start.setSeconds 0
    start.setMilliseconds 0
    params = {
      start_date : dateService.getDate()
      end_date : new Date(dateService.getDate().getTime() + (24 * 60 * 60 * 1000))
      master : scope.master._id
    }
    console.log params
    request = notesService.masterNotes(params)
    request.success (data)->
      if param.type is 'edit'
        console.log "in edit"
        for note in data
          if !_.isEqual(note, editnote)
            scope.masterNotes.push note
      else 
        console.log "in masters"
        scope.masterNotes = data
      console.log scope.masterNotes
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
    scope.requireminutes = 60
  scope.mins = (mins)->
    if mins < 10
      "0" + mins
    else
      mins
  scope.checkInter = (note)->
    time = new Date(note.time)
    minutes = note.minutes
    noteStartTime = time.getHours() + (time.getMinutes() / 100)
    noteEndTime = Math.floor(time.getHours() + (time.getMinutes() + note.minutes)/ 60) + ((time.getMinutes() + note.minutes - (Math.floor((time.getMinutes() + note.minutes) / 60) * 60)) / 100)
    startTime =  scope.hours + (scope.minutes / 100)
    mn = 60
    if angular.isDefined scope.requireminutes and scope.requireminutes isnt null
      mn = scope.requireminutes

    endTime = Math.floor(scope.hours + (scope.minutes + mn) / 60) + ((scope.minutes + mn - (Math.floor((scope.minutes + mn) / 60) * 60)) / 100) 
    if noteStartTime <= startTime and startTime <= noteEndTime
      return "intersection"
    else if noteStartTime <= endTime and endTime <= noteEndTime
      return "intersection"
    else return ""

  scope.unTill = (note)->
    time = new Date note.time
    hours = Math.floor(time.getHours() + (time.getMinutes() + note.minutes)/ 60)
    minutes = time.getMinutes() + note.minutes - (Math.floor((time.getMinutes() + note.minutes) / 60) * 60)
    if minutes < 9
      minutes = "0" + minutes
    hours + ":" + minutes

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
      minutes: ""
    }
    
    reg_date = dateService.getDate()
    reg_date.setHours(scope.hours)
    reg_date.setMinutes(scope.minutes)
    reg_date.setSeconds(0)

    if scope.unregister_client isnt undefined and scope.unregister_client isnt ""
      note.client.name = scope.unregister_client
      # note.client.id = ""
    else
      note.client.name = scope.register_client
      note.client.id = scope.client._id

    note.master = scope.master._id
    note.service = scope.service
    note.time = reg_date
    if scope.requireminutes isnt undefined and scope.requireminutes isnt ""
      note.minutes = scope.requireminutes
    else 
      note.minutes = 60

    if type is 'add'
      console.log "add"
      console.log note
      request = notesService.save note
      request.success (data)->
        scope.active = true
        console.log data
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
    scope.masterNotes = []
    clearFields()
  scope.formState = ()->
    if scope.active is true or scope.updated is true
      true
    false

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
      if angular.isDefined scope.master
        params = {
          start_date: today
          end_date: tomorrow
          master: scope.master._id
        }
        request = notesService.masterNotes params
        request.success (data)->
          scope.masterNotes = data
        request.error (err)->
          console.log err
    else 
      scope.oldDate = true
      today = dateService.getDate()
      today.setHours(0)
      today.setMinutes(0)
      tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000))
      if angular.isDefined scope.master
        params = {
          start_date : today
          end_date : tomorrow
          master : scope.master._id
        }
        request = notesService.masterNotes params
        request.success (data)->
          scope.masterNotes = data
        request.error (err)->
          console.log err

  return
]
app.controller 'notesCtrl', ['$scope','notes','notesService','dateService','accountService', 'clientsService', (scope, notes, notesService, dateService, accountService, clientsService)->
  console.log "notes ctrl launched"
  scope.notes = notes.data
  console.log scope.notes
  current_date = dateService.getDate()
  scope.oldDate = true
  scope.payFormActive = false
  
  account = ()->
    client: {
      name : ""
      id : ""
      savings: ""
    },
    master: "",
    masterIncome: "",
    payed : "",
    materials: "",
    forSaloon : "",
    date : ""

  yearMontDay = (date)->
    res = new Date(date)
    res.setHours 0
    res.setMinutes 0
    res.setSeconds 0
    res.setMilliseconds 0
    res
  
  timeOfDate = (date)->
    res = new Date(date)
    minutes = res.getMinutes()
    if minutes < 10
      minutes = "0"+minutes
    res.getHours() + ":" + minutes
  
  scope.showTime = (date)->
    todayDate = yearMontDay new Date()
    selDate = yearMontDay new Date(date)
    if todayDate > selDate
      scope.oldDate = false
    else 
      scope.oldDate = true
    timeOfDate(date)
  
  scope.changeDate = ()->
    console.log "changing date"

  scope.getId = (note)->
    note._id
  
  scope.deleteNote = (note)->
    console.log note
    id = note._id
    answer = confirm "Удалить запись клиента " + note.client.name + "?"
    if answer
      request = notesService.delete(id)
      request.success ()->
        params = 
          start_date : dateService.getDate()
          end_date : new Date(dateService.getDate().getTime() + (24 * 60 * 60 * 1000))
        notesrequest = notesService.byDate(params)
        notesrequest.success (data)->
          scope.notes = data
          console.log data
  
  scope.finishService = (note)->
    console.log "opening"
    scope.payFormActive = true
    scope.selected_note = note
    scope.price = 0
    scope.materials = 0
    scope.acc = new account()
    scope.acc.client = note.client
    scope.acc.master = note.master._id
    scope.acc.date = note.time
  
  scope.closePayForm = ()->
    if scope.payFormActive
      scope.payFormActive = false
      console.log "closing"
  
  scope.toPay = ()->
    if angular.isDefined scope.price 
      if scope.selected_note.client.id isnt undefined and scope.selected_note.client.id isnt null
        result = (scope.price - (scope.price * scope.selected_note.client.id.discount/100)).toFixed(2)
        return result
      else 
        return scope.price
    return 0

  scope.mastersPrice = ()->
    if angular.isDefined(scope.price) and angular.isDefined(scope.materials)
      if scope.selected_note.client.id isnt undefined and scope.selected_note.client.id isnt null
        scope.acc.masterIncome = (scope.price - (scope.price * scope.selected_note.client.id.discount / 100).toFixed(2) - scope.materials ) * scope.selected_note.master.wageRate / 100
        scope.acc.masterIncome = scope.acc.masterIncome.toFixed(2)      
      else 
        scope.acc.masterIncome = (scope.price - scope.materials ) * scope.selected_note.master.wageRate / 100
        scope.acc.masterIncome = scope.acc.masterIncome.toFixed(2)      

  scope.saloonPrice = ()->
    if angular.isDefined(scope.price) and angular.isDefined(scope.materials)
      if scope.selected_note.client.id isnt undefined and scope.selected_note.client.id isnt null
        scope.acc.forSaloon = (scope.price - (scope.price * scope.selected_note.client.id.discount/100).toFixed(2) - scope.materials) - scope.acc.masterIncome
      else
        scope.acc.forSaloon = scope.price - scope.materials - scope.acc.masterIncome
      scope.acc.forSaloon = scope.acc.forSaloon.toFixed(2)

  scope.clientSavings = ()->
    if angular.isDefined(scope.price) and angular.isDefined(scope.materials)
      if scope.selected_note.client.id isnt undefined and scope.selected_note.client.id isnt null
        scope.acc.client.savings = (scope.price - (scope.price * scope.selected_note.client.id.discount / 100)).toFixed(2) - scope.materials
      else 
        0

  scope.saveService = ()->
    scope.acc.materials = scope.materials
    client = scope.selected_note.client.id
    if scope.selected_note.client.id isnt undefined and scope.selected_note.client.id isnt null
      scope.acc.payed = (scope.price - (scope.price * scope.selected_note.client.id.discount/100)).toFixed(2)
      client.savings += scope.acc.client.savings
    else 
      scope.acc.payed = scope.price
    console.log scope.acc
    request = accountService.create scope.acc
    request.success (data)->
      console.log data
      scope.payFormActive = false
      scope.selected_note.complete = true
      console.log scope.selected_note
      note = scope.selected_note
      note.id = scope.selected_note._id
      reques = notesService.update(note)
      reques.success ()->
        if client isnt undefined and client isnt null
          request = clientsService.update(client)
          request.success (data)->
            console.log "Client savings updated"
        console.log "Completed"

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

