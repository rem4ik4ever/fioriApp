(function() {
  var app, directives;

  app = angular.module('fioriApp', ['ngRoute']);

  app.config([
    '$routeProvider', function(routeProvider) {
      return routeProvider.when('/', {
        controller: 'mainCtrl',
        templateUrl: 'views/main.html'
      });
    }
  ]);

  app.controller('mainCtrl', [
    '$scope', function(scope) {
      return console.log("should work fine");
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
