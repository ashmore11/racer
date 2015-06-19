Meteor.methods

	updateNickname: ( name ) ->

		Meteor.users.update _id: @userId, 
			
			$set:
				
				'profile.nickname': name


	updateCoords: ( lat, lon ) ->

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

		raceList = RaceList.findOne id

		unless raceList
			
			throw new Meteor.Error 404, 'The list was not found'

		if _.contains raceList.users, @userId
		
			RaceList.update id, 

				$pull: 

					users: @userId

		else

			RaceList.update id, 

				$addToSet: 

					users: @userId