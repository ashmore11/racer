class @SettingsView

	constructor: ->

		Template.settings.events

			'click .update-score': ->

				Meteor.users.update Meteor.userId(), $inc: 
					'profile.score' : 1

			'change select': ( event ) ->

				level = $( event.target ).val()

				Meteor.users.update Meteor.userId(), $set: 
					'profile.skill_level' : level

			'click .logout': ->

				do Meteor.logout