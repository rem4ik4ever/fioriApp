(function() {
  var app, directives;

  app = angular.module('fioriApp', ['ngRoute']);

  app.config([
    '$routeProvider', function(routeProvider) {
      routeProvider.when('/', {
        controller: 'notesCtrl',
        templateUrl: 'views/notes.html'
      });
      return routeProvider.when('/addclient', {
        controller: 'addUserCtrl',
        templateUrl: 'views/newclient.html'
      });
    }
  ]);

  app.controller('addUserCtrl', [
    '$scope', function(scope) {
      var animation, client;
      console.log("add user ctrl");
      animation = false;
      scope.masters = ["Ким Диана", "Дмитрий Ногиев"];
      client = function() {
        return {
          savings: 0,
          discount: 0,
          phone: [
            {
              type: "мобильный",
              number: ""
            }, {
              type: "домашний",
              number: ""
            }
          ],
          masters: []
        };
      };
      scope.client = new client;
      scope.saveClient = function() {
        console.log("Saving user:");
        scope.client.reg_date = new Date();
        return console.log(scope.client);
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
      scope.setMaster = function() {
        return scope.client.master = scope.clientmaster;
      };
      scope.cleanFields = function() {
        scope.client = new client;
        scope.mobilephone = "";
        scope.homephone = "";
        return console.log(scope.client);
      };
      scope.addMaster = function(master) {
        if (master !== void 0 && master.length > 0) {
          scope.client.masters.push(master);
        }
        return console.log(scope.client.masters);
      };
      scope.removeMaster = function(master) {
        return scope.client.masters.splice(scope.client.masters.indexOf(master), 1);
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

  directives = {};

  directives.calendar = function() {
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
  };

  app.directive(directives);

}).call(this);
