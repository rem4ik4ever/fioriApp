app.directive 'calendar', ['DateService',(DateService)->
  {
    restrict : "EA"
    template : '<div id="datepicker"></div>'
    link : (scope)->
      selected_date = ""
      $( "#datepicker" ).datepicker({
        inline: true
        showOtherMonths: true
        dateFormat: 'yy-mm-dd'
        minDate: new Date()
        maxDate: '+1y'
        dayNamesMin: [ "Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс" ]
        monthNames: [ "Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь" ]
        onSelect: (date, obj)->
          # selected_date =  new Date(date)
          DateService.setDate date
          # console.log selected_date
          console.log DateService.getDate()
      })
  }
]