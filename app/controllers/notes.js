var mongoose = require('mongoose'),
    Note = mongoose.model('Note'),
    _ = require('underscore');

exports.create = function(req, res){
  var note = new Note(req.body);
  note.save(function(err, note){
    if (err)
      res.jsonp({err: err}, 500);
    res.jsonp({message: "Created"});
  });
}
exports.all = function(req, res){
  console.dir("all");
  Note.find().populate('master', 'name surname').sort('time').exec(function(err, notes){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(notes);
    }
  });
}
exports.byDate = function(req, res){
  var params = req.body;
  Note.find().where('time').gt(params.start_date).lt(params.end_date).populate('master', 'name surname wageRate').sort('time').exec(function(err, notes){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(notes);
    }
  });
}
exports.byDateMaster = function(req, res){
  var params = req.body;
  Note.find().where('master').equals(params.master).where('time').gt(params.start_date).lt(params.end_date).populate('master', 'name surname').sort('time').exec(function(err, notes){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(notes);
    }
  });
}
exports.update = function(req, res){
  var note = req.note;
  console.log("trying to update");
  note = _.extend(note, req.body);
  note.save(function(err){
    res.jsonp({message: "Updated"})
  });
}
exports.one = function(req, res){
  var note_id = req.query.q
  console.dir(note_id);
  Note.findOne({_id : note_id}).populate('master', 'name surname').exec(function(err, note){
    if (err){
      res.jsonp('error', {
        status: 500
      });
    } else {
      res.jsonp(note);
    }
  });
  
}

exports.note = function(req, res, next, id){
  Note.load(id, function(err, note){
    if (err) return next(err);
    if(!note) return next(new Error('Failed to load note' + id));
    req.note = note;
    next()
  });
}

exports.destroy = function(req, res){
  var note = req.note;

  note.remove(function(err){
    if(err){
      res.render('error', {
        status : 500
      });
    } else {
      res.jsonp(note);
    }
  });
}