app.factory 'notesService', ['$http', (http)->
  return{
    save: (note)->
      result = http.post '/api/notes', note
    all: ()->
      result = http.get '/api/notes'
    byDate: (params)->
      result = http.post '/api/notes/bydate', params
  }
]