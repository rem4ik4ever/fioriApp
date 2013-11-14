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