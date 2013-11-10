app.factory 'clientsService', ['$http', (http)->
  return {
    create: (client)->
      console.log "create called"
      result = http.post '/api/clients/create', client
  }
]