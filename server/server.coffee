class @Server

	constructor: ->

		# Create timer to check if one hour has passed
		Meteor.setInterval @check_time, 1000

		do @init_races if RaceList.find().fetch().length is 0


	init_races: ->

		# Create initial races
		for i in [ 0...6 ]
			
			RaceList.insert
				index: i
				users: []


	check_time: =>

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

		# console.log time
		
		# If one hour has passed
		if mins is 0 and secs is 0

			do @update_races


	update_races: ->

		# Remove finished race
		RaceList.remove RaceList.find().fetch()[0]._id

		# Update the index for the next races
		RaceList.find().fetch().forEach ( race ) ->

			RaceList.update race._id, $inc: index: -1

		# Insert next race
		RaceList.insert
			index: RaceList.find().fetch().length
			users: []