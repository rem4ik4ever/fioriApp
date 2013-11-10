app.controller 'addUserCtrl', ['$scope', 'clientsService', (scope, clientsService)->
  console.log "add user ctrl"
  animation = false;
  scope.masters = ["Ким Диана", "Дмитрий Ногиев"]

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


  scope.client = new client

  scope.saveClient = ()->
    console.log "Saving user:"
    scope.client.reg_date = new Date()
    console.log scope.client
    response = clientsService.create scope.client
    response.success (data)->
      console.log data
    response.error ()->
      console.log "Error"


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
    console.log scope.client
  scope.addMaster = (master)->
    if master isnt undefined and master.length > 0
      scope.client.masters.push master
    console.log scope.client.masters

  scope.removeMaster = (master)->
    scope.client.masters.splice scope.client.masters.indexOf(master), 1
  return
]