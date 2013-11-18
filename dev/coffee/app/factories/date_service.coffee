app.factory 'dateService', [()->
  noteDay = new Date()
  noteDay.setHours 0
  noteDay.setMinutes 0
  noteDay.setSeconds 0
  noteDay.setMilliseconds 0
  return {
    getDate: ()->
      noteDay
    setDate: (date)->
      noteDay = new Date date
  }
]