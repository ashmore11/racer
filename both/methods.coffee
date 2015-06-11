Meteor.methods
	
	update_distance: ( race_id, user_id, distance ) ->

		RaceList.update _id: race_id, users: $elemMatch: _id: user_id,

			$set: 

			 'users.$.profile.distance': ( distance or '0.00' ) + ' km'


	