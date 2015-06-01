class @HomeView

	constructor: ->

		do @login_with_facebook
		do @update_score

		geoloc = Geolocation.currentLocation()

		if Meteor.userId() and geoloc

			coords =
				accuracy  : geoloc.coords.accuracy
				heading   : geoloc.coords.heading
				latitude  : geoloc.coords.latitude
				longitude : geoloc.coords.longitude
				speed     : geoloc.coords.speed

			fb_id   = Meteor.users.findOne( Meteor.userId() ).services.facebook.id
			img_src = "http://graph.facebook.com/" + fb_id + "/picture/?type=large"

			Meteor.users.update Meteor.userId(), $set:
				'profile.coords' : coords
				'profile.image'  : img_src


	login_with_facebook: ->

		Template.login.events
			
			'click .fa-facebook': ->

				do Meteor.loginWithFacebook


	update_score: ->

		Template.home.events

			'click .update-score': ->

				Meteor.users.update Meteor.userId(), $inc: 
					'profile.score' : 1

			'change select': ( event ) ->

				level = $( event.target ).val()

				Meteor.users.update Meteor.userId(), $set: 
					'profile.skill_level' : level