Meteor.methods

	updateUser: ( imgSrc, firstName ) ->

		Meteor.users.update _id: @userId,

			$set: 
				
				'profile.image'     : imgSrc
				'profile.firstName' : firstName
				'profile.points'    : 0


	updateUsername: ( name ) ->

		Meteor.users.update _id: @userId, 
			
			$set:
				
				'profile.username': name


	updateCoords: ( lat, lon ) ->

		Meteor.users.update _id: @userId,

			$addToSet:

				'profile.raceCoords': { lat: lat, lon: lon }

	resetCoords: ->

		for user in Meteor.users.find().fetch()

			Meteor.users.update _id: user._id, 

				$set: 

					'profile.raceCoords': []

	
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


	removeLiveRace: ->

		id = _.first( RaceList.find( {}, { sort: { createdAt: 1 } } ).fetch() )._id

		RaceList.remove _id: id


	setLiveRace: ->

		id = _.first( RaceList.find( {}, { sort: { createdAt: 1 } } ).fetch() )._id

		RaceList.update id,

			$set:

				live: true


	insertNewRace: ->

		RaceList.insert
			live      : false
			length    : 5
			users     : []
			createdAt : new Date





