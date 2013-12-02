app.controller 'dataCtrl', ['$scope','dateService','dataService', (scope, dateService, dataService)->
	scope.showDate = ()->
		console.log scope.begin + " " + scope.end
	setData = (data)->
		scope.data = data 
		getTotals()
	scope.find = ()->
		if angular.isDefined scope.begin and angular.isDefined scope.end 
			scope.sum = [0,0,0,0]
			# console.log scope.end
			start = new Date scope.begin
			end = new Date scope.end
			end.setHours 23
			params = 
				start_date: start
				end_date: end
			request = dataService.byDate params
			request.success (data)->
				console.log data
				setData data

		else 
			alert 'Пожалуйста заполните дату начала и конца'
	scope.totalSpendings = (one, two)->
		(Number) one + (Number) two
	getTotals = ()->
		for info in scope.data
			if angular.isDefined info.payed
				scope.sum[0] += info.payed
			if angular.isDefined info.forSaloon
				scope.sum[1] += info.forSaloon
			if angular.isDefined info.masterIncome
				scope.sum[2] += info.masterIncome
			if angular.isDefined info.materials
				scope.sum[3] += info.materials
		tmp = []
		for sum in scope.sum
			tmp.push sum.toFixed(2)
		scope.sum = tmp
		console.log scope.sum
]