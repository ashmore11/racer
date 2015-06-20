class @Server

	constructor: ->

		process.env.MAIL_URL = "smtp://dev.scottashmore%40gmail.com:13-cheese-ass@smtp.gmail.com:465/"

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

		# Send email to users 15 minutes in advance of upcoming race
		if mins is 15 and secs is 0

			do @sendEmail
		
		# If one hour has passed
		if mins is 0 and secs is 0

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