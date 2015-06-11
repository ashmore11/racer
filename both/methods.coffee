Meteor.methods
	
	update_distance: ( race_id, user_id, distance ) ->

		RaceList.update _id: race_id, users: $elemMatch: _id: user_id,

			$set: 

			 'users.$.profile.distance': ( distance or '0.00' ) + ' km'


	update_users_array: ( id, user ) ->

		if RaceList.find( _id: id, users: $elemMatch: _id: user._id ).fetch().length > 0

			RaceList.update id, $pull: users: user

		else

			RaceList.update id, $push: users: user