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