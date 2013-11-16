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
      param: (mastersService)->
        request = mastersService.all()
        {type: 'add' , masters: request}

    }

  routeProvider.when '/notes/edit/:note', {} =
    controller: 'NoteCtrl'
    templateUrl: 'views/note.html'
    resolve: {
      param: ($route, notesService)->
        id = $route.current.params.note
        console.log id
        {type: 'edit', note: notesService.getEdit(id)}
    }
  
  #
  # Routes for clients
  #

  routeProvider.when '/addclient', {} = 
    controller: 'ClientCtrl'
    templateUrl: 'views/client.html'
    resolve: {
      param: (mastersService)->
        {type :'add', client : null, masters: mastersService.all()}
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
      param: (clientsService, mastersService)->
        {type : 'edit', client : clientsService.getEdit(), masters: mastersService.all()}
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