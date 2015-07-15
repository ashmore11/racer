Meteor.methods

	###
	@_CLIENT_TASKS
	###

	updateUser: ( id, firstName ) ->

		unless @userId

			throw new Meteor.Error 'not:logged:in', 'You must be logged in'

		Meteor.users.update _id: @userId,

			$set: 
				
				'profile.id'        : id
				'profile.firstName' : firstName


	setUsernameAndPoints: ( name ) ->

		unless @userId

			throw new Meteor.Error 'not:logged:in', 'You must be logged in'

		Meteor.users.update _id: @userId, 
			
			$set:
				
				'profile.username': name
				'profile.points'  : 0


	getFriends: ->

		unless @userId

			throw new Meteor.Error 'not:logged:in', 'You must be logged in'

		user  = Meteor.users.findOne @userId
		token = user.services.facebook.accessToken

		url = "https://graph.facebook.com/v2.0/me/friends/?redirect=false"

		params =
			access_token: token

		data = HTTP.get( url, params: params ).data.data
		ids  = []
			
		ids.push item.id for item in data

		return ids


	updateCoords: ( lat, lon ) ->

		unless @userId

			throw new Meteor.Error 'not:logged:in', 'You must be logged in'

		Meteor.users.update _id: @userId,

			$addToSet:

				'profile.raceCoords': { lat: lat, lon: lon }

	
	updateDistance: ( distance ) ->

		unless @userId

			throw new Meteor.Error 'not:logged:in', 'You must be logged in'

		Meteor.users.update _id: @userId,

			$set: 

			 'profile.distance': distance


	updateUsersArray: ( id ) ->

		unless @userId

			throw new Meteor.Error 'not:logged:in', 'You must be logged in'

		race = RaceList.findOne id

		unless race
			
			throw new Meteor.Error 'get:race', 'The race was not found'

		if _.contains race.users, @userId
		
			RaceList.update _id: id, 

				$pull: 

					users: @userId

		else

			RaceList.update _id: id, 

				$addToSet: 

					users: @userId

	###
	@_SERVER_TASKS
	###

	updatePoints: ( id, points ) ->

		Meteor.users.update _id: id,

			$inc:

				'profile.points': points
				

	sendEmail: ( to, from, subject, text ) ->

		check [ to, from, subject, text ], [ String ]

		# Let other method calls from the same client start running,
		# without waiting for the email sending to complete.
		do @unblock

		Email.send
			to     : to
			from   : from
			subject: subject
			text   : text


	sendInvites: ( ids, hours ) ->

		fromName = Meteor.users.findOne( @userId ).profile.name

		Meteor.users.find( _id: $in: ids ).forEach ( doc, index ) ->

			name    = doc.services.facebook.first_name
			to      = doc.services.facebook.email
			from    = 'dev.scottashmore@gmail.com'
			subject = "#{fromName} has invited you to a race!"
			text    = "Hi #{name}! Your friend #{fromName} has invited you to a race at #{hours}:00 today."

			console.log to, from, subject, text

			# Email.send
			# 	to     : to
			# 	from   : from
			# 	subject: subject
			# 	text   : text


	resetCoords: ->

		for user in Meteor.users.find().fetch()

			Meteor.users.update _id: user._id, 

				$set: 

					'profile.raceCoords': []


	removeLiveRace: ->

		RaceList.remove live: true


	setLiveRace: ->

		query =
			sort: createdAt: 1

		for i in [ 0...3 ]

			length = 1 if i is 0
			length = 2 if i is 1
			length = 5 if i is 2

			id = _.first( RaceList.find( length: length, query ).fetch() )._id

			RaceList.update id, $set: live: true


	insertNewRace: ->

		for i in [ 0...3 ]

			length = 1 if i is 0
			length = 2 if i is 1
			length = 5 if i is 2

			RaceList.insert
				live      : false
				length    : length
				users     : []
				createdAt : new Date
