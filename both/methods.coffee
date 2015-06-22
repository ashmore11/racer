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
		
			RaceList.update id, 

				$pull: 

					users: @userId

		else

			RaceList.update id, 

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

		# Update first place by 5 points
		Meteor.users.update _id: firstPlace,

			$inc:

				'profile.points': 5

		return unless secondPlace

		# Update second place by 3 points
		Meteor.users.update _id: secondPlace,

			$inc:

				'profile.points': 3

		return unless thirdPlace

		# Update third place by 1 points
		Meteor.users.update _id: thirdPlace,

			$inc:

				'profile.points': 1

