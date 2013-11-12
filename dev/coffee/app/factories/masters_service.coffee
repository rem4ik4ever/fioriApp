app.factory 'mastersService', ['$http','$location', (http, location)->
  master_to_edit = {}
  return {
    create: (master)->
      result = http.post '/api/masters', master
    update: (master)->
      result = http.put '/api/masters/'+master._id, master
    edit: (master)->
      master_to_edit = master
      location.path('/masters/edit/'+master._id)
    getEdit: ()->
      master_to_edit
    delete: (id)->
      result = http.delete '/api/masters/'+id
    all: ()->
      result = http.get '/api/masters'
  }
]