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

  var masters = require('../app/controllers/masters');

  app.post('/api/masters', masters.create);
  app.get('/api/masters', masters.all);
  app.put('/api/masters/:masterID', masters.update);
  app.del('/api/masters/:masterID', masters.destroy);

  app.param('masterID', masters.master);
  
  /*
   * App route
   */
  var routes = require('./../routes');
  app.get('/', routes.index);
}