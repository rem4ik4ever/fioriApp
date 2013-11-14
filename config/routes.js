module.exports = function(app){
  

  /*
   * api reference "clients"
   */
  var clients = require('../app/controllers/clients');

  app.post('/api/clients/find', clients.find)
  app.post('/api/clients', clients.create);
  app.get('/api/clients', clients.all);
  app.put('/api/clients/:clientID', clients.update);
  app.del('/api/clients/:clientID', clients.destroy);
  
  app.param('clientID', clients.client);

  /*
   * api reference "masters"
   */
  var masters = require('../app/controllers/masters');

  app.post('/api/masters', masters.create);
  app.get('/api/masters', masters.all);
  app.put('/api/masters/:masterID', masters.update);
  app.del('/api/masters/:masterID', masters.destroy);

  app.param('masterID', masters.master);

  /*
   * api reference "notes"
   */
   var notes = require('../app/controllers/notes');

   app.post('/api/notes', notes.create);
   app.get('/api/notes', notes.all);
   app.get('/api/notes/edit', notes.one)
   app.post('/api/notes/bydate', notes.byDate);
   app.post('/api/notes/bydatemaster', notes.byDateMaster);
   app.put('/api/notes/:noteID', notes.update);
   app.del('/api/notes/:noteID', notes.destroy);

   app.param('noteID', notes.note);
  
  /*
   * App route
   */
  var routes = require('./../routes');
  app.get('/', routes.index);
}