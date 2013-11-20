app.controller 'notesCtrl', ['$scope','notes','notesService','dateService','accountService', (scope, notes, notesService, dateService, accountService)->
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
      if scope.selected_note.client.id isnt null
        result = (scope.price - (scope.price * scope.selected_note.client.id.discount/100)).toFixed(2)
        return result
      else 
        return scope.price
    return 0

  scope.mastersPrice = ()->
    if angular.isDefined(scope.price) and angular.isDefined(scope.materials)
      if scope.selected_note.client.id isnt null
        scope.acc.masterIncome = (scope.price - (scope.price * scope.selected_note.client.id.discount / 100).toFixed(2) - scope.materials ) * scope.selected_note.master.wageRate / 100
        scope.acc.masterIncome = scope.acc.masterIncome.toFixed(2)      
      else 
        scope.acc.masterIncome = (scope.price - scope.materials ) * scope.selected_note.master.wageRate / 100
        scope.acc.masterIncome = scope.acc.masterIncome.toFixed(2)      

  scope.saloonPrice = ()->
    if angular.isDefined(scope.price) and angular.isDefined(scope.materials)
      if scope.selected_note.client.id isnt null
        scope.acc.forSaloon = (scope.price - (scope.price * scope.selected_note.client.id.discount/100).toFixed(2) - scope.materials) - scope.acc.masterIncome
      else
        scope.acc.forSaloon = scope.price - scope.materials - scope.acc.masterIncome
      scope.acc.forSaloon = scope.acc.forSaloon.toFixed(2)

  scope.clientSavings = ()->
    if angular.isDefined(scope.price) and angular.isDefined(scope.materials)
      if scope.selected_note.client.id isnt null
        scope.acc.client.savings = (scope.price - (scope.price * scope.selected_note.client.id.discount / 100)).toFixed(2) - scope.materials
      else 
        0

  scope.saveService = ()->
    scope.acc.materials = scope.materials
    if scope.selected_note.client.id isnt null
      scope.acc.payed = (scope.price - (scope.price * scope.selected_note.client.id.discount/100)).toFixed(2)
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
