var mongoose = require('mongoose'),
    Schema = mongoose.Schema;


var ClientSchema = new Schema({
  name: String,
  surname: String,
  patronymic: {type: String, default: ""},
  birthday: Date,
  phone: [{phonetype: String, number: String}],
  email: String,
  discount: {type: Number, default: 0},
  savings: {type: Number, default: 0},
  masters: [String],
  services: [{
    service_type: String,
    material : String
  }],
  reg_date: Date
});


/**
 * Statics
 */


ClientSchema.statics ={
  load: function(id, cb){
    this.findOne({
      _id : id
    }).exec(cb);
  }
}


mongoose.model('Client', ClientSchema);