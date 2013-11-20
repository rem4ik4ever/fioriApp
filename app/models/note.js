var mongoose = require('mongoose'),
    Schema = mongoose.Schema;


var NoteSchema = new Schema({
  client : {
    name : String,
    id : {
      type: Number,
      ref: 'Client'
    }
  },
  master : {
    type: Schema.ObjectId,
    ref: 'Master'
  },
  service : String,
  time: Date,
  minutes: {type: Number, default: 60},
  complete: {type: Boolean, default: false}
});

NoteSchema.statics = {
  load: function(id, cb){
    this.findOne({
      _id : id
    }).populate('client.id', 'discount').populate('master', 'surname name').exec(cb);
  }
}


mongoose.model('Note', NoteSchema);