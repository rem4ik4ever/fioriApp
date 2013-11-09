app.config ['$routeProvider', (routeProvider)->
  routeProvider.when '/', {} =
    controller: 'notesCtrl'
    templateUrl: 'views/notes.html'
  routeProvider.when '/addclient', {} = 
    controller: 'addUserCtrl'
    templateUrl: 'views/newclient.html'
]