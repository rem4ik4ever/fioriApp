app.factory 'clientsService', ['$http','$location', (http, location)->
  client_to_edit = {}
  return {
    create: (client)->
      console.log "create called"
      result = http.post '/api/clients/create', client
    all: ()->
      console.log "all clients"
      result = http.get '/api/clients/all'
    edit: (client)->
      client_to_edit = client
      location.path('/clients/edit/'+client._id)
    getEdit: ()->
      client_to_edit
    update: (client)->
      result = http.put '/api/clients/'+client._id, client
    delete: (id)->
      result = http.delete '/api/clients/'+id
  }
]