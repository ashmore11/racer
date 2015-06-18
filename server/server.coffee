class @Server

	constructor: ->

		# Create timer to check if one hour has passed
		Meteor.setInterval @checkTime, 1000

		do @initRaces if RaceList.find().fetch().length is 0


	initRaces: ->

		# Create initial races
		for i in [ 0...5 ]
			
			RaceList.insert
				index : i
				live  : false
				users : []


	checkTime: =>

		time = new Date
		mins = do time.getMinutes
		mins = ( 59 - mins ) % 60
		secs = do time.getSeconds
		
		# Convert seconds to count down from 60 & if seconds is 60, make it 0
		if secs != 60
			secs = ( 59 - secs ) % 60
		else
			secs = 0
		
		# Create array to hold mins and time
		time = [ Number( mins ), Number( secs ) ]
		
		# If one hour has passed
		if mins is 0 and secs is 0

			do @updateRaces


	updateRaces: ->

		# Remove finished race
		RaceList.remove live: true

		# Set next race live boolean
		RaceList.update RaceList.find().fetch()[0]._id, $set: live: true

		# Update the index for the next races
		RaceList.find().fetch().forEach ( race ) ->

			RaceList.update race._id, $inc: index: -1

		# Insert next race
		RaceList.insert
			index : RaceList.find().fetch().length - 1
			live  : false
			users : []