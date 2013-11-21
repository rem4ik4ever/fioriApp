app.controller 'dataCtrl', ['$scope','dateService', (scope, dateService)->
	end = new Date()
	begin = end
	begin.setDate 0
	begin.setHours 0
	begin.setMinutes 0
	begin.setSeconds 0
	console.log end
	console.log begin
]