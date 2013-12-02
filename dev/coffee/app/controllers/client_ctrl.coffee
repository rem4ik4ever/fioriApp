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

  scope.checkCard = (num)->
    if num isnt -1
      return num
    else "- "

  return
]