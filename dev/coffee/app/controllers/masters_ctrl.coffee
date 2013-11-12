app.controller 'MasterCtrl', ['$scope', 'mastersService','param', (scope, mastersService, param)->
  scope.active = true
  scope.updated = false
  scope.removed = false
  # Client class
  master = ()->
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
    spec: []

  if param.type is 'add'
    scope.master = new master
  else
    scope.master = param.master
    console.log scope.master
    scope.mobilephone = scope.master.phone[0].number
    scope.homephone = scope.master.phone[1].number
    date = new Date(scope.master.birthday)
    year = date.getFullYear()
    month = date.getMonth()+1
    day = date.getDate()
    if day < 10
      day = "0" + day
    if month < 10
      month = "0" + month
    scope.birthday = year + '-' + month + '-' + day
    hire = new Date(scope.master.hiredate)
    year = hire.getFullYear()
    month = hire.getMonth()+1
    day = hire.getDate()
    if day < 10
      day = "0" + day
    if month < 10
      month = "0" + month
    scope.hiredate = year + '-' + month + '-' + day
    fire = new Date(scope.master.firedate)
    year = fire.getFullYear()
    month = fire.getMonth()+1
    day = fire.getDate()
    if day < 10
      day = "0" + day
    if month < 10
      month = "0" + month
    scope.firedate = year + '-' + month + '-' + day
    console.log scope.birthday
    console.log scope.hiredate
    console.log scope.firedate

  scope.saveMaster = ()->
    if param.type is 'add'
      scope.master.reg_date = new Date()
      response = mastersService.create scope.master
      response.success (data)->
        console.log data
        scope.active = false
      response.error ()->
        console.log "Error"
    else
      update()

  scope.setPhone = (index)->
    if index is 0
      scope.master.phone[index].number = scope.mobilephone
    else
      scope.master.phone[index].number = scope.homephone

  scope.setBirthday = ()->
    scope.master.birthday = new Date scope.birthday

  scope.cleanFields = ()->
    scope.master = new master
    scope.mobilephone = ""
    scope.homephone   = ""
    scope.birthday    = ""
    scope.hiredate    = ""
    scope.firedate    = ""

  scope.getAll = ()->
    result = mastersService.all()
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

  update = ()->
    request = mastersService.update(scope.master)
    request.success ()->
      scope.updated = true
    request.error ()->
      console.log "Error while updating"
  scope.remove = ()->
    answer = confirm "Удалить мастера " + scope.master.surname + " " + scope.master.name
    if answer 
      request = mastersService.delete(scope.master._id)
      request.error ()->
        console.log "Error while deleting"
      scope.removed = true

  scope.hideIt = ()->
    if scope.updated or scope.removed
      true
    else false

  scope.setHiredate = ()->
    scope.master.hiredate = new Date scope.hiredate

  scope.setFiredate = ()->
    scope.master.firedate = new Date scope.firedate
  scope.addSpec = ()->
    if scope.master.spec.indexOf(scope.spec) is -1
      scope.master.spec.push scope.spec
      scope.spec = ""
  scope.removeSpec = (index)->
    scope.master.spec.splice index, 1
  return
]