app.factory 'notesService', ['$http', '$location', (http, location)->
  note_to_edit = {}
  return{
    save: (note)->
      result = http.post '/api/notes', note
    all: ()->
      result = http.get '/api/notes'
    byDate: (params)->
      result = http.post '/api/notes/bydate', params
    masterNotes: (params)->
      result = http.post '/api/notes/bydatemaster', params
    getEdit: (id)->
      request = http.get "/api/notes/edit?q="+id
    update: (note)->
      request = http.put "/api/notes/"+note.id, note
    delete: (id)->
      request = http.delete "/api/notes/"+id
  }
]