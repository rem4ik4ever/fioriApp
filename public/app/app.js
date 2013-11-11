(function() {
  var app;

  app = angular.module('fioriApp', ['ngRoute']);

  app.config([
    '$routeProvider', function(routeProvider) {
      routeProvider.when('/', {
        controller: 'notesCtrl',
        templateUrl: 'views/notes.html'
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
      return routeProvider.when('/clients/edit/:id', {
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
    }
  ]);

  app.factory('clientsService', [
    '$http', '$location', function(http, location) {
      var client_to_edit;
      client_to_edit = {};
      return {
        create: function(client) {
          var result;
          console.log("create called");
          return result = http.post('/api/clients/create', client);
        },
        all: function() {
          var result;
          console.log("all clients");
          return result = http.get('/api/clients/all');
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
        }
      };
    }
  ]);

  app.controller('ClientCtrl', [
    '$scope', 'clientsService', 'param', function(scope, clientsService, param) {
      var animation, client, date, day, month, update, year;
      console.log("add user ctrl");
      animation = false;
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

  app.directive('calendar', function() {
    return {
      restrict: "EA",
      template: '<div id="datepicker"></div>',
      link: function(scope) {
        return $("#datepicker").datepicker({
          inline: true,
          showOtherMonths: true,
          dateFormat: 'yy-mm-dd',
          minDate: new Date(),
          maxDate: '+1y',
          dayNamesMin: ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"],
          monthNames: ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"],
          onSelect: function(date, obj) {
            var testdate;
            console.log(date);
            testdate = new Date(date);
            return console.log(testdate);
          }
        });
      }
    };
  });

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
