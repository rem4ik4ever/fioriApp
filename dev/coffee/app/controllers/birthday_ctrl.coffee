app.controller 'birthdayCtrl', ['$scope','clientsService', (scope, clientsService)->
	
	bdsort = (a,b)->
		bdayA = new Date(a.birthday)
		bdayB = new Date(b.birthday)
		if bdayA.getMonth() < bdayB.getMonth()
			return -1
		else if bdayA.getMonth() is bdayB.getMonth()
			if bdayA.getDate() < bdayB.getDate()
				return -1
			else return 1
		else 
			return 1
	
	showBday = (date)->
		bday = new Date(date)
		months = ["Янв", "Фев", "Мар", "Апр", "Май", "Июнь", "Июль", "Авг", "Сент", "Окт", "Ноя", "Дек"]
		return bday.getDate() + " " + months[bday.getMonth()]

	request = clientsService.all()
	request.success (data)->
		clients = data
		today = new Date()
		for client in clients
			d = new Date(client.birthday)
			if d.getMonth() > today.getMonth()
				clients.splice(clients.indexOf(client), 1)
			else if d.getMonth() is today.getMonth()
				if d.getDate() > today.getDate()
					clients.splice(clients.indexOf(client), 1)
		console.log clients
		clients.sort(bdsort)
		for client in clients
			client.birthday = showBday(client.birthday)
		scope.birthday_list = clients
		console.log scope.birthday_list
	request.error (data)->
		console.log 'unable to get clients'


]