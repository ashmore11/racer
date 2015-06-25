Meteor.methods

	###
	@_CLIENT_TASKS
	###

	updateUser: ( imgSrc, firstName ) ->

		unless @userId

			throw new Meteor.Error 401, 'You must be logged in'

		Meteor.users.update _id: @userId,

			$set: 
				
				'profile.image'     : imgSrc
				'profile.firstName' : firstName


	setUsernameAndPoints: ( name ) ->

		unless @userId

			throw new Meteor.Error 401, 'You must be logged in'

		Meteor.users.update _id: @userId, 
			
			$set:
				
				'profile.username': name
				'profile.points'  : 0


	getFriends: ->

		user  = Meteor.users.findOne @userId
		token = user.services.facebook.accessToken

		url = "https://graph.facebook.com/v2.0/me/friends/?redirect=false"

		params =
			access_token: token

		ids = []

		data = HTTP.get( url, params: params ).data.data
			
		ids.push item.id for item in data

		Meteor.users.update _id: @userId,

			$set:

				'profile.friends': ids


	updateCoords: ( lat, lon ) ->

		unless @userId

			throw new Meteor.Error 401, 'You must be logged in'

		Meteor.users.update _id: @userId,

			$addToSet:

				'profile.raceCoords': { lat: lat, lon: lon }

	
	updateDistance: ( distance ) ->

		unless @userId

			throw new Meteor.Error 401, 'You must be logged in'

		Meteor.users.update _id: @userId,

			$set: 

			 'profile.distance': distance


	updateUsersArray: ( id ) ->

		unless @userId

			throw new Meteor.Error 401, 'You must be logged in'

		race = RaceList.findOne id

		unless race
			
			throw new Meteor.Error 404, 'The list was not found'

		if _.contains race.users, @userId
		
			RaceList.update _id: id, 

				$pull: 

					users: @userId

		else

			RaceList.update _id: id, 

				$addToSet: 

					users: @userId


	updatePoints: ( firstPlace, secondPlace, thirdPlace ) ->

		positions = [
			{ id: firstPlace,  points: 5 }
			{ id: secondPlace, points: 3 }
			{ id: thirdPlace,  points: 1 }
		]

		for position in positions

			break unless position.id

			Meteor.users.update _id: position.id,

				$inc:

					'profile.points': position.points

	###
	@_SERVER_TASKS
	###

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


	resetCoords: ->

		for user in Meteor.users.find().fetch()

			Meteor.users.update _id: user._id, 

				$set: 

					'profile.raceCoords': []


	removeLiveRace: ->

		query =
			sort: createdAt: 1

		id = _.first( RaceList.find( {}, query ).fetch() )._id

		RaceList.remove _id: id


	setLiveRace: ->

		query =
			sort: createdAt: 1

		id = _.first( RaceList.find( {}, query ).fetch() )._id

		RaceList.update id,

			$set:

				live: true


	insertNewRace: ->

		RaceList.insert
			live      : false
			length    : 5
			users     : []
			createdAt : new Date





