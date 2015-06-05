class @Server

	constructor: ->

		console.log RaceList.find().fetch()[0]._id

		Meteor.setInterval () =>
		
			console.log do @check_time

		, 1000


	check_time: ->

		time = new Date
		mins = do time.getMinutes
		mins = ( 59 - mins ) % 30
		secs = do time.getSeconds
		
		if secs != 60
			secs = ( 59 - secs ) % 60
		else
			secs = 0
		
		time = [ Number( mins ), Number( secs ) ]
		
		if mins is 0 and secs is 0
			do @half_hour

		return time

	half_hour: ->

		console.log 'HALF HOUR'