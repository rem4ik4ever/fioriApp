var mongoose = require('mongoose'),
    Schema = mongoose.Schema;

var MasterSchema = Schema({
  name: String,
  surname: String,
  patronymic : String,
  address: String,
  email: String,
  phone : [{phonetype: String, number: String}],
  birthday: Date,
  spec: [String],
  hiredate: Date,
  firedate: Date,
  wageRate: Number
});

/**
 * Statics
 */

MasterSchema.statics = {
  load: function(id, cb){
    this.findOne({
      _id : id
    }).exec(cb);
  }
}

mongoose.model('Master', MasterSchema);