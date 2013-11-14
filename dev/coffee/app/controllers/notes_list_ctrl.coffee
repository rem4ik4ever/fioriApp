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
