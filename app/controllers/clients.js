var mongoose = require('mongoose'),
    Client = mongoose.model('Client');

  // var client = new Client({
  //   firstname: "Rem",
  //   surname: "Kim",
  //   birthday: new Date('1993-03-16'),
  //   phone: [{phonetype: "Mobile", number: "(559)808980"}],
  //   email: "rem4ik4ever@gmail.com",
  //   masters: ["Kim Diana"]
  // });
  // client.save(function(err, client){
  //   if(err) throw err;
  //   console.dir("Client saved");
  // });

exports.create = function(req, res){
  var client = req.body;
  // console.log(client);
  res.jsonp(client);
}