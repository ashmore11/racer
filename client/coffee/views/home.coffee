class @HomeView

	constructor: ->

		do @login_with_facebook
		do @update_score


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

			'click .logout': ->

				do Meteor.logout