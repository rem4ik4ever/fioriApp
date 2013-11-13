app.controller 'NoteCtrl', ['$scope','dateService','clientsService','notesService' ,'masters', (scope, dateService, clientsService, notesService, masters)->
  console.log "note ctrl"
  scope.masters = masters.data
  console.log masters.data
  months = ["Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря"]
  
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
  scope.saveNote = ()->
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

    console.log note
    request = notesService.save note
    request.success (data)->
      console.log data
      scope.active = true
    request.error (err)->
      console.log err
  
  scope.newNote = ()->
    scope.active = false
    clearFields()

  return
]