$(function() {
  $( "#datepicker" ).datepicker({
    inline: true,
    showOtherMonths: true,
    dateFormat: 'yy-mm-dd',
    minDate: new Date(),
    maxDate: '+1y',
    dayNamesMin: [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс" ],
    monthNames: [ "Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь" ]
  });
});