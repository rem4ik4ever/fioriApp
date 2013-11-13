app.controller 'notesCtrl', ['$scope','notes','notesService','dateService', (scope, notes, notesService, dateService)->
  console.log "notes ctrl"
  scope.notes = notes.data
  console.log scope.notes
  current_date = dateService.getDate()
  yearMontDay = (date)->
    res = new Date(date)
    month = res.getMonth() + 1
    if month < 10
      month = "0" + month
    res.getDate() + " " + month + " " + res.getFullYear()
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
      selDate + " " + timeOfDate(date)
  scope.changeDate = ()->
    console.log "changing date"

  scope.$watch ()->
    dateService.getDate()
  , (newDate)->
    console.log dateService.getDate()
    console.log current_date
    newOne = newDate.getFullYear() + " " + newDate.getMonth() + " " + newDate.getDate()
    oldOne = current_date.getFullYear() + " " + current_date.getMonth() + " " + current_date.getDate()
    if newOne isnt oldOne
      console.log "not the same"
    else 
      console.log "the same"
]
