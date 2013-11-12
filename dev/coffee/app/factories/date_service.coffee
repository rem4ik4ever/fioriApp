app.factory 'DateService', [()->
  noteDay = new Date
  return {
    getDate: ()->
      noteDay
    setDate: (date)->
      noteDay = new Date date
  }
]