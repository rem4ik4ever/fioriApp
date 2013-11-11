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