var mongoose = require('mongoose'),
    Client = mongoose.model('Client'),
    _ = require('underscore');

exports.create = function(req, res){
  var client = new Client(req.body);
  client.save(function(err, client){
    if (err)
      res.jsonp({err: err}, 500);
    res.jsonp({message: "Created"});
  });
}
exports.all = function(req, res){
  console.dir("all");
  Client.find().exec(function(err, clients){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(clients);
    }
  });
}

exports.update = function(req, res){
  var client = req.client;
  console.log("trying to update");
  client = _.extend(client, req.body);
  client.save(function(err){
    res.jsonp({message: "Updated"})
  });
}


exports.client = function(req, res, next, id){
  Client.load(id, function(err, client){
    if (err) return next(err);
    if(!client) return next(new Error('Failed to load client' + id));
    req.client = client;
    next();
  });
}

exports.find = function(req, res){
  
  var param = new RegExp(req.body.name, 'i');
  Client.find({},{name:1, surname:1}).or([{'name' : {$regex: param}}, {'surname': {$regex: param}}]).exec(function(err, clients){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(clients);
    }
  });
}

exports.destroy = function(req, res){
  var client = req.client;

  client.remove(function(err){
    if(err){
      res.render('error', {
        status : 500
      });
    } else {
      res.jsonp(client);
    }
  });
}