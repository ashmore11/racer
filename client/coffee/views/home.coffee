class @HomeView

	constructor: ->

		do @events
		do @helpers
		do @rendered


	helpers: ->

		Template.home.helpers

			active_users: ->

				return Meteor.users.find().fetch().length

			noNickname: ->

				return !Meteor.user().profile.nickname?


	events: ->

		Template.login.events
			
			'click .login': ->

				do Meteor.loginWithFacebook

		Template.nickname.events

			'submit .nickname': ( event ) ->

				event.preventDefault()

				name = event.target.text.value

				nameExists = Meteor.users.findOne( _id: Meteor.userId, 'profile.nickname': $exists: true )?

				unless nameExists

					Meteor.call 'updateNickname', name


	rendered: ->

		Template.home.rendered = ->

			#