app.config ['$routeProvider', (routeProvider)->
  
  #
  # Routes for notes
  #

  routeProvider.when '/', {} =
    controller: 'notesCtrl'
    templateUrl: 'views/notes.html'
    resolve: {
      notes: (notesService, dateService)->
        today = dateService.getDate()
        today.setHours(0)
        today.setMinutes(0)
        tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000))
        params = {
          start_date: today
          end_date: tomorrow
        }
        console.log params
        request = notesService.byDate(params)
    }

  routeProvider.when '/addnote', {} =
    controller: 'NoteCtrl'
    templateUrl: 'views/note.html'
    resolve: {
      masters: (mastersService)->
        request = mastersService.all()
    }

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
    }
]