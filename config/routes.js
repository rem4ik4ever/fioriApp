module.exports = function(app){
  

  /*
   * api reference "clients"
   */
  var clients = require('../app/controllers/clients');

  app.post('/api/clients/create', clients.create);
  app.get('/api/clients/all', clients.all);
  app.put('/api/clients/:clientID', clients.update);
  app.del('/api/clients/:clientID', clients.destroy);
  
  app.param('clientID', clients.client);
  
  /*
   * App route
   */
  var routes = require('./../routes');
  app.get('/', routes.index);
}