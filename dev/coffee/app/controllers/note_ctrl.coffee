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
    if note.time is editnote.time
      return "editable"
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
      scope.intersection = true
      return "intersection"
    else if noteStartTime <= endTime and endTime <= noteEndTime
      scope.intersection = true
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