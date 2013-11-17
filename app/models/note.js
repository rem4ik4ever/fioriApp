var mongoose = require('mongoose'),
    Schema = mongoose.Schema;


var NoteSchema = new Schema({
  client : {
    name : String,
    id : String,
  },
  master : {
    type: Schema.ObjectId,
    ref: 'Master'
  },
  service : String,
  time: Date,
  complete: {type: Boolean, default: false}
});

NoteSchema.statics = {
  load: function(id, cb){
    this.findOne({
      _id : id
    }).populate('master', 'surname name').exec(cb);
  }
}


mongoose.model('Note', NoteSchema);