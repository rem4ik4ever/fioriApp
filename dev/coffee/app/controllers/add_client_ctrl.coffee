app.controller 'addUserCtrl', ['$scope', (scope)->
  console.log "add user ctrl"
  animation = false;
  scope.masters = ["Ким Диана", "Дмитрий Ногиев"]
  scope.client = 
    savings: 0
    discount: 0
    phone: [
      {
        type: "мобильный"
        number: ""
      }
      {
        type: "домашний"
        number: ""
      }
    ]
  scope.saveClient = ()->
    console.log "Saving user:"
    scope.client.reg_date = new Date()
    console.log scope.client
  scope.setPhone = (index)->
    if index is 0
      scope.client.phone[index].number = scope.mobilephone
    else
      scope.client.phone[index].number = scope.homephone
  scope.setBirthday = ()->
    scope.client.birthday = new Date scope.birthday
  scope.setMaster = ()->
    scope.client.master = scope.clientmaster
]