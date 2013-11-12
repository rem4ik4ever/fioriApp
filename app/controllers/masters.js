var mongoose = require('mongoose'),
    Master = mongoose.model('Master'),
    _ = require('underscore');

exports.create = function(req, res){
  var master = new Master(req.body);
  master.save(function(err, master){
    if (err)
      res.jsonp({err: err}, 500);
    res.jsonp({message: "Master created"});
  });
}
exports.all = function(req, res){
  console.dir("all");
  Master.find().exec(function(err, masters){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(masters);
    }
  });
}
exports.update = function(req, res){
  var master = req.master;
  console.log("trying to update");
  master = _.extend(master, req.body);
  master.save(function(err){
    res.jsonp({message: "Master updated"})
  });
}


exports.master = function(req, res, next, id){
  Master.load(id, function(err, master){
    if (err) return next(err);
    if(!master) return next(new Error('Failed to load master' + id));
    req.master = master;
    next()
  });
}

exports.destroy = function(req, res){
  var master = req.master;

  master.remove(function(err){
    if(err){
      res.render('error', {
        status : 500
      });
    } else {
      res.jsonp(master);
    }
  });
}