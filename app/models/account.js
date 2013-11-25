var mongoose = require('mongoose'),
		Schema = mongoose.Schema;

var AccountSchema = new Schema({
	client: {
		name: String,
		id : String,
		savings: Number
	},
	master: {type: Schema.ObjectId, ref: 'Master'},
	masterIncome: Number,
	payed : Number,
	materials : Number,
	forSaloon : Number,
	date: Date
});

AccountSchema.statics = {
  load: function(id, cb){
    this.findOne({
      _id : id
    }).populate('master', 'surname name').exec(cb);
  }
}

mongoose.model('Account', AccountSchema);