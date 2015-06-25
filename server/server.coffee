class @Server

	constructor: ->

		process.env.MAIL_URL = "smtp://dev.scottashmore%40gmail.com:13-cheese-ass@smtp.gmail.com:465/"

		# Create timer to check if one hour has passed
		_interval 1000, => do @checkTime

		if RaceList.find().count() is 0

			do @initRaces


	initRaces: ->

		# Create initial races
		for i in [ 0...6 ]
			
			RaceList.insert
				live      : false
				length    : 5
				users     : []
				createdAt : new Date


	checkTime: =>

		time = new Date
		mins = do time.getMinutes
		mins = ( 59 - mins ) % 2
		secs = do time.getSeconds
		
		# Convert seconds to count down from 60 & if seconds is 60, make it 0
		if secs != 60
		
			secs = ( 59 - secs ) % 60
		
		else

			secs = 0
		
		# Create array to hold mins and time
		time = [ Number( mins ), Number( secs ) ]

		# console.log time

		# Send email to users 15 minutes in advance of upcoming race
		# if mins is 15 and secs is 0

		# 	do @sendEmail
		
		# If one hour has passed
		if mins is 0 and secs is 0

			do @updatePoints
			do @updateRaces


	sendEmail: ->

		for id in RaceList.find().fetch()[1].users

			user    = Meteor.users.findOne( _id: id ).services.facebook
			name    = user.first_name
			to      = user.email
			from    = 'dev.scottashmore@gmail.com'
			subject = 'Your race begins in 15 minutes!'
			text    = "Hi #{name}! This is a reminder that a race you're entered in will start in 15 minutes. Get ready and we hope you enjoy yourself!"

			Meteor.call 'sendEmail', to, from, subject, text


	updatePoints: ->

		# Get the array of user id's form the current live race
		ids = RaceList.find( live: true ).fetch()[0]?.users

		if ids?.length > 0

			query =
				sort: 'profile.distance': -1

			# Fetch the users in the current race sorted by distance
			sortedUsers = Meteor.users.find( _id: $in: ids, query ).fetch()

			# Create variables for the top 3 positions
			firstPlace  = sortedUsers[0]?._id
			secondPlace = sortedUsers[1]?._id
			thirdPlace  = sortedUsers[2]?._id

			# Call the Meteor method to update users points
			Meteor.call 'updatePoints', firstPlace, secondPlace, thirdPlace


	updateRaces: ->

		# Reset the coords to an empty array
		Meteor.call 'resetCoords'

		# Remove the finished race
		Meteor.call 'removeLiveRace'

		# Set the next race to live
		Meteor.call 'setLiveRace'

		# Add another race to the collection
		Meteor.call 'insertNewRace'
