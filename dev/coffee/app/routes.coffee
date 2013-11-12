app.config ['$routeProvider', (routeProvider)->
  
  #
  # Routes for notes
  #

  routeProvider.when '/', {} =
    controller: 'notesCtrl'
    templateUrl: 'views/notes.html'

  routeProvider.when '/addnote', {} =
    controller: 'NoteCtrl'
    templateUrl: 'views/note.html'

  routeProvider.when '/note/edit/:id', {} =
    controller: 'NoteCtrl'
    templateUrl: 'views/note.html'
  
  #
  # Routes for clients
  #

  routeProvider.when '/addclient', {} = 
    controller: 'ClientCtrl'
    templateUrl: 'views/client.html'
    resolve: {
      param: ()->
        {type :'add', client : null}
    }
  routeProvider.when '/clients', {} =
    controller: 'clientsCtrl'
    templateUrl: 'views/clientslist.html'
    resolve: {
      clients: (clientsService)->
        request = clientsService.all()
        request.success (data)->
          data
    }
  routeProvider.when '/clients/edit/:id', {} =
    controller: 'ClientCtrl'
    templateUrl: 'views/client.html'
    resolve: {
      param: (clientsService)->
        {type : 'edit', client : clientsService.getEdit()}
    }
  
  #
  # Routes for masters
  #

  routeProvider.when '/addmaster', {} =
    controller: 'MasterCtrl'
    templateUrl: 'views/master.html'
    resolve:{
      param: ()->
        {type : 'add', master: null}
    }
  routeProvider.when '/masters/edit/:id', {} =
    controller: 'MasterCtrl'
    templateUrl: 'views/master.html'
    resolve: {
      param: (mastersService)->
        {type : 'edit', master : mastersService.getEdit()}
    }
  routeProvider.when '/masters', {} =
    controller: 'mastersCtrl'
    templateUrl: 'views/masterslist.html'
    resolve: {
      masters: (mastersService)->
        request = mastersService.all()
        request.success (data)->
          data
    }
]