app.factory 'clientsService', ['$http','$location', (http, location)->
  client_to_edit = {}
  return {
    create: (client)->
      result = http.post '/api/clients', client
    all: ()->
      result = http.get '/api/clients'
    edit: (client)->
      client_to_edit = client
      location.path('/clients/edit/'+client._id)
    getEdit: ()->
      client_to_edit
    update: (client)->
      result = http.put '/api/clients/'+client._id, client
    delete: (id)->
      result = http.delete '/api/clients/'+id
    find: (param)->
      result = http.post '/api/clients/find', param
  }
]