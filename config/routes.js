module.exports = function(app, routes){
  
  app.get('/', routes.index);

  /*
   * api reference
   */
  var clients = require('../app/controllers/clients');
  app.post('/api/clients/create', clients.create);
}