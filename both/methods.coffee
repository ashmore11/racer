Meteor.methods
	
	update_distance: ( race_id, user_id, distance ) ->

		RaceList.update _id: race_id, users: $elemMatch: _id: user_id,

			$set: 

			 'users.$.profile.distance': ( distance or '0.00' ) + ' km'

		Meteor.users.update _id: user_id,

			$set:

				'profile.distance': ( distance or '0.00' ) + ' km'


	user_in_race: ( race_id, user_id ) ->

		if RaceList.find( _id: race_id, users: $elemMatch: _id: user_id ).fetch().length > 0

			console.log true

		else

			console.log false


	