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
  Note.find().exec(function(err, notes){
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