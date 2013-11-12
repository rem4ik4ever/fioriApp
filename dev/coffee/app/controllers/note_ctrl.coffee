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