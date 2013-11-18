var mongoose = require('mongoose'),
    Account = mongoose.model('Account'),
    _ = require('underscore');

exports.create = function(req, res){
  var account = new Account(req.body);
  account.save(function(err, account){
    if (err)
      res.jsonp({err: err}, 500);
    res.jsonp({message: "Created"});
  });
}
exports.all = function(req, res){
  console.dir("all");
  Account.find().populate('master', 'name surname').sort('time').exec(function(err, account){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(account);
    }
  });
}
exports.byDate = function(req, res){
  var params = req.body;
  Account.find().where('date').gt(params.start_date).lt(params.end_date).populate('master', 'name surname wageRate').sort('date').exec(function(err, account){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(account);
    }
  });
}
exports.byDateMaster = function(req, res){
  var params = req.body;
  Account.find().where('master').equals(params.master).where('date').gt(params.start_date).lt(params.end_date).populate('master', 'name surname').sort('date').exec(function(err, account){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(account);
    }
  });
}
exports.update = function(req, res){
  var account = req.account;
  console.log("trying to update");
  account = _.extend(account, req.body);
  account.save(function(err){
    res.jsonp({message: "Updated"})
  });
}
exports.one = function(req, res){
  var account_id = req.query.q
  console.dir(account_id);
  Account.findOne({_id : account_id}).populate('master', 'name surname').exec(function(err, account){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(account);
    }
  });
}

exports.account = function(req, res, next, id){
  Account.load(id, function(err, account){
    if (err) return next(err);
    if(!account) return next(new Error('Failed to load account' + id));
    req.account = account;
    next()
  });
}

exports.destroy = function(req, res){
  var account = req.account;

  account.remove(function(err){
    if(err){
      res.render('error', {
        status : 500
      });
    } else {
      res.jsonp(account);
    }
  });
}