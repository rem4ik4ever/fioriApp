(function() {
  var app;

  app = angular.module('fioriApp', ['ngRoute', 'ngAnimate']);

  app.config([
    '$routeProvider', function(routeProvider) {
      routeProvider.when('/', {
        controller: 'notesCtrl',
        templateUrl: 'views/notes.html',
        resolve: {
          notes: function(notesService, dateService) {
            var params, request, today, tomorrow;
            today = dateService.getDate();
            today.setHours(0);
            today.setMinutes(0);
            tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000));
            params = {
              start_date: today,
              end_date: tomorrow
            };
            console.log(params);
            return request = notesService.byDate(params);
          }
        }
      });
      routeProvider.when('/addnote', {
        controller: 'NoteCtrl',
        templateUrl: 'views/note.html',
        resolve: {
          param: function(mastersService) {
            var request;
            request = mastersService.all();
            return {
              type: 'add',
              masters: request
            };
          }
        }
      });
      routeProvider.when('/notes/edit/:note', {
        controller: 'NoteCtrl',
        templateUrl: 'views/note.html',
        resolve: {
          param: function($route, notesService) {
            var id;
            id = $route.current.params.note;
            console.log(id);
            return {
              type: 'edit',
              note: notesService.getEdit(id)
            };
          }
        }
      });
      routeProvider.when('/addclient', {
        controller: 'ClientCtrl',
        templateUrl: 'views/client.html',
        resolve: {
          param: function(mastersService) {
            return {
              type: 'add',
              client: null,
              masters: mastersService.all()
            };
          }
        }
      });
      routeProvider.when('/clients', {
        controller: 'clientsCtrl',
        templateUrl: 'views/clientslist.html',
        resolve: {
          clients: function(clientsService) {
            var request;
            return request = clientsService.all();
          }
        }
      });
      routeProvider.when('/clients/edit/:id', {
        controller: 'ClientCtrl',
        templateUrl: 'views/client.html',
        resolve: {
          param: function(clientsService, mastersService) {
            return {
              type: 'edit',
              client: clientsService.getEdit(),
              masters: mastersService.all()
            };
          }
        }
      });
      routeProvider.when('/addmaster', {
        controller: 'MasterCtrl',
        templateUrl: 'views/master.html',
        resolve: {
          param: function() {
            return {
              type: 'add',
              master: null
            };
          }
        }
      });
      routeProvider.when('/masters/edit/:id', {
        controller: 'MasterCtrl',
        templateUrl: 'views/master.html',
        resolve: {
          param: function(mastersService) {
            return {
              type: 'edit',
              master: mastersService.getEdit()
            };
          }
        }
      });
      routeProvider.when('/masters', {
        controller: 'mastersCtrl',
        templateUrl: 'views/masterslist.html',
        resolve: {
          masters: function(mastersService) {
            var request;
            return request = mastersService.all();
          }
        }
      });
      return routeProvider.when('/data', {
        controller: 'dataCtrl',
        templateUrl: 'views/data.html'
      });
    }
  ]);

  app.factory('accountService', [
    '$http', function(http) {
      return {
        create: function(account) {
          var request;
          return request = http.post('/api/account', account);
        }
      };
    }
  ]);

  app.factory('clientsService', [
    '$http', '$location', function(http, location) {
      var client_to_edit;
      client_to_edit = {};
      return {
        create: function(client) {
          var result;
          return result = http.post('/api/clients', client);
        },
        all: function() {
          var result;
          return result = http.get('/api/clients');
        },
        edit: function(client) {
          client_to_edit = client;
          return location.path('/clients/edit/' + client._id);
        },
        getEdit: function() {
          return client_to_edit;
        },
        update: function(client) {
          var result;
          return result = http.put('/api/clients/' + client._id, client);
        },
        "delete": function(id) {
          var result;
          return result = http["delete"]('/api/clients/' + id);
        },
        find: function(param) {
          var result;
          return result = http.post('/api/clients/find', param);
        }
      };
    }
  ]);

  app.factory('dataService', [
    '$http', function(http) {
      return {
        byDate: function(params) {
          var request;
          return request = http.post('/api/account/bydate', params);
        }
      };
    }
  ]);

  app.factory('dateService', [
    function() {
      var noteDay;
      noteDay = new Date();
      noteDay.setHours(0);
      noteDay.setMinutes(0);
      noteDay.setSeconds(0);
      noteDay.setMilliseconds(0);
      return {
        getDate: function() {
          return noteDay;
        },
        setDate: function(date) {
          return noteDay = new Date(date);
        }
      };
    }
  ]);

  app.factory('mastersService', [
    '$http', '$location', function(http, location) {
      var master_to_edit;
      master_to_edit = {};
      return {
        create: function(master) {
          var result;
          return result = http.post('/api/masters', master);
        },
        update: function(master) {
          var result;
          return result = http.put('/api/masters/' + master._id, master);
        },
        edit: function(master) {
          master_to_edit = master;
          return location.path('/masters/edit/' + master._id);
        },
        getEdit: function() {
          return master_to_edit;
        },
        "delete": function(id) {
          var result;
          return result = http["delete"]('/api/masters/' + id);
        },
        all: function() {
          var result;
          return result = http.get('/api/masters');
        }
      };
    }
  ]);

  app.factory('notesService', [
    '$http', '$location', function(http, location) {
      var note_to_edit;
      note_to_edit = {};
      return {
        save: function(note) {
          var result;
          return result = http.post('/api/notes', note);
        },
        all: function() {
          var result;
          return result = http.get('/api/notes');
        },
        byDate: function(params) {
          var result;
          return result = http.post('/api/notes/bydate', params);
        },
        masterNotes: function(params) {
          var result;
          return result = http.post('/api/notes/bydatemaster', params);
        },
        getEdit: function(id) {
          var request;
          return request = http.get("/api/notes/edit?q=" + id);
        },
        update: function(note) {
          var request;
          return request = http.put("/api/notes/" + note.id, note);
        },
        "delete": function(id) {
          var request;
          return request = http["delete"]("/api/notes/" + id);
        }
      };
    }
  ]);

  app.controller('birthdayCtrl', [
    '$scope', 'clientsService', '$interval', function(scope, clientsService, $interval) {
      var bdsort, getBDays, showBday;
      bdsort = function(a, b) {
        var bdayA, bdayB;
        bdayA = new Date(a.birthday);
        bdayB = new Date(b.birthday);
        if (bdayA.getMonth() < bdayB.getMonth()) {
          return -1;
        } else if (bdayA.getMonth() === bdayB.getMonth()) {
          if (bdayA.getDate() < bdayB.getDate()) {
            return -1;
          } else {
            return 1;
          }
        } else {
          return 1;
        }
      };
      showBday = function(date) {
        var bday, months;
        bday = new Date(date);
        months = ["Янв", "Фев", "Мар", "Апр", "Май", "Июнь", "Июль", "Авг", "Сент", "Окт", "Ноя", "Дек"];
        return bday.getDate() + " " + months[bday.getMonth()];
      };
      getBDays = function() {
        var request;
        request = clientsService.all();
        request.success(function(data) {
          var client, clients, d, today, _i, _j, _len, _len1;
          console.log("success");
          clients = data;
          console.log(clients);
          today = new Date();
          for (_i = 0, _len = clients.length; _i < _len; _i++) {
            client = clients[_i];
            if (client === !void 0) {
              d = new Date(client.birthday);
              if (d.getMonth() > today.getMonth()) {
                clients.splice(clients.indexOf(client), 1);
              } else if (d.getMonth() === today.getMonth()) {
                if (d.getDate() > today.getDate()) {
                  clients.splice(clients.indexOf(client), 1);
                }
              }
            }
          }
          console.log(clients);
          clients.sort(bdsort);
          for (_j = 0, _len1 = clients.length; _j < _len1; _j++) {
            client = clients[_j];
            client.birthday = showBday(client.birthday);
          }
          scope.birthday_list = clients;
          return console.log(scope.birthday_list);
        });
        return request.error(function(data) {
          return console.log('unable to get clients');
        });
      };
      getBDays();
      console.log("starting");
      return $interval(function() {
        return getBDays();
      }, 60000);
    }
  ]);

  app.controller('ClientCtrl', [
    '$scope', 'clientsService', 'param', function(scope, clientsService, param) {
      var client, date, day, month, update, year;
      console.log("add user ctrl");
      param.masters.success(function(data) {
        return scope.masters = data;
      });
      param.masters.error(function(err) {
        return console.log(err);
      });
      scope.active = true;
      client = function() {
        return {
          savings: 0,
          discount: 0,
          phone: [
            {
              phonetype: "мобильный",
              number: ""
            }, {
              phonetype: "домашний",
              number: ""
            }
          ],
          masters: [],
          services: []
        };
      };
      if (param.type === 'add') {
        scope.client = new client;
      } else {
        scope.client = param.client;
        console.log(scope.client);
        scope.mobilephone = scope.client.phone[0].number;
        scope.homephone = scope.client.phone[1].number;
        date = new Date(scope.client.birthday);
        year = date.getFullYear();
        month = date.getMonth() + 1;
        day = date.getDate();
        if (month > 9) {
          scope.birthday = year + '-' + month + '-' + day;
        } else {
          scope.birthday = year + '-0' + month + '-' + day;
        }
        console.log(scope.birthday);
      }
      scope.saveClient = function() {
        var response;
        if (param.type === 'add') {
          scope.client.reg_date = new Date();
          response = clientsService.create(scope.client);
          response.success(function(data) {
            console.log(data);
            return scope.active = false;
          });
          return response.error(function() {
            return console.log("Error");
          });
        } else {
          return update();
        }
      };
      scope.setPhone = function(index) {
        if (index === 0) {
          return scope.client.phone[index].number = scope.mobilephone;
        } else {
          return scope.client.phone[index].number = scope.homephone;
        }
      };
      scope.setBirthday = function() {
        return scope.client.birthday = new Date(scope.birthday);
      };
      scope.cleanFields = function() {
        scope.client = new client;
        scope.mobilephone = "";
        scope.homephone = "";
        return scope.birthday = "";
      };
      scope.addMaster = function(master) {
        if (master !== void 0 && master.length > 0) {
          if (scope.client.masters.indexOf(master) === -1) {
            return scope.client.masters.push(master);
          }
        }
      };
      scope.removeMaster = function(master) {
        return scope.client.masters.splice(scope.client.masters.indexOf(master), 1);
      };
      scope.getAll = function() {
        var result;
        result = clientsService.all();
        result.success(function(data) {
          return console.log(data);
        });
        return result.error(function() {
          return console.log("error");
        });
      };
      scope.restart = function() {
        scope.active = true;
        return scope.cleanFields();
      };
      scope.formType = function() {
        if (param.type === 'add') {
          return true;
        } else {
          return false;
        }
      };
      scope.addService = function() {
        if (scope.service.service_type && scope.service.material) {
          console.log(scope.service);
          if (scope.client.services === void 0) {
            scope.client.services = [];
          }
          scope.client.services.push(scope.service);
          return scope.service = {};
        }
      };
      scope.removeService = function(index) {
        return scope.client.services.splice(index, 1);
      };
      update = function() {
        var request;
        request = clientsService.update(scope.client);
        request.success(function() {
          return scope.updated = true;
        });
        return request.error(function() {
          return console.log("Error while updating");
        });
      };
      scope.remove = function() {
        var answer, request;
        answer = confirm("Удалить клиента " + scope.client.surname + " " + scope.client.name);
        if (answer) {
          request = clientsService["delete"](scope.client._id);
          request.error(function() {
            return console.log("Error while deleting");
          });
          return scope.removed = true;
        }
      };
      scope.hideIt = function() {
        if (scope.updated || scope.removed) {
          return true;
        } else {
          return false;
        }
      };
      scope.checkCard = function(num) {
        if (num !== -1) {
          return num;
        } else {
          return "- ";
        }
      };
    }
  ]);

  app.controller('clientsCtrl', [
    '$scope', 'clients', 'clientsService', function(scope, clients, clientsService) {
      scope.clients = clients.data;
      console.log(clients);
      scope.showphone = 0;
      scope.types = ['Мобильный телефон', 'Домашний телефон'];
      scope.cur_type = "Мобильный телефон";
      scope.changePhone = function() {
        console.log("changing" + scope.phone);
        if (scope.cur_type === 'Мобильный телефон') {
          return scope.showphone = 0;
        } else {
          return scope.showphone = 1;
        }
      };
      return scope.editUser = function(client) {
        return clientsService.edit(client);
      };
    }
  ]);

  app.controller('addNoteCtrl', [
    '$scope', function(scope) {
      return console.log("add note ctrl");
    }
  ]);

  app.controller('dataCtrl', [
    '$scope', 'dateService', 'dataService', function(scope, dateService, dataService) {
      var getTotals, setData;
      scope.showDate = function() {
        return console.log(scope.begin + " " + scope.end);
      };
      setData = function(data) {
        scope.data = data;
        return getTotals();
      };
      scope.find = function() {
        var end, params, request, start;
        if (angular.isDefined(scope.begin && angular.isDefined(scope.end))) {
          scope.sum = [0, 0, 0, 0];
          start = new Date(scope.begin);
          end = new Date(scope.end);
          end.setHours(23);
          params = {
            start_date: start,
            end_date: end
          };
          request = dataService.byDate(params);
          return request.success(function(data) {
            console.log(data);
            return setData(data);
          });
        } else {
          return alert('Пожалуйста заполните дату начала и конца');
        }
      };
      scope.totalSpendings = function(one, two) {
        return Number(one + Number(two));
      };
      return getTotals = function() {
        var info, sum, tmp, _i, _j, _len, _len1, _ref, _ref1;
        _ref = scope.data;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          info = _ref[_i];
          if (angular.isDefined(info.payed)) {
            scope.sum[0] += info.payed;
          }
          if (angular.isDefined(info.forSaloon)) {
            scope.sum[1] += info.forSaloon;
          }
          if (angular.isDefined(info.masterIncome)) {
            scope.sum[2] += info.masterIncome;
          }
          if (angular.isDefined(info.materials)) {
            scope.sum[3] += info.materials;
          }
        }
        tmp = [];
        _ref1 = scope.sum;
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          sum = _ref1[_j];
          tmp.push(sum.toFixed(2));
        }
        scope.sum = tmp;
        return console.log(scope.sum);
      };
    }
  ]);

  app.controller('MasterCtrl', [
    '$scope', 'mastersService', 'param', function(scope, mastersService, param) {
      var date, day, fire, hire, master, month, update, year;
      scope.active = true;
      scope.updated = false;
      scope.removed = false;
      master = function() {
        return {
          phone: [
            {
              phonetype: "мобильный",
              number: ""
            }, {
              phonetype: "домашний",
              number: ""
            }
          ],
          spec: []
        };
      };
      if (param.type === 'add') {
        scope.master = new master;
      } else {
        scope.master = param.master;
        console.log(scope.master);
        scope.mobilephone = scope.master.phone[0].number;
        scope.homephone = scope.master.phone[1].number;
        date = new Date(scope.master.birthday);
        year = date.getFullYear();
        month = date.getMonth() + 1;
        day = date.getDate();
        if (day < 10) {
          day = "0" + day;
        }
        if (month < 10) {
          month = "0" + month;
        }
        scope.birthday = year + '-' + month + '-' + day;
        hire = new Date(scope.master.hiredate);
        year = hire.getFullYear();
        month = hire.getMonth() + 1;
        day = hire.getDate();
        if (day < 10) {
          day = "0" + day;
        }
        if (month < 10) {
          month = "0" + month;
        }
        scope.hiredate = year + '-' + month + '-' + day;
        fire = new Date(scope.master.firedate);
        year = fire.getFullYear();
        month = fire.getMonth() + 1;
        day = fire.getDate();
        if (day < 10) {
          day = "0" + day;
        }
        if (month < 10) {
          month = "0" + month;
        }
        scope.firedate = year + '-' + month + '-' + day;
        console.log(scope.birthday);
        console.log(scope.hiredate);
        console.log(scope.firedate);
      }
      scope.saveMaster = function() {
        var response;
        if (param.type === 'add') {
          scope.master.reg_date = new Date();
          response = mastersService.create(scope.master);
          response.success(function(data) {
            console.log(data);
            return scope.active = false;
          });
          return response.error(function() {
            return console.log("Error");
          });
        } else {
          return update();
        }
      };
      scope.setPhone = function(index) {
        if (index === 0) {
          return scope.master.phone[index].number = scope.mobilephone;
        } else {
          return scope.master.phone[index].number = scope.homephone;
        }
      };
      scope.setBirthday = function() {
        return scope.master.birthday = new Date(scope.birthday);
      };
      scope.cleanFields = function() {
        scope.master = new master;
        scope.mobilephone = "";
        scope.homephone = "";
        scope.birthday = "";
        scope.hiredate = "";
        return scope.firedate = "";
      };
      scope.getAll = function() {
        var result;
        result = mastersService.all();
        result.success(function(data) {
          return console.log(data);
        });
        return result.error(function() {
          return console.log("error");
        });
      };
      scope.restart = function() {
        scope.active = true;
        return scope.cleanFields();
      };
      scope.formType = function() {
        if (param.type === 'add') {
          return true;
        } else {
          return false;
        }
      };
      update = function() {
        var request;
        request = mastersService.update(scope.master);
        request.success(function() {
          return scope.updated = true;
        });
        return request.error(function() {
          return console.log("Error while updating");
        });
      };
      scope.remove = function() {
        var answer, request;
        answer = confirm("Удалить мастера " + scope.master.surname + " " + scope.master.name);
        if (answer) {
          request = mastersService["delete"](scope.master._id);
          request.error(function() {
            return console.log("Error while deleting");
          });
          return scope.removed = true;
        }
      };
      scope.hideIt = function() {
        if (scope.updated || scope.removed) {
          return true;
        } else {
          return false;
        }
      };
      scope.setHiredate = function() {
        return scope.master.hiredate = new Date(scope.hiredate);
      };
      scope.setFiredate = function() {
        return scope.master.firedate = new Date(scope.firedate);
      };
      scope.addSpec = function() {
        if (scope.master.spec.indexOf(scope.spec) === -1) {
          scope.master.spec.push(scope.spec);
          return scope.spec = "";
        }
      };
      scope.removeSpec = function(index) {
        return scope.master.spec.splice(index, 1);
      };
    }
  ]);

  app.controller('mastersCtrl', [
    '$scope', 'masters', 'mastersService', function(scope, masters, mastersService) {
      scope.masters = masters.data;
      console.log(masters);
      scope.showphone = 0;
      scope.types = ['Мобильный телефон', 'Домашний телефон'];
      scope.cur_type = "Мобильный телефон";
      scope.changePhone = function() {
        console.log("changing" + scope.phone);
        if (scope.cur_type === 'Мобильный телефон') {
          return scope.showphone = 0;
        } else {
          return scope.showphone = 1;
        }
      };
      return scope.editUser = function(master) {
        return mastersService.edit(master);
      };
    }
  ]);

  app.controller('NoteCtrl', [
    '$scope', 'dateService', 'clientsService', 'notesService', 'param', function(scope, dateService, clientsService, notesService, param) {
      var clearFields, current_date, editnote, months, setNote, type;
      editnote = {};
      scope.active = false;
      scope.updated = false;
      type = param.type;
      console.log(type);
      current_date = dateService.getDate();
      scope.requireminutes = 60;
      if (param.type === 'add') {
        param.masters.success(function(data) {
          return scope.masters = data;
        });
      } else if (param.type === 'edit') {
        param.note.success(function(data) {
          editnote = data;
          return setNote();
        });
      }
      months = ["Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря"];
      scope.masterNotes = [];
      scope.intersection = false;
      scope.timeOfDate = function(date) {
        var minutes, res;
        res = new Date(date);
        minutes = res.getMinutes();
        if (minutes < 10) {
          minutes = "0" + minutes;
        }
        return res.getHours() + ":" + minutes;
      };
      scope.noteDate = function() {
        var date, day, month, year;
        date = dateService.getDate();
        year = date.getFullYear();
        month = date.getMonth();
        day = date.getDate();
        if (day < 10) {
          day = "0" + day;
        }
        return day + " " + months[month] + " " + year + " года";
      };
      scope.tryFind = function() {
        var part, request;
        if (scope.register_client !== "" && scope.register_client !== void 0) {
          part = scope.register_client.split(" ");
          param = {};
          if (part.length === 1) {
            param = {
              name: part[0]
            };
          } else if (part.length === 2) {
            param = {
              name: part[0],
              surname: part[1]
            };
          }
          request = clientsService.find(param);
          return request.success(function(data) {
            return scope.clientsFound = data;
          });
        } else {
          return scope.clientsFound = [];
        }
      };
      scope.setClient = function(index) {
        scope.client = scope.clientsFound[index];
        scope.register_client = scope.client.name + " " + scope.client.surname;
        scope.clientsFound = [];
        return scope.unregister_client = "";
      };
      scope.setUnregClient = function() {
        var part;
        scope.register_client = scope.unregister_client;
        if (scope.register_client !== void 0 && scope.register_client !== "") {
          part = scope.register_client.split(" ");
          scope.client = {
            name: "",
            surname: ""
          };
          if (part.length === 2) {
            scope.client.name = part[0];
            scope.client.surname = part[1];
          } else {
            scope.client.name = part[0];
          }
        }
        return console.log("unregister user");
      };
      scope.setMaster = function(master) {
        var params, request, start;
        scope.master = master;
        scope.findmaster = scope.master.name + " " + scope.master.surname;
        start = dateService.getDate();
        start.setHours(0);
        start.setMinutes(0);
        start.setSeconds(0);
        start.setMilliseconds(0);
        params = {
          start_date: dateService.getDate(),
          end_date: new Date(dateService.getDate().getTime() + (24 * 60 * 60 * 1000)),
          master: scope.master._id
        };
        console.log(params);
        request = notesService.masterNotes(params);
        request.success(function(data) {
          var note, _i, _len;
          if (param.type === 'edit') {
            console.log("in edit");
            for (_i = 0, _len = data.length; _i < _len; _i++) {
              note = data[_i];
              if (!_.isEqual(note, editnote)) {
                scope.masterNotes.push(note);
              }
            }
          } else {
            console.log("in masters");
            scope.masterNotes = data;
          }
          return console.log(scope.masterNotes);
        });
        return request.error(function(err) {
          return console.log(err);
        });
      };
      scope.getMasterNotes = function() {
        return scope.masterNotes;
      };
      clearFields = function() {
        scope.client = {};
        scope.register_client = "";
        scope.unregister_client = "";
        scope.hours = "";
        scope.minutes = "";
        scope.service = "";
        scope.master = "";
        scope.findmaster = "";
        return scope.requireminutes = 60;
      };
      scope.mins = function(mins) {
        if (mins < 10) {
          return "0" + mins;
        } else {
          return mins;
        }
      };
      scope.checkInter = function(note) {
        var endTime, minutes, mn, noteEndTime, noteStartTime, startTime, time;
        if (note.time === editnote.time) {
          return "editable";
        }
        time = new Date(note.time);
        minutes = note.minutes;
        noteStartTime = time.getHours() + (time.getMinutes() / 100);
        noteEndTime = Math.floor(time.getHours() + (time.getMinutes() + note.minutes) / 60) + ((time.getMinutes() + note.minutes - (Math.floor((time.getMinutes() + note.minutes) / 60) * 60)) / 100);
        startTime = scope.hours + (scope.minutes / 100);
        mn = 60;
        if (angular.isDefined(scope.requireminutes && scope.requireminutes !== null)) {
          mn = scope.requireminutes;
        }
        endTime = Math.floor(scope.hours + (scope.minutes + mn) / 60) + ((scope.minutes + mn - (Math.floor((scope.minutes + mn) / 60) * 60)) / 100);
        if (noteStartTime <= startTime && startTime <= noteEndTime) {
          scope.intersection = true;
          return "intersection";
        } else if (noteStartTime <= endTime && endTime <= noteEndTime) {
          scope.intersection = true;
          return "intersection";
        } else {
          return "";
        }
      };
      scope.unTill = function(note) {
        var hours, minutes, time;
        time = new Date(note.time);
        hours = Math.floor(time.getHours() + (time.getMinutes() + note.minutes) / 60);
        minutes = time.getMinutes() + note.minutes - (Math.floor((time.getMinutes() + note.minutes) / 60) * 60);
        if (minutes < 9) {
          minutes = "0" + minutes;
        }
        return hours + ":" + minutes;
      };
      scope.timeChange = function() {
        return scope.intersection = false;
      };
      scope.saveNote = function() {
        var note, reg_date, request;
        if (scope.intersection) {
          alert("Существует совпадение по времени");
          return;
        }
        note = {
          client: {},
          master: "",
          service: "",
          time: "",
          minutes: ""
        };
        reg_date = dateService.getDate();
        reg_date.setHours(scope.hours);
        reg_date.setMinutes(scope.minutes);
        reg_date.setSeconds(0);
        if (scope.unregister_client !== void 0 && scope.unregister_client !== "") {
          note.client.name = scope.unregister_client;
        } else {
          note.client.name = scope.register_client;
          note.client.id = scope.client._id;
        }
        note.master = scope.master._id;
        note.service = scope.service;
        note.time = reg_date;
        if (scope.requireminutes !== void 0 && scope.requireminutes !== "") {
          note.minutes = scope.requireminutes;
        } else {
          note.minutes = 60;
        }
        if (type === 'add') {
          console.log("add");
          console.log(note);
          request = notesService.save(note);
          request.success(function(data) {
            scope.active = true;
            return console.log(data);
          });
          return request.error(function(err) {
            return console.log(err);
          });
        } else if (type === 'edit') {
          note.id = editnote._id;
          request = notesService.update(note);
          request.success(function(data) {
            return scope.updated = true;
          });
          return request.error(function(err) {
            return console.log(err);
          });
        }
      };
      setNote = function() {
        console.log(editnote);
        scope.client = editnote.client;
        scope.register_client = scope.client.name;
        scope.master = editnote.master;
        scope.setMaster(scope.master);
        scope.findmaster = scope.master.name + " " + scope.master.surname;
        scope.service = editnote.service;
        scope.hours = new Date(editnote.time).getHours();
        return scope.minutes = new Date(editnote.time).getMinutes();
      };
      scope.newNote = function() {
        scope.active = false;
        scope.masterNotes = [];
        return clearFields();
      };
      scope.formState = function() {
        if (scope.active === true || scope.updated === true) {
          true;
        }
        return false;
      };
      scope.$watch(function() {
        return dateService.getDate();
      }, function(newDate) {
        var newOne, oldOne, params, request, today, tomorrow;
        newOne = newDate.getFullYear() + " " + newDate.getMonth() + " " + newDate.getDate();
        oldOne = current_date.getFullYear() + " " + current_date.getMonth() + " " + current_date.getDate();
        if (newOne !== oldOne) {
          console.log("not the same");
          today = newDate;
          today.setHours(0);
          today.setMinutes(0);
          tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000));
          if (angular.isDefined(scope.master)) {
            params = {
              start_date: today,
              end_date: tomorrow,
              master: scope.master._id
            };
            request = notesService.masterNotes(params);
            request.success(function(data) {
              return scope.masterNotes = data;
            });
            return request.error(function(err) {
              return console.log(err);
            });
          }
        } else {
          scope.oldDate = true;
          today = dateService.getDate();
          today.setHours(0);
          today.setMinutes(0);
          tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000));
          if (angular.isDefined(scope.master)) {
            params = {
              start_date: today,
              end_date: tomorrow,
              master: scope.master._id
            };
            request = notesService.masterNotes(params);
            request.success(function(data) {
              return scope.masterNotes = data;
            });
            return request.error(function(err) {
              return console.log(err);
            });
          }
        }
      });
    }
  ]);

  app.controller('notesCtrl', [
    '$scope', 'notes', 'notesService', 'dateService', 'accountService', 'clientsService', function(scope, notes, notesService, dateService, accountService, clientsService) {
      var account, checkDiscountIncrease, current_date, timeOfDate, yearMontDay;
      console.log("notes ctrl launched");
      scope.notes = notes.data;
      console.log(scope.notes);
      current_date = dateService.getDate();
      scope.oldDate = true;
      scope.payFormActive = false;
      account = function() {
        return {
          client: {
            name: "",
            id: "",
            savings: ""
          },
          master: "",
          masterIncome: "",
          payed: "",
          materials: "",
          forSaloon: "",
          date: ""
        };
      };
      yearMontDay = function(date) {
        var res;
        res = new Date(date);
        res.setHours(0);
        res.setMinutes(0);
        res.setSeconds(0);
        res.setMilliseconds(0);
        return res;
      };
      timeOfDate = function(date) {
        var minutes, res;
        res = new Date(date);
        minutes = res.getMinutes();
        if (minutes < 10) {
          minutes = "0" + minutes;
        }
        return res.getHours() + ":" + minutes;
      };
      scope.showTime = function(date) {
        var selDate, todayDate;
        todayDate = yearMontDay(new Date());
        selDate = yearMontDay(new Date(date));
        if (todayDate > selDate) {
          scope.oldDate = false;
        } else {
          scope.oldDate = true;
        }
        return timeOfDate(date);
      };
      scope.changeDate = function() {
        return console.log("changing date");
      };
      scope.getId = function(note) {
        return note._id;
      };
      scope.deleteNote = function(note) {
        var answer, id, request;
        console.log(note);
        id = note._id;
        answer = confirm("Удалить запись клиента " + note.client.name + "?");
        if (answer) {
          request = notesService["delete"](id);
          return request.success(function() {
            var notesrequest, params;
            params = {
              start_date: dateService.getDate(),
              end_date: new Date(dateService.getDate().getTime() + (24 * 60 * 60 * 1000))
            };
            notesrequest = notesService.byDate(params);
            return notesrequest.success(function(data) {
              scope.notes = data;
              return console.log(data);
            });
          });
        }
      };
      scope.finishService = function(note) {
        console.log("opening");
        scope.payFormActive = true;
        scope.selected_note = note;
        scope.price = 0;
        scope.materials = 0;
        scope.acc = new account();
        scope.acc.client = note.client;
        scope.acc.master = note.master._id;
        return scope.acc.date = note.time;
      };
      scope.closePayForm = function() {
        if (scope.payFormActive) {
          scope.payFormActive = false;
          return console.log("closing");
        }
      };
      scope.toPay = function() {
        var result;
        if (angular.isDefined(scope.price)) {
          if (scope.selected_note.client.id !== void 0 && scope.selected_note.client.id !== null) {
            result = (scope.price - (scope.price * scope.selected_note.client.id.discount / 100)).toFixed(2);
            return result;
          } else {
            return scope.price;
          }
        }
        return 0;
      };
      scope.mastersPrice = function() {
        if (angular.isDefined(scope.price) && angular.isDefined(scope.materials)) {
          if (scope.selected_note.client.id !== void 0 && scope.selected_note.client.id !== null) {
            scope.acc.masterIncome = (scope.price - (scope.price * scope.selected_note.client.id.discount / 100).toFixed(2) - scope.materials) * scope.selected_note.master.wageRate / 100;
            return scope.acc.masterIncome = scope.acc.masterIncome.toFixed(2);
          } else {
            scope.acc.masterIncome = (scope.price - scope.materials) * scope.selected_note.master.wageRate / 100;
            return scope.acc.masterIncome = scope.acc.masterIncome.toFixed(2);
          }
        }
      };
      scope.saloonPrice = function() {
        if (angular.isDefined(scope.price) && angular.isDefined(scope.materials)) {
          if (scope.selected_note.client.id !== void 0 && scope.selected_note.client.id !== null) {
            scope.acc.forSaloon = (scope.price - (scope.price * scope.selected_note.client.id.discount / 100).toFixed(2) - scope.materials) - scope.acc.masterIncome;
          } else {
            scope.acc.forSaloon = scope.price - scope.materials - scope.acc.masterIncome;
          }
          return scope.acc.forSaloon = scope.acc.forSaloon.toFixed(2);
        }
      };
      scope.clientSavings = function() {
        if (angular.isDefined(scope.price) && angular.isDefined(scope.materials)) {
          if (scope.selected_note.client.id !== void 0 && scope.selected_note.client.id !== null) {
            return scope.acc.client.savings = scope.price;
          } else {
            return 0;
          }
        }
      };
      checkDiscountIncrease = function(savings, discount) {
        console.log("Checking increase");
        if (savings > 25000) {
          if (discount < 10) {
            $.notify('Скидка увеличена до 10%!', 'success');
            return 10;
          }
        } else if (savings > 15000) {
          if (discount < 7) {
            $.notify('Скидка увеличена до 7%!', 'success');
            return 7;
          }
        } else if (savings > 10000) {
          if (discount < 5) {
            $.notify('Скидка увеличена до 5%!', 'success');
            return 5;
          }
        } else if (savings > 5000) {
          if (discount < 3) {
            $.notify('Скидка увеличена до 3%!', 'success');
            return 3;
          }
        }
      };
      scope.filterStatus = function() {
        var res;
        res = {};
        res.complete = false;
        if (scope.completeNote) {
          return res;
        } else {
          return void 0;
        }
      };
      scope.saveService = function() {
        var client, request;
        scope.acc.materials = scope.materials;
        client = scope.selected_note.client.id;
        if (scope.selected_note.client.id !== void 0 && scope.selected_note.client.id !== null) {
          scope.acc.payed = (scope.price - (scope.price * scope.selected_note.client.id.discount / 100)).toFixed(2);
          client.savings += scope.acc.client.savings;
          client.discount = checkDiscountIncrease(client.savings, client.discount);
        } else {
          scope.acc.payed = scope.price;
        }
        console.log(scope.acc);
        request = accountService.create(scope.acc);
        return request.success(function(data) {
          var note, reques;
          console.log(data);
          scope.payFormActive = false;
          scope.selected_note.complete = true;
          console.log(scope.selected_note);
          note = scope.selected_note;
          note.id = scope.selected_note._id;
          reques = notesService.update(note);
          return reques.success(function() {
            if (client !== void 0 && client !== null) {
              request = clientsService.update(client);
              request.success(function(data) {
                return console.log("Client savings updated");
              });
            }
            return console.log("Completed");
          });
        });
      };
      return scope.$watch(function() {
        return dateService.getDate();
      }, function(newDate) {
        var newOne, oldOne, params, request, today, tomorrow;
        newOne = newDate.getFullYear() + " " + newDate.getMonth() + " " + newDate.getDate();
        oldOne = current_date.getFullYear() + " " + current_date.getMonth() + " " + current_date.getDate();
        if (newOne !== oldOne) {
          console.log("not the same");
          today = newDate;
          today.setHours(0);
          today.setMinutes(0);
          tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000));
          params = {
            start_date: today,
            end_date: tomorrow
          };
          request = notesService.byDate(params);
          request.success(function(data) {
            return scope.notes = data;
          });
          return request.error(function(err) {
            return console.log(err);
          });
        } else {
          scope.oldDate = true;
          today = dateService.getDate();
          today.setHours(0);
          today.setMinutes(0);
          tomorrow = new Date(today.getTime() + (24 * 60 * 60 * 1000));
          params = {
            start_date: today,
            end_date: tomorrow
          };
          request = notesService.byDate(params);
          request.success(function(data) {
            return scope.notes = data;
          });
          return request.error(function(err) {
            return console.log(err);
          });
        }
      });
    }
  ]);

  app.directive('calendar', [
    'dateService', function(dateService) {
      return {
        restrict: "EA",
        template: '<div id="datepicker"></div>',
        link: function(scope, element, attrs) {
          var selected_date;
          selected_date = "";
          return $("#datepicker").datepicker({
            inline: true,
            showOtherMonths: true,
            dateFormat: 'yy-mm-dd',
            minDate: new Date('2013-11-14'),
            maxDate: '+1y',
            dayNamesMin: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
            monthNames: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"],
            onSelect: function(date, obj) {
              return dateService.setDate(date);
            }
          });
        }
      };
    }
  ]);

  app.directive('clock', function($timeout) {
    return {
      restrict: "A",
      link: function(scope, elem, attr) {
        var updatetime;
        updatetime = function() {
          return $timeout(function() {
            var hours, minutes, time;
            time = new Date();
            hours = time.getHours();
            minutes = time.getMinutes();
            if (minutes > 9) {
              scope.time = hours + ":" + minutes;
            } else {
              scope.time = hours + ":0" + minutes;
            }
            elem.text(scope.time);
            return updatetime();
          }, 1000);
        };
        updatetime();
      }
    };
  });

}).call(this);
