(function() {
  var app;

  app = angular.module('fioriApp', ['ngRoute']);

  app.config([
    '$routeProvider', function(routeProvider) {
      routeProvider.when('/', {
        controller: 'notesCtrl',
        templateUrl: 'views/notes.html'
      });
      routeProvider.when('/addnote', {
        controller: 'NoteCtrl',
        templateUrl: 'views/note.html'
      });
      routeProvider.when('/note/edit/:id', {
        controller: 'NoteCtrl',
        templateUrl: 'views/note.html'
      });
      routeProvider.when('/addclient', {
        controller: 'ClientCtrl',
        templateUrl: 'views/client.html',
        resolve: {
          param: function() {
            return {
              type: 'add',
              client: null
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
            request = clientsService.all();
            return request.success(function(data) {
              return data;
            });
          }
        }
      });
      routeProvider.when('/clients/edit/:id', {
        controller: 'ClientCtrl',
        templateUrl: 'views/client.html',
        resolve: {
          param: function(clientsService) {
            return {
              type: 'edit',
              client: clientsService.getEdit()
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
      return routeProvider.when('/masters', {
        controller: 'mastersCtrl',
        templateUrl: 'views/masterslist.html',
        resolve: {
          masters: function(mastersService) {
            var request;
            request = mastersService.all();
            return request.success(function(data) {
              return data;
            });
          }
        }
      });
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

  app.factory('DateService', [
    function() {
      var noteDay;
      noteDay = new Date;
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

  app.controller('ClientCtrl', [
    '$scope', 'clientsService', 'param', function(scope, clientsService, param) {
      var client, date, day, month, update, year;
      console.log("add user ctrl");
      scope.masters = ["Ким Диана", "Дмитрий Ногиев"];
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

  app.controller('notesCtrl', [
    '$scope', function(scope) {
      return console.log("notes ctrl");
    }
  ]);

  app.controller('addNoteCtrl', [
    '$scope', function(scope) {
      return console.log("add note ctrl");
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
    '$scope', 'DateService', 'clientsService', function(scope, DateService, clientsService) {
      var months;
      console.log("note ctrl");
      months = ["Января", "Февраля", "Марта", "Апреля", "Мая", "Июня", "Июля", "Августа", "Сентября", "Октября", "Ноября", "Декабря"];
      scope.noteDate = function() {
        var date, day, month, year;
        date = DateService.getDate();
        year = date.getFullYear();
        month = date.getMonth();
        if (month < 10) {
          month = "0" + month;
        }
        day = date.getDate();
        if (day < 10) {
          day = "0" + day;
        }
        return day + " " + months[month] + " " + year + " года";
      };
      scope.tryFind = function() {
        var param, part, request;
        part = scope.client_name.split(" ");
        if (part.length === 1) {
          param = {
            surname: part[0]
          };
        } else if (part.length === 2) {
          param = {
            surname: part[0],
            name: part[1]
          };
        }
        request = clientsService.find(param);
        return request.success(function(data) {
          return scope.clientsFound = data;
        });
      };
    }
  ]);

  app.directive('calendar', [
    'DateService', function(DateService) {
      return {
        restrict: "EA",
        template: '<div id="datepicker"></div>',
        link: function(scope) {
          var selected_date;
          selected_date = "";
          return $("#datepicker").datepicker({
            inline: true,
            showOtherMonths: true,
            dateFormat: 'yy-mm-dd',
            minDate: new Date(),
            maxDate: '+1y',
            dayNamesMin: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
            monthNames: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"],
            onSelect: function(date, obj) {
              DateService.setDate(date);
              return console.log(DateService.getDate());
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
